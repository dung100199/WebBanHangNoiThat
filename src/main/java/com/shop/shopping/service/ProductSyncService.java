package com.shop.shopping.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shop.shopping.catalog.dto.CatalogImageDto;
import com.shop.shopping.catalog.dto.CatalogOptionDto;
import com.shop.shopping.catalog.dto.CatalogProductDto;
import com.shop.shopping.catalog.dto.CatalogVariantDto;
import com.shop.shopping.model.Product;
import com.shop.shopping.repository.CartItemEntityRepository;
import com.shop.shopping.repository.ProductRepository;
import com.shop.shopping.repository.ReviewRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ProductSyncService {

    private static final Logger log = LoggerFactory.getLogger(ProductSyncService.class);

    private static final Map<String, List<String>> CATEGORY_COLLECTIONS = new LinkedHashMap<>();

    static {
        CATEGORY_COLLECTIONS.put("phong-khach", List.of("phong-khach", "ghe-sofa"));
        CATEGORY_COLLECTIONS.put("phong-ngu", List.of("giuong-ngu", "combo-phong-ngu"));
        CATEGORY_COLLECTIONS.put("phong-bep", List.of("phong-an", "tu-bep"));
        CATEGORY_COLLECTIONS.put("noi-that-van-phong", List.of("phong-lam-viec", "ban-lam-viec"));
        // Không dùng phong-lam-viec cho trường học (tránh trùng, làm trống Nội thất văn phòng)
        CATEGORY_COLLECTIONS.put("noi-that-truong-hoc", List.of());
    }

    private final CatalogApiService catalogApiService;
    private final ProductRepository productRepository;
    private final ReviewRepository reviewRepository;
    private final CartItemEntityRepository cartItemRepository;
    private final ObjectMapper objectMapper;
    private final int pageSize;

    public ProductSyncService(CatalogApiService catalogApiService,
                              ProductRepository productRepository,
                              ReviewRepository reviewRepository,
                              CartItemEntityRepository cartItemRepository,
                              ObjectMapper objectMapper,
                              @Value("${shop.catalog.page-size:50}") int pageSize) {
        this.catalogApiService = catalogApiService;
        this.productRepository = productRepository;
        this.reviewRepository = reviewRepository;
        this.cartItemRepository = cartItemRepository;
        this.objectMapper = objectMapper;
        this.pageSize = pageSize;
    }

    /** Xóa sản phẩm thêm thủ công cũ (không có ID nguồn), rồi đồng bộ lại từ API. */
    @Transactional
    public int syncAll() {
        deleteLegacyProducts();
        int total = 0;
        for (String localCategory : CATEGORY_COLLECTIONS.keySet()) {
            total += syncCategory(localCategory);
        }
        assignWorkRoomProductsToOffice();
        return total;
    }

    /** Gán lại danh mục văn phòng cho mọi SP thuộc collection phòng làm việc. */
    private void assignWorkRoomProductsToOffice() {
        for (String handle : List.of("phong-lam-viec", "ban-lam-viec")) {
            int page = 1;
            while (true) {
                List<CatalogProductDto> batch = catalogApiService.fetchProductsByCollection(handle, page, pageSize);
                if (batch.isEmpty()) {
                    break;
                }
                for (CatalogProductDto item : batch) {
                    if (item.getId() == null) {
                        continue;
                    }
                    productRepository.findByExternalProductId(item.getId()).ifPresent(product -> {
                        product.setCategory("noi-that-van-phong");
                        productRepository.save(product);
                    });
                }
                if (batch.size() < pageSize) {
                    break;
                }
                page++;
            }
        }
    }

    @Transactional
    public int syncCategory(String localCategory) {
        List<String> handles = CATEGORY_COLLECTIONS.get(localCategory);
        if (handles == null || handles.isEmpty()) {
            return 0;
        }

        int synced = 0;
        for (String handle : handles) {
            int page = 1;
            while (true) {
                List<CatalogProductDto> batch = catalogApiService.fetchProductsByCollection(handle, page, pageSize);
                if (batch.isEmpty()) {
                    break;
                }
                for (CatalogProductDto item : batch) {
                    if (upsertProduct(item, localCategory)) {
                        synced++;
                    }
                }
                if (batch.size() < pageSize) {
                    break;
                }
                page++;
            }
        }
        return synced;
    }

    private void deleteLegacyProducts() {
        List<Product> legacy = productRepository.findByExternalProductIdIsNull();
        if (legacy.isEmpty()) {
            return;
        }
        List<Integer> ids = legacy.stream().map(Product::getId).toList();
        reviewRepository.deleteByProductIdIn(ids);
        cartItemRepository.deleteByProductIdIn(ids);
        productRepository.deleteAll(legacy);
    }

    private boolean upsertProduct(CatalogProductDto source, String localCategory) {
        if (source.getId() == null || source.getTitle() == null) {
            return false;
        }

        Optional<Product> existing = productRepository.findByExternalProductId(source.getId());
        Product product = existing.orElseGet(Product::new);

        if (existing.isEmpty()) {
            product.setExternalProductId(source.getId());
        }

        product.setCategory(localCategory);
        product.setName(source.getTitle());
        product.setImage(resolveImage(source));
        product.setPrice(resolvePrice(source));
        product.setCompareAtPrice(resolveComparePrice(source));
        product.setProductType(source.getProductType());
        product.setVendor(source.getVendor());
        product.setDescription(sanitizeDescription(source.getBodyHtml()));
        product.setOptionsJson(toJson(source.getOptions()));
        product.setVariantsJson(buildVariantsJson(source));

        productRepository.save(product);
        return true;
    }

    private String toJson(Object value) {
        if (value == null) {
            return null;
        }
        try {
            return objectMapper.writeValueAsString(value);
        } catch (JsonProcessingException ex) {
            log.warn("Không serialize JSON: {}", ex.getMessage());
            return null;
        }
    }

    private String buildVariantsJson(CatalogProductDto source) {
        if (source.getVariants() == null || source.getVariants().isEmpty()) {
            return null;
        }
        Map<Long, String> imageById = buildImageMap(source);
        String fallbackImage = resolveImage(source);
        List<Map<String, Object>> rows = new ArrayList<>();
        for (CatalogVariantDto variant : source.getVariants()) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("title", blankToNull(variant.getTitle()));
            row.put("option1", blankToNull(variant.getOption1()));
            row.put("option2", blankToNull(variant.getOption2()));
            row.put("option3", blankToNull(variant.getOption3()));
            row.put("sku", blankToNull(variant.getSku()));
            row.put("price", parsePrice(variant.getPrice()));
            row.put("compareAtPrice", parsePriceNullable(variant.getCompareAtPrice()));
            row.put("image", resolveVariantImage(variant, imageById, fallbackImage));
            rows.add(row);
        }
        return toJson(rows);
    }

    private Map<Long, String> buildImageMap(CatalogProductDto source) {
        Map<Long, String> map = new HashMap<>();
        if (source.getImages() == null) {
            return map;
        }
        for (CatalogImageDto image : source.getImages()) {
            if (image.getId() != null && image.getSrc() != null) {
                map.put(image.getId(), normalizeImageSrc(image.getSrc()));
            }
        }
        return map;
    }

    private String resolveVariantImage(CatalogVariantDto variant,
                                       Map<Long, String> imageById,
                                       String fallbackImage) {
        if (variant.getImageId() != null && imageById.containsKey(variant.getImageId())) {
            return imageById.get(variant.getImageId());
        }
        return fallbackImage;
    }

    private String normalizeImageSrc(String src) {
        if (src == null || src.isBlank()) {
            return src;
        }
        if (src.startsWith("//")) {
            return "https:" + src;
        }
        return src;
    }

    private String sanitizeDescription(String html) {
        if (html == null || html.isBlank()) {
            return null;
        }
        String cleaned = html.replaceAll("(?i)<a\\s+[^>]*>", "");
        cleaned = cleaned.replaceAll("(?i)</a>", "");
        return cleaned;
    }

    private String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }

    private double parsePrice(String raw) {
        if (raw == null || raw.isBlank()) {
            return 0;
        }
        return Double.parseDouble(raw.trim());
    }

    private Double parsePriceNullable(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        double value = Double.parseDouble(raw.trim());
        return value > 0 ? value : null;
    }

    private String resolveImage(CatalogProductDto source) {
        if (source.getImage() != null && source.getImage().getSrc() != null) {
            return normalizeImageSrc(source.getImage().getSrc());
        }
        if (source.getImages() != null && !source.getImages().isEmpty()) {
            CatalogImageDto first = source.getImages().get(0);
            if (first != null && first.getSrc() != null) {
                return normalizeImageSrc(first.getSrc());
            }
        }
        return "https://via.placeholder.com/400x300?text=No+Image";
    }

    private double resolvePrice(CatalogProductDto source) {
        if (source.getVariants() == null || source.getVariants().isEmpty()) {
            return 0;
        }
        double min = Double.MAX_VALUE;
        for (CatalogVariantDto variant : source.getVariants()) {
            double value = parsePrice(variant.getPrice());
            if (value > 0 && value < min) {
                min = value;
            }
        }
        return min == Double.MAX_VALUE ? 0 : min;
    }

    private Double resolveComparePrice(CatalogProductDto source) {
        if (source.getVariants() == null || source.getVariants().isEmpty()) {
            return null;
        }
        double maxCompare = 0;
        for (CatalogVariantDto variant : source.getVariants()) {
            Double value = parsePriceNullable(variant.getCompareAtPrice());
            if (value != null && value > maxCompare) {
                maxCompare = value;
            }
        }
        return maxCompare > 0 ? maxCompare : null;
    }
}
