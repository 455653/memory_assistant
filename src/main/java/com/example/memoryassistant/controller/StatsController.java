package com.example.memoryassistant.controller;

import com.example.memoryassistant.service.ReviewService;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * 统计数据 REST 控制器
 * 提供数据统计相关的 AJAX 接口
 */
@RestController
@RequestMapping("/api/stats")
public class StatsController {

    private final ReviewService reviewService;

    public StatsController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    /**
     * 获取近 7 天的学习统计数据
     * @param session HTTP Session
     * @return 统计数据（日期、复习数量、正确率）
     */
    @GetMapping("/weekly")
    public Map<String, Object> getWeeklyStats(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        Map<String, Object> result = new HashMap<>();
        
        if (userId == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }

        try {
            Map<String, Object> stats = reviewService.getLast7DaysStats(userId);
            result.put("success", true);
            result.putAll(stats);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "获取统计数据失败: " + e.getMessage());
        }
        
        return result;
    }
}
