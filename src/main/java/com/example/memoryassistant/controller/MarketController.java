package com.example.memoryassistant.controller;

import com.example.memoryassistant.dto.MarketCommentDTO;
import com.example.memoryassistant.entity.MarketDeck;
import com.example.memoryassistant.entity.SysUser;
import com.example.memoryassistant.service.MarketService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * VIP商店控制器
 */
@Controller
@RequestMapping("/market")
public class MarketController {

    private final MarketService marketService;

    public MarketController(MarketService marketService) {
        this.marketService = marketService;
    }

    /**
     * VIP商店页面
     */
    @GetMapping
    public String marketPage(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        // 如果是管理员，重定向到管理员后台
        SysUser loginUser = (SysUser) session.getAttribute("loginUser");
        if (loginUser != null && "ADMIN".equals(loginUser.getRole())) {
            return "redirect:/admin/dashboard";
        }

        // 获取所有上架的VIP卡组
        List<MarketDeck> marketDecks = marketService.getAllMarketDecks();
        model.addAttribute("marketDecks", marketDecks);
        model.addAttribute("currentUserId", userId);

        return "market";
    }

    /**
     * VIP卡组详情页面（含评论）
     */
    @GetMapping("/deck/{marketDeckId}")
    public String deckDetail(@PathVariable Long marketDeckId,
                            HttpSession session,
                            Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        // 如果是管理员，重定向到管理员后台
        SysUser loginUser = (SysUser) session.getAttribute("loginUser");
        if (loginUser != null && "ADMIN".equals(loginUser.getRole())) {
            return "redirect:/admin/dashboard";
        }

        // 获取卡组详情
        MarketDeck deck = marketService.getMarketDeckById(marketDeckId);
        if (deck == null) {
            return "redirect:/market";
        }

        // 获取评论列表
        List<MarketCommentDTO> comments = marketService.getComments(marketDeckId);
        
        // 检查用户是否已购买
        boolean hasPurchased = marketService.hasPurchased(userId, marketDeckId);

        model.addAttribute("deck", deck);
        model.addAttribute("comments", comments);
        model.addAttribute("hasPurchased", hasPurchased);
        model.addAttribute("currentUserId", userId);

        return "market-detail";
    }

    /**
     * 购买VIP卡组
     */
    @PostMapping("/buy/{marketDeckId}")
    public String buyDeck(@PathVariable Long marketDeckId,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            // 执行购买逻辑（深拷贝卡组和卡片）
            Long newDeckId = marketService.buyDeck(userId, marketDeckId);
            
            // 购买成功提示
            redirectAttributes.addFlashAttribute("success", 
                "购买成功！VIP卡组已添加到您的账号，快去学习吧！");
            
            return "redirect:/decks";
        } catch (IllegalArgumentException e) {
            // 卡组不存在或已下架，或已购买
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/market";
        } catch (Exception e) {
            // 其他错误
            redirectAttributes.addFlashAttribute("error", "购买失败，请稍后重试");
            return "redirect:/market";
        }
    }

    /**
     * 提交评论
     */
    @PostMapping("/comment")
    public String addComment(@RequestParam Long marketDeckId,
                            @RequestParam String content,
                            @RequestParam(required = false, defaultValue = "5") Integer rating,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            // 添加评论（内部会校验购买权限）
            marketService.addComment(userId, marketDeckId, content, rating);
            
            redirectAttributes.addFlashAttribute("success", "评论发布成功！");
            return "redirect:/market/deck/" + marketDeckId;
        } catch (IllegalArgumentException e) {
            // 权限不足或参数错误
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/market/deck/" + marketDeckId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "评论发布失败，请稍后重试");
            return "redirect:/market/deck/" + marketDeckId;
        }
    }

    /**
     * 提交反馈
     */
    @PostMapping("/feedback")
    public String submitFeedback(@RequestParam Long marketDeckId,
                                 @RequestParam String content,
                                 @RequestParam(required = false) String contactInfo,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            // 提交反馈（内部会校验购买权限）
            marketService.submitFeedback(userId, marketDeckId, content, contactInfo);
            
            redirectAttributes.addFlashAttribute("success", "反馈提交成功，感谢您的建议！");
            return "redirect:/market/deck/" + marketDeckId;
        } catch (IllegalArgumentException e) {
            // 权限不足或参数错误
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/market/deck/" + marketDeckId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "反馈提交失败，请稍后重试");
            return "redirect:/market/deck/" + marketDeckId;
        }
    }
}
