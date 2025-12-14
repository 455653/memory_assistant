package com.example.memoryassistant.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * VIP商店卡组实体类
 */
@Data
public class MarketDeck {
    /**
     * 商品卡组ID
     */
    private Long id;
    
    /**
     * 卡组名称
     */
    private String deckName;
    
    /**
     * 卡组描述
     */
    private String description;
    
    /**
     * 卡组分类
     */
    private String category;
    
    /**
     * 价格（元）
     */
    private BigDecimal price;
    
    /**
     * 封面图URL
     */
    private String coverUrl;
    
    /**
     * 卡片数量
     */
    private Integer cardCount;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
    
    /**
     * 状态: 0-下架, 1-上架
     */
    private Integer status;
}
