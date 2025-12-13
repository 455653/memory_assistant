package com.example.memoryassistant.mapper;

import com.example.memoryassistant.dto.DailyStats;
import com.example.memoryassistant.entity.ReviewLog;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * 复习记录 Mapper 接口
 */
public interface ReviewLogMapper {
    
    /**
     * 根据ID查询复习记录
     */
    ReviewLog selectById(Long id);
    
    /**
     * 根据卡片ID查询复习记录
     */
    List<ReviewLog> selectByCardId(Long cardId);
    
    /**
     * 根据用户ID查询复习记录
     */
    List<ReviewLog> selectByUserId(Long userId);
    
    /**
     * 插入复习记录
     */
    int insert(ReviewLog reviewLog);
    
    /**
     * 查询指定日期范围内的每日统计数据
     * @param userId 用户ID
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 每日统计数据列表
     */
    List<DailyStats> selectDailyStats(@Param("userId") Long userId, 
                                      @Param("startDate") LocalDate startDate, 
                                      @Param("endDate") LocalDate endDate);
}
