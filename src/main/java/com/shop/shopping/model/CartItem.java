package com.shop.shopping.model;

public class CartItem {

    private Product product;
    private int quantity;
    private String variant;

    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
        this.variant = "";
    }

    public CartItem(Product product, int quantity, String variant) {
        this.product = product;
        this.quantity = quantity;
        this.variant = variant != null ? variant : "";
    }

    public Product getProduct() { return product; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getVariant() { return variant; }
    public void setVariant(String variant) { this.variant = variant; }
}