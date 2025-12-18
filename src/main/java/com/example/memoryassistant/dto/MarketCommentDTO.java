package com.example.memoryassistant.dto;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * VIP商店评论DTO（用于前端展示）
 */
@Data
public class MarketCommentDTO {
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
     * 评论用户名
     */
    private String username;
    
    /**
     * 评论用户昵称
     */
    private String nickname;
    
    /**
     * 评论用户头像URL
     */
    private String avatarUrl;
    
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
