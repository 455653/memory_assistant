package com.example.memoryassistant.controller;

import com.example.memoryassistant.entity.Flashcard;
import com.example.memoryassistant.service.ReviewService;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 卡片 REST 控制器
 * 提供 AJAX 接口
 */
@RestController
@RequestMapping("/api/cards")
public class CardController {

    private final ReviewService reviewService;

    public CardController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    /**
     * 获取今日待复习卡片列表
     */
    @GetMapping("/due")
    public Map<String, Object> getDueCards(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        Map<String, Object> result = new HashMap<>();
        
        if (userId == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }

        List<Flashcard> dueCards = reviewService.getDueCards(userId);
        result.put("success", true);
        result.put("cards", dueCards);
        result.put("count", dueCards.size());
        
        return result;
    }

    /**
     * 提交复习反馈 - 核心接口
     * 
     * @param cardId 卡片ID
     * @param feedback 反馈类型: FORGOT(忘了), BLURRY(模糊), REMEMBER(记得)
     */
    @PostMapping("/{cardId}/review")
    public Map<String, Object> submitReview(@PathVariable Long cardId,
                                           @RequestParam String feedback,
                                           HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }

        try {
            // 处理复习反馈（核心算法调用）
            Flashcard updatedCard = reviewService.processReview(cardId, userId, feedback);
            
            // 获取剩余待复习卡片
            List<Flashcard> remainingCards = reviewService.getDueCards(userId);
            
            result.put("success", true);
            result.put("message", "复习记录已保存");
            result.put("updatedCard", updatedCard);
            result.put("remainingCount", remainingCards.size());
            
            // 如果还有卡片，返回下一张
            if (!remainingCards.isEmpty()) {
                result.put("nextCard", remainingCards.get(0));
            }
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "处理失败: " + e.getMessage());
        }
        
        return result;
    }

    /**
     * 获取卡片详情
     */
    @GetMapping("/{cardId}")
    public Map<String, Object> getCard(@PathVariable Long cardId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            Flashcard card = reviewService.getCardById(cardId);
            if (card != null) {
                result.put("success", true);
                result.put("card", card);
            } else {
                result.put("success", false);
                result.put("message", "卡片不存在");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        
        return result;
    }
}
