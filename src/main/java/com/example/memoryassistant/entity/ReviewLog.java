package com.example.memoryassistant.entity;

import lombok.Data;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 复习记录实体类
 */
@Data
public class ReviewLog {
    /**
     * 记录ID
     */
    private Long id;
    
    /**
     * 卡片ID
     */
    private Long cardId;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 复习时间
     */
    private LocalDateTime reviewDate;
    
    /**
     * 是否记得: 0-忘了, 1-记得
     */
    private Integer isCorrect;
    
    /**
     * 复习前阶段
     */
    private Integer oldStage;
    
    /**
     * 复习后阶段
     */
    private Integer newStage;
    
    /**
     * 复习前下次复习日期
     */
    private LocalDate oldNextReviewDate;
    
    /**
     * 复习后下次复习日期
     */
    private LocalDate newNextReviewDate;
    
    /**
     * 响应时间(秒)
     */
    private Integer responseTime;
}
