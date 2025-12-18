package com.example.memoryassistant.mapper;

import com.example.memoryassistant.entity.MarketFeedback;

/**
 * VIP商店反馈 Mapper 接口
 */
public interface MarketFeedbackMapper {
    
    /**
     * 插入反馈
     */
    int insert(MarketFeedback feedback);
}
