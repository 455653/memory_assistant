package com.example.memoryassistant.mapper;

import com.example.memoryassistant.entity.FlashcardDeck;
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
}
