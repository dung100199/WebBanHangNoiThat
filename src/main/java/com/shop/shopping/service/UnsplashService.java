package com.shop.shopping.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.Map;

@Service
public class UnsplashService {

    @Value("${unsplash.access-key}")
    private String accessKey;

    public String getImageUrl(String keyword) {
        try {
            String url = "https://api.unsplash.com/photos/random"
                       + "?query=" + keyword.replace(" ", "+")
                       + "&client_id=" + accessKey;

            RestTemplate rest = new RestTemplate();
            Map<String, Object> result = rest.getForObject(url, Map.class);
            Map<String, String> urls = (Map<String, String>) result.get("urls");
            String imageUrl = urls.get("small");
            return imageUrl.split("\\?")[0] + "?w=400&q=80";

        } catch (Exception e) {
            return "https://via.placeholder.com/400x300?text=No+Image";
        }
    }
}