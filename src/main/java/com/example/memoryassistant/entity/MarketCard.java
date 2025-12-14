package com.example.memoryassistant.entity;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * VIP商店卡片实体类
 */
@Data
public class MarketCard {
    /**
     * 商品卡片ID
     */
    private Long id;
    
    /**
     * 所属商店卡组ID
     */
    private Long marketDeckId;
    
    /**
     * 问题/正面
     */
    private String question;
    
    /**
     * 答案/背面
     */
    private String answer;
    
    /**
     * 难度等级: 1-简单, 2-中等, 3-困难
     */
    private Integer difficultyLevel;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
    
    /**
     * 状态: 0-禁用, 1-启用
     */
    private Integer status;
}
