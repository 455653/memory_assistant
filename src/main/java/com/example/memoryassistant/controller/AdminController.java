package com.example.memoryassistant.controller;

import com.example.memoryassistant.dto.FeedbackDetailDTO;
import com.example.memoryassistant.entity.MarketDeck;
import com.example.memoryassistant.mapper.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 管理员后台控制器
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    private final SysUserMapper userMapper;
    private final MarketMapper marketMapper;
    private final MarketFeedbackMapper feedbackMapper;
    private final FlashcardDeckMapper deckMapper;

    public AdminController(SysUserMapper userMapper,
                          MarketMapper marketMapper,
                          MarketFeedbackMapper feedbackMapper,
                          FlashcardDeckMapper deckMapper) {
        this.userMapper = userMapper;
        this.marketMapper = marketMapper;
        this.feedbackMapper = feedbackMapper;
        this.deckMapper = deckMapper;
    }

    /**
     * 管理员仪表盘
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        // 统计数据
        int totalUsers = userMapper.countAll();
        int totalMarketDecks = marketMapper.countAllMarketDecks();
        int pendingFeedback = feedbackMapper.countByStatus(0);
        int totalSales = deckMapper.countPurchasedDecks();

        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalMarketDecks", totalMarketDecks);
        model.addAttribute("pendingFeedback", pendingFeedback);
        model.addAttribute("totalSales", totalSales);

        return "admin/dashboard";
    }

    /**
     * VIP卡组管理列表
     */
    @GetMapping("/market")
    public String marketList(Model model) {
        List<MarketDeck> marketDecks = marketMapper.selectAllMarketDecks();
        model.addAttribute("marketDecks", marketDecks);
        return "admin/market_list";
    }

    /**
     * 更新卡组状态（上架/下架）
     */
    @PostMapping("/market/status")
    @ResponseBody
    public Map<String, Object> updateMarketStatus(@RequestParam Long id,
                                                   @RequestParam Integer status) {
        Map<String, Object> result = new HashMap<>();
        try {
            marketMapper.updateStatus(id, status);
            result.put("success", true);
            result.put("message", status == 1 ? "上架成功" : "下架成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
        }
        return result;
    }

    /**
     * 反馈管理列表
     */
    @GetMapping("/feedback")
    public String feedbackList(Model model) {
        List<FeedbackDetailDTO> feedbacks = feedbackMapper.selectAllWithDetail();
        model.addAttribute("feedbacks", feedbacks);
        return "admin/feedback_list";
    }

    /**
     * 更新反馈状态
     */
    @PostMapping("/feedback/status")
    @ResponseBody
    public Map<String, Object> updateFeedbackStatus(@RequestParam Long id,
                                                     @RequestParam Integer status) {
        Map<String, Object> result = new HashMap<>();
        try {
            feedbackMapper.updateStatus(id, status);
            String message = switch (status) {
                case 1 -> "已采纳";
                case 2 -> "已忽略";
                default -> "已处理";
            };
            result.put("success", true);
            result.put("message", message);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
        }
        return result;
    }
}
