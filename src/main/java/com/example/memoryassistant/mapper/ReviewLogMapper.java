package com.example.memoryassistant.mapper;

import com.example.memoryassistant.entity.ReviewLog;
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
}
