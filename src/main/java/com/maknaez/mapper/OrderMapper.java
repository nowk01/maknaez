package com.maknaez.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import com.maknaez.model.OrderDTO;

public interface OrderMapper {
    public int dataCount(Map<String, Object> map) throws SQLException;
    public List<OrderDTO> listOrder(Map<String, Object> map) throws SQLException;
}