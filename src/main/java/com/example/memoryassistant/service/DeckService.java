package com.example.memoryassistant.service;

import com.example.memoryassistant.entity.FlashcardDeck;
import com.example.memoryassistant.mapper.FlashcardDeckMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 卡组服务
 */
@Service
public class DeckService {

    private final FlashcardDeckMapper deckMapper;

    public DeckService(FlashcardDeckMapper deckMapper) {
        this.deckMapper = deckMapper;
    }

    /**
     * 获取用户的所有卡组
     */
    public List<FlashcardDeck> getUserDecks(Long userId) {
        return deckMapper.selectByUserId(userId);
    }

    /**
     * 根据ID查询卡组
     */
    public FlashcardDeck getDeckById(Long deckId) {
        return deckMapper.selectById(deckId);
    }

    /**
     * 创建卡组
     */
    @Transactional(rollbackFor = Exception.class)
    public FlashcardDeck createDeck(FlashcardDeck deck) {
        deck.setCardCount(0);
        deck.setStatus(1);
        deckMapper.insert(deck);
        return deck;
    }

    /**
     * 更新卡组
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateDeck(FlashcardDeck deck) {
        deckMapper.update(deck);
    }

    /**
     * 删除卡组（软删除）
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteDeck(Long deckId) {
        deckMapper.deleteById(deckId);
    }

    /**
     * 更新卡组的卡片数量
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateCardCount(Long deckId) {
        deckMapper.updateCardCount(deckId);
    }
}
