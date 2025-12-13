package com.example.memoryassistant.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 闪卡实体类
 */
@Data
public class Flashcard {
    /**
     * 卡片ID
     */
    private Long id;
    
    /**
     * 所属卡组ID
     */
    private Long deckId;
    
    /**
     * 问题/正面
     */
    private String question;
    
    /**
     * 答案/背面
     */
    private String answer;
    
    /**
     * 下次复习日期
     */
    private LocalDate nextReviewDate;
    
    /**
     * 记忆阶段: 0-新卡片, 1-第1次复习, 2-第2次复习... 7-已完成
     */
    private Integer stage;
    
    /**
     * 复习次数
     */
    private Integer reviewCount;
    
    /**
     * 正确次数
     */
    private Integer correctCount;
    
    /**
     * 错误次数
     */
    private Integer wrongCount;
    
    /**
     * 难度系数: 0.50-2.00
     */
    private BigDecimal difficulty;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
    
    /**
     * 状态: 0-归档, 1-学习中, 2-已掌握
     */
    private Integer status;
}
