package com.example.memoryassistant.service;

import com.example.memoryassistant.entity.Flashcard;
import com.example.memoryassistant.entity.ReviewLog;
import com.example.memoryassistant.mapper.FlashcardMapper;
import com.example.memoryassistant.mapper.ReviewLogMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 复习服务 - 核心业务逻辑
 * 基于艾宾浩斯遗忘曲线实现智能复习算法
 */
@Slf4j
@Service
public class ReviewService {

    /**
     * 艾宾浩斯遗忘曲线间隔数组（天数）
     * 阶段 0: 1天, 阶段 1: 2天, 阶段 2: 4天, 阶段 3: 7天, 阶段 4: 15天, 阶段 5: 30天
     */
    private static final int[] INTERVALS = {1, 2, 4, 7, 15, 30};

    private final FlashcardMapper flashcardMapper;
    private final ReviewLogMapper reviewLogMapper;

    public ReviewService(FlashcardMapper flashcardMapper, ReviewLogMapper reviewLogMapper) {
        this.flashcardMapper = flashcardMapper;
        this.reviewLogMapper = reviewLogMapper;
    }

    /**
     * 获取今日需要复习的卡片列表
     *
     * @param userId 用户ID
     * @return 到期卡片列表
     */
    public List<Flashcard> getDueCards(Long userId) {
        LocalDate today = LocalDate.now();
        return flashcardMapper.selectDueCards(userId, today);
    }

    /**
     * 处理复习反馈 - 核心算法
     *
     * @param cardId   卡片ID
     * @param userId   用户ID
     * @param feedback 用户反馈: "FORGOT"(忘了), "BLURRY"(模糊), "REMEMBER"(记得)
     * @return 更新后的卡片信息
     */
    @Transactional(rollbackFor = Exception.class)
    public Flashcard processReview(Long cardId, Long userId, String feedback) {
        // 1. 查询卡片
        Flashcard card = flashcardMapper.selectById(cardId);
        if (card == null) {
            throw new RuntimeException("卡片不存在: " + cardId);
        }

        // 2. 记录复习前的状态
        Integer oldStage = card.getStage();
        LocalDate oldNextReviewDate = card.getNextReviewDate();
        
        // 3. 根据反馈更新卡片状态
        Integer newStage;
        LocalDate newNextReviewDate;
        Integer isCorrect;
        
        LocalDate today = LocalDate.now();
        
        switch (feedback.toUpperCase()) {
            case "FORGOT":
                // 忘记了：重置到阶段0，明天复习
                newStage = 0;
                newNextReviewDate = today.plusDays(1);
                isCorrect = 0;
                card.setWrongCount(card.getWrongCount() + 1);
                log.info("用户忘记卡片 {}, 重置阶段: {} -> {}", cardId, oldStage, newStage);
                break;
                
            case "BLURRY":
                // 模糊：阶段不变，明天再复习
                newStage = oldStage;
                newNextReviewDate = today.plusDays(1);
                isCorrect = 0;
                card.setWrongCount(card.getWrongCount() + 1);
                log.info("用户对卡片 {} 印象模糊, 阶段保持: {}", cardId, oldStage);
                break;
                
            case "REMEMBER":
                // 记得：阶段+1，根据艾宾浩斯曲线计算下次复习日期
                newStage = oldStage + 1;
                
                // 如果阶段超过最大值，则标记为已掌握
                if (newStage >= INTERVALS.length) {
                    newStage = INTERVALS.length - 1;
                    card.setStatus(2); // 状态改为已掌握
                    newNextReviewDate = today.plusDays(INTERVALS[INTERVALS.length - 1]);
                    log.info("卡片 {} 已完全掌握！", cardId);
                } else {
                    newNextReviewDate = today.plusDays(INTERVALS[newStage]);
                }
                
                isCorrect = 1;
                card.setCorrectCount(card.getCorrectCount() + 1);
                log.info("用户记住卡片 {}, 阶段提升: {} -> {}, 下次复习: {}", 
                        cardId, oldStage, newStage, newNextReviewDate);
                break;
                
            default:
                throw new IllegalArgumentException("无效的反馈类型: " + feedback);
        }
        
        // 4. 更新卡片信息
        card.setStage(newStage);
        card.setNextReviewDate(newNextReviewDate);
        card.setReviewCount(card.getReviewCount() + 1);
        flashcardMapper.update(card);
        
        // 5. 记录复习日志
        ReviewLog log = new ReviewLog();
        log.setCardId(cardId);
        log.setUserId(userId);
        log.setReviewDate(LocalDateTime.now());
        log.setIsCorrect(isCorrect);
        log.setOldStage(oldStage);
        log.setNewStage(newStage);
        log.setOldNextReviewDate(oldNextReviewDate);
        log.setNewNextReviewDate(newNextReviewDate);
        reviewLogMapper.insert(log);
        
        return card;
    }

    /**
     * 获取卡片详情
     */
    public Flashcard getCardById(Long cardId) {
        return flashcardMapper.selectById(cardId);
    }

    /**
     * 获取卡片的复习历史
     */
    public List<ReviewLog> getReviewHistory(Long cardId) {
        return reviewLogMapper.selectByCardId(cardId);
    }
}
