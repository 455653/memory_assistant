package com.example.memoryassistant.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * 每日学习统计数据
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DailyStats {
    /**
     * 日期
     */
    private LocalDate date;
    
    /**
     * 复习次数
     */
    private Integer reviewCount;
    
    /**
     * 正确次数
     */
    private Integer correctCount;
    
    /**
     * 正确率（百分比）
     */
    public Double getCorrectRate() {
        if (reviewCount == null || reviewCount == 0) {
            return 0.0;
        }
        return (correctCount * 100.0) / reviewCount;
    }
}
