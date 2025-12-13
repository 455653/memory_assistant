package com.example.memoryassistant.service;

import com.example.memoryassistant.entity.Flashcard;
import com.example.memoryassistant.mapper.FlashcardDeckMapper;
import com.example.memoryassistant.mapper.FlashcardMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * 闪卡服务
 */
@Service
public class CardService {

    private final FlashcardMapper cardMapper;
    private final FlashcardDeckMapper deckMapper;

    public CardService(FlashcardMapper cardMapper, FlashcardDeckMapper deckMapper) {
        this.cardMapper = cardMapper;
        this.deckMapper = deckMapper;
    }

    /**
     * 获取用户的所有卡片
     */
    public List<Flashcard> getUserCards(Long userId) {
        return cardMapper.selectByUserId(userId);
    }

    /**
     * 根据卡组ID获取卡片
     */
    public List<Flashcard> getCardsByDeckId(Long deckId) {
        return cardMapper.selectByDeckId(deckId);
    }

    /**
     * 根据ID查询卡片
     */
    public Flashcard getCardById(Long cardId) {
        return cardMapper.selectById(cardId);
    }

    /**
     * 创建卡片
     */
    @Transactional(rollbackFor = Exception.class)
    public Flashcard createCard(Flashcard card) {
        // 初始化默认值
        if (card.getStage() == null) {
            card.setStage(0);
        }
        if (card.getReviewCount() == null) {
            card.setReviewCount(0);
        }
        if (card.getCorrectCount() == null) {
            card.setCorrectCount(0);
        }
        if (card.getWrongCount() == null) {
            card.setWrongCount(0);
        }
        if (card.getDifficulty() == null) {
            card.setDifficulty(new BigDecimal("1.00"));
        }
        if (card.getStatus() == null) {
            card.setStatus(1);
        }
        if (card.getNextReviewDate() == null) {
            card.setNextReviewDate(LocalDate.now());
        }
        
        cardMapper.insert(card);
        
        // 更新卡组的卡片数量
        deckMapper.updateCardCount(card.getDeckId());
        
        return card;
    }

    /**
     * 更新卡片
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateCard(Flashcard card) {
        cardMapper.update(card);
    }

    /**
     * 删除卡片
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteCard(Long cardId) {
        Flashcard card = cardMapper.selectById(cardId);
        if (card != null) {
            cardMapper.deleteById(cardId);
            // 更新卡组的卡片数量
            deckMapper.updateCardCount(card.getDeckId());
        }
    }
}
