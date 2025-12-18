package com.example.memoryassistant.entity;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * VIP商店评论实体类
 */
@Data
public class MarketComment {
    /**
     * 评论ID
     */
    private Long id;
    
    /**
     * 所属商店卡组ID
     */
    private Long marketDeckId;
    
    /**
     * 评论用户ID
     */
    private Long userId;
    
    /**
     * 评论内容
     */
    private String content;
    
    /**
     * 评分: 1-5星
     */
    private Integer rating;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
}
