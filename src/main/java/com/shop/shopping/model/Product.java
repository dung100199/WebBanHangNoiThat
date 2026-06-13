package com.shop.shopping.model;

import jakarta.persistence.*;

@Entity
@Table(name = "product")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;

    private double price;

    private String image;

    private String category;

  /** ID sản phẩm trên nguồn catalog (để đồng bộ) */
  @Column(name = "moho_product_id", unique = true)
  private Long externalProductId;

  /** Giá gốc trước khuyến mãi */
  private Double compareAtPrice;

  @Column(name = "product_type")
  private String productType;

  private String vendor;

  @Column(columnDefinition = "LONGTEXT")
  private String description;

  /** JSON: [{"name":"Màu sắc","values":["Be","Olive"]}, ...] */
  @Column(name = "options_json", columnDefinition = "TEXT")
  private String optionsJson;

  /** JSON: danh sách biến thể (màu, kích thước, giá, SKU) */
  @Column(name = "variants_json", columnDefinition = "LONGTEXT")
  private String variantsJson;

    // ===== GETTER & SETTER =====

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }   

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }   

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Long getExternalProductId() {
        return externalProductId;
    }

    public void setExternalProductId(Long externalProductId) {
        this.externalProductId = externalProductId;
    }

    public Double getCompareAtPrice() {
        return compareAtPrice;
    }

    public void setCompareAtPrice(Double compareAtPrice) {
        this.compareAtPrice = compareAtPrice;
    }

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public String getVendor() {
        return vendor;
    }

    public void setVendor(String vendor) {
        this.vendor = vendor;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getOptionsJson() {
        return optionsJson;
    }

    public void setOptionsJson(String optionsJson) {
        this.optionsJson = optionsJson;
    }

    public String getVariantsJson() {
        return variantsJson;
    }

    public void setVariantsJson(String variantsJson) {
        this.variantsJson = variantsJson;
    }
}