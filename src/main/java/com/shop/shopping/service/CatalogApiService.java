package com.shop.shopping.service;

import com.shop.shopping.catalog.dto.CatalogProductDto;
import com.shop.shopping.catalog.dto.CatalogProductsResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.List;

@Service
public class CatalogApiService {

    private static final Logger log = LoggerFactory.getLogger(CatalogApiService.class);

    private final RestTemplate restTemplate;
    private final String baseUrl;

    public CatalogApiService(RestTemplate restTemplate,
                             @Value("${shop.catalog.base-url:https://moho.com.vn}") String baseUrl) {
        this.restTemplate = restTemplate;
        this.baseUrl = baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
    }

    public List<CatalogProductDto> fetchProductsByCollection(String collectionHandle, int page, int limit) {
        String url = baseUrl + "/collections/" + collectionHandle + "/products.json?limit=" + limit + "&page=" + page;
        try {
            CatalogProductsResponse response = restTemplate.getForObject(url, CatalogProductsResponse.class);
            if (response == null || response.getProducts() == null) {
                return Collections.emptyList();
            }
            return response.getProducts();
        } catch (Exception ex) {
            log.warn("Không lấy được sản phẩm từ {}: {}", url, ex.getMessage());
            return Collections.emptyList();
        }
    }
}
