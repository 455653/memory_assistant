package com.example.memoryassistant.mapper;

import com.example.memoryassistant.entity.MarketCard;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * VIP商店卡片 Mapper 接口
 */
public interface MarketCardMapper {
    
    /**
     * 批量插入卡片
     */
    int batchInsert(@Param("cards") List<MarketCard> cards);
    
    /**
     * 根据卡组ID查询卡片列表
     */
    List<MarketCard> selectByDeckId(Long marketDeckId);
    
    /**
     * 根据ID查询卡片
     */
    MarketCard selectById(Long id);
    
    /**
     * 更新卡片
     */
    int update(MarketCard card);
    
    /**
     * 删除卡片
     */
    int deleteById(Long id);
    
    /**
     * 统计卡组下的卡片数量
     */
    int countByDeckId(Long marketDeckId);
}
