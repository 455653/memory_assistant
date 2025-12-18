package com.example.memoryassistant.mapper;

import com.example.memoryassistant.dto.SalesRecordDTO;
import com.example.memoryassistant.entity.FlashcardDeck;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 卡组 Mapper 接口
 */
public interface FlashcardDeckMapper {
    
    /**
     * 根据ID查询卡组
     */
    FlashcardDeck selectById(Long id);
    
    /**
     * 根据用户ID查询卡组列表
     */
    List<FlashcardDeck> selectByUserId(Long userId);
    
    /**
     * 插入卡组
     */
    int insert(FlashcardDeck deck);
    
    /**
     * 更新卡组
     */
    int update(FlashcardDeck deck);
    
    /**
     * 删除卡组
     */
    int deleteById(Long id);
    
    /**
     * 更新卡组的卡片数量
     */
    int updateCardCount(Long deckId);
    
    /**
     * 统计用户是否已购买指定商店卡组
     * @param userId 用户ID
     * @param marketId 商店卡组ID
     * @return 购买次数（0表示未购买，>0表示已购买）
     */
    int countByUserIdAndMarketId(@Param("userId") Long userId, @Param("marketId") Long marketId);
    
    /**
     * 统计所有购买的卡组数量（销量）
     */
    int countPurchasedDecks();
    
    /**
     * 查询所有销售记录
     */
    List<SalesRecordDTO> selectAllSalesRecords();
}
