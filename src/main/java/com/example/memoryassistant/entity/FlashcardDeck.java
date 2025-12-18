package com.example.memoryassistant.entity;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 卡组实体类
 */
@Data
public class FlashcardDeck {
    /**
     * 卡组ID
     */
    private Long id;
    
    /**
     * 所属用户ID
     */
    private Long userId;
    
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
     * 状态: 0-删除, 1-正常
     */
    private Integer status;
    
    /**
     * 购买源ID: NULL-用户自建, 其他-从商店购买的对应sys_market_deck.id
     */
    private Long sourceMarketId;
}
