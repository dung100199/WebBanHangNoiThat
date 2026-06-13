package com.shop.shopping.config;

import com.shop.shopping.repository.ProductRepository;
import com.shop.shopping.service.ProductSyncService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

@Component
@ConditionalOnProperty(name = "shop.catalog.sync-on-startup", havingValue = "true")
public class CatalogStartupSync implements ApplicationRunner {

    private static final Logger log = LoggerFactory.getLogger(CatalogStartupSync.class);

    private final ProductSyncService productSyncService;
    private final ProductRepository productRepository;

    public CatalogStartupSync(ProductSyncService productSyncService, ProductRepository productRepository) {
        this.productSyncService = productSyncService;
        this.productRepository = productRepository;
    }

    @Override
    public void run(ApplicationArguments args) {
        if (productRepository.count() > 0) {
            log.info("Bỏ qua đồng bộ catalog: database đã có sản phẩm.");
            return;
        }
        int synced = productSyncService.syncAll();
        log.info("Đồng bộ catalog khi khởi động: {} sản phẩm.", synced);
    }
}
