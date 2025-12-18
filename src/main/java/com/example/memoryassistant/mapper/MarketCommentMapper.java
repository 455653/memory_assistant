package com.example.memoryassistant.mapper;

import com.example.memoryassistant.dto.MarketCommentDTO;
import com.example.memoryassistant.entity.MarketComment;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * VIP商店评论 Mapper 接口
 */
public interface MarketCommentMapper {
    
    /**
     * 插入评论
     */
    int insert(MarketComment comment);
    
    /**
     * 根据商店卡组ID查询所有评论（关联用户信息）
     * @param marketDeckId 商店卡组ID
     * @return 评论DTO列表
     */
    List<MarketCommentDTO> selectByMarketDeckId(@Param("marketDeckId") Long marketDeckId);
}
