package com.shop.shopping.catalog.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class CatalogProductsResponse {
    private List<CatalogProductDto> products;

    public List<CatalogProductDto> getProducts() {
        return products;
    }

    public void setProducts(List<CatalogProductDto> products) {
        this.products = products;
    }
}
