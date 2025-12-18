package com.example.memoryassistant.mapper;

import com.example.memoryassistant.entity.MarketCard;
import com.example.memoryassistant.entity.MarketDeck;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * VIP商店 Mapper 接口
 */
public interface MarketMapper {
    
    /**
     * 查询所有上架的商店卡组
     * @return 商店卡组列表
     */
    List<MarketDeck> selectAllMarketDecks();
    
    /**
     * 根据ID查询商店卡组
     * @param id 卡组ID
     * @return 商店卡组
     */
    MarketDeck selectMarketDeckById(Long id);
    
    /**
     * 根据商店卡组ID查询所有卡片
     * @param marketDeckId 商店卡组ID
     * @return 卡片列表
     */
    List<MarketCard> selectCardsByMarketDeckId(@Param("marketDeckId") Long marketDeckId);
    
    /**
     * 统计VIP卡组总数
     */
    int countAllMarketDecks();
    
    /**
     * 更新卡组状态
     */
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);
    
    /**
     * 插入卡组
     */
    int insert(MarketDeck deck);
    
    /**
     * 更新卡组
     */
    int update(MarketDeck deck);
    
    /**
     * 更新卡组的卡片数量
     */
    int updateCardCount(@Param("id") Long id, @Param("cardCount") int cardCount);
}
