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
}
