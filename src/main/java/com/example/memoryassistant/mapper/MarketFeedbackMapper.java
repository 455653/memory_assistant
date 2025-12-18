package com.example.memoryassistant.mapper;

import com.example.memoryassistant.dto.FeedbackDetailDTO;
import com.example.memoryassistant.entity.MarketFeedback;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * VIP商店反馈 Mapper 接口
 */
public interface MarketFeedbackMapper {
    
    /**
     * 插入反馈
     */
    int insert(MarketFeedback feedback);
    
    /**
     * 统计指定状态的反馈数量
     */
    int countByStatus(@Param("status") Integer status);
    
    /**
     * 查询所有反馈（关联用户和卡组信息）
     */
    List<FeedbackDetailDTO> selectAllWithDetail();
    
    /**
     * 更新反馈状态
     */
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);
}
