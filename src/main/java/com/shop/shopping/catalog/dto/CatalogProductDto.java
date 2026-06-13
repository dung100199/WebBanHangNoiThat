package com.shop.shopping.catalog.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class CatalogProductDto {
    private Long id;
    private String title;
    private String handle;

    @JsonProperty("product_type")
    private String productType;

    @JsonProperty("body_html")
    private String bodyHtml;

    private String vendor;
    private String tags;

    private List<CatalogOptionDto> options;
    private CatalogImageDto image;
    private List<CatalogImageDto> images;
    private List<CatalogVariantDto> variants;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getHandle() {
        return handle;
    }

    public void setHandle(String handle) {
        this.handle = handle;
    }

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public String getBodyHtml() {
        return bodyHtml;
    }

    public void setBodyHtml(String bodyHtml) {
        this.bodyHtml = bodyHtml;
    }

    public String getVendor() {
        return vendor;
    }

    public void setVendor(String vendor) {
        this.vendor = vendor;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public List<CatalogOptionDto> getOptions() {
        return options;
    }

    public void setOptions(List<CatalogOptionDto> options) {
        this.options = options;
    }

    public CatalogImageDto getImage() {
        return image;
    }

    public void setImage(CatalogImageDto image) {
        this.image = image;
    }

    public List<CatalogImageDto> getImages() {
        return images;
    }

    public void setImages(List<CatalogImageDto> images) {
        this.images = images;
    }

    public List<CatalogVariantDto> getVariants() {
        return variants;
    }

    public void setVariants(List<CatalogVariantDto> variants) {
        this.variants = variants;
    }
}
