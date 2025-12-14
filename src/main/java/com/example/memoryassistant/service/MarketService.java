package com.example.memoryassistant.service;

import com.example.memoryassistant.entity.Flashcard;
import com.example.memoryassistant.entity.FlashcardDeck;
import com.example.memoryassistant.entity.MarketCard;
import com.example.memoryassistant.entity.MarketDeck;
import com.example.memoryassistant.mapper.FlashcardDeckMapper;
import com.example.memoryassistant.mapper.FlashcardMapper;
import com.example.memoryassistant.mapper.MarketMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * VIP商店服务
 */
@Service
public class MarketService {

    private final MarketMapper marketMapper;
    private final FlashcardDeckMapper deckMapper;
    private final FlashcardMapper flashcardMapper;

    public MarketService(MarketMapper marketMapper, 
                        FlashcardDeckMapper deckMapper, 
                        FlashcardMapper flashcardMapper) {
        this.marketMapper = marketMapper;
        this.deckMapper = deckMapper;
        this.flashcardMapper = flashcardMapper;
    }

    /**
     * 获取所有上架的VIP卡组
     */
    public List<MarketDeck> getAllMarketDecks() {
        return marketMapper.selectAllMarketDecks();
    }

    /**
     * 根据ID获取VIP卡组详情
     */
    public MarketDeck getMarketDeckById(Long id) {
        return marketMapper.selectMarketDeckById(id);
    }

    /**
     * 购买VIP卡组（核心逻辑：深拷贝卡组及卡片到用户账号下）
     * 
     * @param userId 购买用户ID
     * @param marketDeckId VIP卡组ID
     * @return 复制后的用户卡组ID
     */
    @Transactional(rollbackFor = Exception.class)
    public Long buyDeck(Long userId, Long marketDeckId) {
        // 1. 查询商品卡组信息
        MarketDeck marketDeck = marketMapper.selectMarketDeckById(marketDeckId);
        if (marketDeck == null) {
            throw new IllegalArgumentException("VIP卡组不存在或已下架");
        }

        // 2. 创建用户卡组（深拷贝卡组信息）
        FlashcardDeck userDeck = new FlashcardDeck();
        userDeck.setUserId(userId);
        userDeck.setDeckName(marketDeck.getDeckName());
        userDeck.setDescription(marketDeck.getDescription());
        userDeck.setCategory(marketDeck.getCategory());
        userDeck.setCardCount(0); // 初始为0，后续批量插入后会更新
        userDeck.setStatus(1); // 正常状态
        
        // 插入卡组，获取生成的卡组ID
        deckMapper.insert(userDeck);
        Long newDeckId = userDeck.getId();

        // 3. 查询该VIP卡组下的所有卡片
        List<MarketCard> marketCards = marketMapper.selectCardsByMarketDeckId(marketDeckId);
        
        if (marketCards != null && !marketCards.isEmpty()) {
            // 4. 批量构建用户卡片对象列表（深拷贝卡片信息）
            List<Flashcard> userFlashcards = new ArrayList<>();
            LocalDate today = LocalDate.now();
            
            for (MarketCard marketCard : marketCards) {
                Flashcard flashcard = new Flashcard();
                
                // 关联到新创建的用户卡组
                flashcard.setDeckId(newDeckId);
                
                // 复制问题和答案
                flashcard.setQuestion(marketCard.getQuestion());
                flashcard.setAnswer(marketCard.getAnswer());
                
                // 初始化复习进度（重置为新卡片状态）
                flashcard.setNextReviewDate(today); // 今天可以开始复习
                flashcard.setStage(0); // 新卡片阶段
                flashcard.setReviewCount(0); // 复习次数为0
                flashcard.setCorrectCount(0); // 正确次数为0
                flashcard.setWrongCount(0); // 错误次数为0
                flashcard.setDifficulty(new BigDecimal("1.00")); // 默认难度系数
                flashcard.setStatus(1); // 学习中状态
                
                userFlashcards.add(flashcard);
            }
            
            // 5. 批量插入卡片到数据库
            flashcardMapper.batchInsert(userFlashcards);
            
            // 6. 更新卡组的卡片数量统计
            deckMapper.updateCardCount(newDeckId);
        }

        return newDeckId;
    }
}
