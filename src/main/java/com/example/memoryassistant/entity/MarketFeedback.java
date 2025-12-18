package com.example.memoryassistant.entity;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * VIP商店反馈实体类
 */
@Data
public class MarketFeedback {
    /**
     * 反馈ID
     */
    private Long id;
    
    /**
     * 所属商店卡组ID
     */
    private Long marketDeckId;
    
    /**
     * 提交反馈的用户ID
     */
    private Long userId;
    
    /**
     * 反馈内容
     */
    private String content;
    
    /**
     * 联系方式（选填）
     */
    private String contactInfo;
    
    /**
     * 处理状态: 0-待处理, 1-已采纳, 2-忽略
     */
    private Integer status;
    
    /**
     * 提交时间
     */
    private LocalDateTime createTime;
}
