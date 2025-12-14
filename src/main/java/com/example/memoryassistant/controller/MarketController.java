package com.example.memoryassistant.controller;

import com.example.memoryassistant.entity.MarketDeck;
import com.example.memoryassistant.service.MarketService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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

        // 获取所有上架的VIP卡组
        List<MarketDeck> marketDecks = marketService.getAllMarketDecks();
        model.addAttribute("marketDecks", marketDecks);

        return "market";
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
            // 卡组不存在或已下架
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/market";
        } catch (Exception e) {
            // 其他错误
            redirectAttributes.addFlashAttribute("error", "购买失败，请稍后重试");
            return "redirect:/market";
        }
    }
}
