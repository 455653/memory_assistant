package com.example.memoryassistant.dto;

import lombok.Data;

/**
 * AI生成的卡片DTO
 */
@Data
public class GeneratedCardDTO {
    /**
     * 问题
     */
    private String question;
    
    /**
     * 答案
     */
    private String answer;
}
