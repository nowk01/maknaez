package com.maknaez.service;

import java.util.List;
import java.util.Map;

import com.maknaez.model.ProductDTO;

public interface ProductService {
    public List<ProductDTO> listProduct(Map<String, Object> map);
    public int dataCount(Map<String, Object> map);
}