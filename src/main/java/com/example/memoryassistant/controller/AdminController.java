package com.example.memoryassistant.controller;

import com.example.memoryassistant.dto.FeedbackDetailDTO;
import com.example.memoryassistant.dto.SalesRecordDTO;
import com.example.memoryassistant.entity.MarketCard;
import com.example.memoryassistant.entity.MarketDeck;
import com.example.memoryassistant.entity.SysUser;
import com.example.memoryassistant.mapper.*;
import com.example.memoryassistant.service.MarketService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
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
    private final MarketService marketService;

    public AdminController(SysUserMapper userMapper,
                          MarketMapper marketMapper,
                          MarketFeedbackMapper feedbackMapper,
                          FlashcardDeckMapper deckMapper,
                          MarketService marketService) {
        this.userMapper = userMapper;
        this.marketMapper = marketMapper;
        this.feedbackMapper = feedbackMapper;
        this.deckMapper = deckMapper;
        this.marketService = marketService;
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
    
    /**
     * 用户列表
     */
    @GetMapping("/users")
    public String userList(Model model) {
        List<SysUser> users = userMapper.selectAll();
        model.addAttribute("users", users);
        return "admin/user_list";
    }
    
    /**
     * 销售记录列表
     */
    @GetMapping("/sales")
    public String salesList(Model model) {
        List<SalesRecordDTO> salesRecords = deckMapper.selectAllSalesRecords();
        
        // 计算总销售额
        BigDecimal totalRevenue = salesRecords.stream()
                .map(SalesRecordDTO::getPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        model.addAttribute("salesRecords", salesRecords);
        model.addAttribute("totalRevenue", totalRevenue);
        return "admin/sales_list";
    }
    
    /**
     * VIP卡组创建页面
     */
    @GetMapping("/market/create")
    public String marketCreatePage() {
        return "admin/market_form";
    }
    
    /**
     * VIP卡组编辑页面
     */
    @GetMapping("/market/edit/{id}")
    public String marketEditPage(@PathVariable Long id, Model model) {
        MarketDeck deck = marketMapper.selectMarketDeckById(id);
        if (deck == null) {
            return "redirect:/admin/market";
        }
        
        List<MarketCard> cards = marketService.getMarketCards(id);
        
        model.addAttribute("deck", deck);
        model.addAttribute("cards", cards);
        model.addAttribute("isEdit", true);
        
        return "admin/market_form";
    }
    
    /**
     * 创建VIP卡组
     */
    @PostMapping("/market/create")
    public String createMarketDeck(@RequestParam String deckName,
                                   @RequestParam(required = false) String description,
                                   @RequestParam(required = false) String category,
                                   @RequestParam BigDecimal price,
                                   @RequestParam("file") MultipartFile file,
                                   @RequestParam(value = "coverFile", required = false) MultipartFile coverFile,
                                   RedirectAttributes redirectAttributes) {
        try {
            Long deckId = marketService.createMarketDeck(deckName, description, category, price, file, coverFile);
            redirectAttributes.addFlashAttribute("success", "VIP卡组创建成功！");
            return "redirect:/admin/market/edit/" + deckId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "创建失败：" + e.getMessage());
            return "redirect:/admin/market/create";
        }
    }
    
    /**
     * 更新VIP卡组
     */
    @PostMapping("/market/update")
    public String updateMarketDeck(@RequestParam Long id,
                                   @RequestParam String deckName,
                                   @RequestParam(required = false) String description,
                                   @RequestParam(required = false) String category,
                                   @RequestParam BigDecimal price,
                                   @RequestParam(value = "coverFile", required = false) MultipartFile coverFile,
                                   RedirectAttributes redirectAttributes) {
        try {
            marketService.updateMarketDeck(id, deckName, description, category, price, coverFile);
            redirectAttributes.addFlashAttribute("success", "更新成功！");
            return "redirect:/admin/market/edit/" + id;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "更新失败：" + e.getMessage());
            return "redirect:/admin/market/edit/" + id;
        }
    }
    
    /**
     * 追加导入卡片
     */
    @PostMapping("/market/import")
    public String importMoreCards(@RequestParam Long deckId,
                                  @RequestParam("file") MultipartFile file,
                                  RedirectAttributes redirectAttributes) {
        try {
            int count = marketService.importMoreCards(deckId, file);
            redirectAttributes.addFlashAttribute("success", "成功导入 " + count + " 张卡片！");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "导入失败：" + e.getMessage());
        }
        return "redirect:/admin/market/edit/" + deckId;
    }
    
    /**
     * 更新卡片 (AJAX)
     */
    @PostMapping("/market/card/update")
    @ResponseBody
    public Map<String, Object> updateMarketCard(@RequestParam Long id,
                                                @RequestParam String question,
                                                @RequestParam String answer,
                                                @RequestParam(defaultValue = "1") Integer difficultyLevel) {
        Map<String, Object> result = new HashMap<>();
        try {
            marketService.updateMarketCard(id, question, answer, difficultyLevel);
            result.put("success", true);
            result.put("message", "更新成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "更新失败：" + e.getMessage());
        }
        return result;
    }
    
    /**
     * 删除卡片 (AJAX)
     */
    @PostMapping("/market/card/delete")
    @ResponseBody
    public Map<String, Object> deleteMarketCard(@RequestParam Long id,
                                                @RequestParam Long deckId) {
        Map<String, Object> result = new HashMap<>();
        try {
            marketService.deleteMarketCard(id, deckId);
            result.put("success", true);
            result.put("message", "删除成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "删除失败：" + e.getMessage());
        }
        return result;
    }
}
