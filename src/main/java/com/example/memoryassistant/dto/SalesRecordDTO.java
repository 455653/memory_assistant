package com.example.memoryassistant.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 销售记录DTO
 */
@Data
public class SalesRecordDTO {
    /**
     * 购买记录ID (flashcard_deck.id)
     */
    private Long purchaseId;
    
    /**
     * 购买用户名
     */
    private String username;
    
    /**
     * 用户昵称
     */
    private String nickname;
    
    /**
     * 卡组名称
     */
    private String deckName;
    
    /**
     * 购买价格
     */
    private BigDecimal price;
    
    /**
     * 购买时间
     */
    private LocalDateTime purchaseTime;
}
