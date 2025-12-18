package com.example.memoryassistant.dto;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 反馈详情DTO（包含关联信息）
 */
@Data
public class FeedbackDetailDTO {
    /**
     * 反馈ID
     */
    private Long id;
    
    /**
     * 商店卡组ID
     */
    private Long marketDeckId;
    
    /**
     * 卡组名称
     */
    private String deckName;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 用户昵称
     */
    private String userNickname;
    
    /**
     * 用户名
     */
    private String username;
    
    /**
     * 反馈内容
     */
    private String content;
    
    /**
     * 联系方式
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
