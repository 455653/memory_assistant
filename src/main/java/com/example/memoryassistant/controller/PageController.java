package com.example.memoryassistant.controller;

import com.example.memoryassistant.entity.Flashcard;
import com.example.memoryassistant.entity.FlashcardDeck;
import com.example.memoryassistant.entity.SysUser;
import com.example.memoryassistant.service.CardService;
import com.example.memoryassistant.service.DeckService;
import com.example.memoryassistant.service.ReviewService;
import com.example.memoryassistant.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

/**
 * 页面跳转控制器
 * 负责 JSP 页面的跳转和数据传递
 */
@Controller
public class PageController {

    private final UserService userService;
    private final ReviewService reviewService;
    private final DeckService deckService;
    private final CardService cardService;

    public PageController(UserService userService, ReviewService reviewService, DeckService deckService, CardService cardService) {
        this.userService = userService;
        this.reviewService = reviewService;
        this.deckService = deckService;
        this.cardService = cardService;
    }

    /**
     * 首页 - 跳转到登录页
     */
    @GetMapping("/")
    public String index() {
        return "redirect:/login";
    }

    /**
     * 登录页面
     */
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    /**
     * 登录处理
     */
    @PostMapping("/login")
    public String login(@RequestParam String username,
                       @RequestParam String password,
                       HttpSession session,
                       Model model) {
        SysUser user = userService.login(username, password);
        if (user != null) {
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("nickname", user.getNickname());
            return "redirect:/dashboard";
        } else {
            model.addAttribute("error", "用户名或密码错误");
            return "login";
        }
    }

    /**
     * 退出登录
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    /**
     * 仪表盘 - 主页面
     */
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        // 获取今日需要复习的卡片
        List<Flashcard> dueCards = reviewService.getDueCards(userId);
        model.addAttribute("dueCards", dueCards);
        model.addAttribute("dueCount", dueCards.size());

        // 获取用户的卡组
        List<FlashcardDeck> decks = deckService.getUserDecks(userId);
        model.addAttribute("decks", decks);

        return "dashboard";
    }

    /**
     * 复习页面
     */
    @GetMapping("/review")
    public String reviewPage(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        // 从 Session 中获取用户选择的卡组ID
        @SuppressWarnings("unchecked")
        List<Long> selectedDeckIds = (List<Long>) session.getAttribute("selectedDeckIds");
        
        // 获取今日需要复习的卡片（按选定的卡组筛选）
        List<Flashcard> dueCards = reviewService.getDueCards(userId, selectedDeckIds);
        
        if (dueCards.isEmpty()) {
            model.addAttribute("message", "恭喜！今天没有需要复习的卡片了！");
            return "review-complete";
        }

        // 获取第一张卡片
        Flashcard currentCard = dueCards.get(0);
        model.addAttribute("card", currentCard);
        model.addAttribute("totalCount", dueCards.size());
        model.addAttribute("currentIndex", 1);

        return "review";
    }

    /**
     * 开始复习 - 用户选择卡组后启动复习
     */
    @PostMapping("/review/start")
    public String startReview(@RequestParam(required = false) List<Long> deckIds,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        // 将用户选择的卡组ID存入 Session
        session.setAttribute("selectedDeckIds", deckIds);
        
        // 重定向到复习页面
        return "redirect:/review";
    }

    /**
     * 卡组管理页面
     */
    @GetMapping("/decks")
    public String decksPage(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        List<FlashcardDeck> decks = deckService.getUserDecks(userId);
        model.addAttribute("decks", decks);

        return "decks";
    }

    /**
     * 卡组详情页面
     */
    @GetMapping("/decks/{deckId}")
    public String deckDetailPage(@PathVariable Long deckId, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        FlashcardDeck deck = deckService.getDeckById(deckId);
        if (deck == null || !deck.getUserId().equals(userId)) {
            return "redirect:/decks";
        }

        List<Flashcard> cards = cardService.getCardsByDeckId(deckId);
        model.addAttribute("deck", deck);
        model.addAttribute("cards", cards);

        return "deck-detail";
    }

    /**
     * 创建卡组处理
     */
    @PostMapping("/decks/create")
    public String createDeck(@RequestParam String deckName,
                            @RequestParam(required = false) String description,
                            @RequestParam(required = false) String category,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        FlashcardDeck deck = new FlashcardDeck();
        deck.setUserId(userId);
        deck.setDeckName(deckName);
        deck.setDescription(description);
        deck.setCategory(category);
        
        deckService.createDeck(deck);
        
        redirectAttributes.addFlashAttribute("success", "卡组创建成功！");
        return "redirect:/decks";
    }

    /**
     * 更新卡组处理
     */
    @PostMapping("/decks/{deckId}/update")
    public String updateDeck(@PathVariable Long deckId,
                            @RequestParam String deckName,
                            @RequestParam(required = false) String description,
                            @RequestParam(required = false) String category,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        FlashcardDeck deck = deckService.getDeckById(deckId);
        if (deck == null || !deck.getUserId().equals(userId)) {
            return "redirect:/decks";
        }

        deck.setDeckName(deckName);
        deck.setDescription(description);
        deck.setCategory(category);
        
        deckService.updateDeck(deck);
        
        redirectAttributes.addFlashAttribute("success", "卡组更新成功！");
        return "redirect:/decks";
    }

    /**
     * 删除卡组处理
     */
    @PostMapping("/decks/{deckId}/delete")
    public String deleteDeck(@PathVariable Long deckId,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        FlashcardDeck deck = deckService.getDeckById(deckId);
        if (deck == null || !deck.getUserId().equals(userId)) {
            return "redirect:/decks";
        }

        deckService.deleteDeck(deckId);
        
        redirectAttributes.addFlashAttribute("success", "卡组删除成功！");
        return "redirect:/decks";
    }

    /**
     * 添加卡片到卡组
     */
    @PostMapping("/decks/{deckId}/cards/add")
    public String addCard(@PathVariable Long deckId,
                         @RequestParam String question,
                         @RequestParam String answer,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        FlashcardDeck deck = deckService.getDeckById(deckId);
        if (deck == null || !deck.getUserId().equals(userId)) {
            return "redirect:/decks";
        }

        Flashcard card = new Flashcard();
        card.setDeckId(deckId);
        card.setQuestion(question);
        card.setAnswer(answer);
        
        cardService.createCard(card);
        
        redirectAttributes.addFlashAttribute("success", "卡片添加成功！");
        return "redirect:/decks/" + deckId;
    }

    /**
     * 更新卡片
     */
    @PostMapping("/decks/{deckId}/cards/update")
    public String updateCard(@PathVariable Long deckId,
                            @RequestParam Long id,
                            @RequestParam String question,
                            @RequestParam String answer,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        FlashcardDeck deck = deckService.getDeckById(deckId);
        if (deck == null || !deck.getUserId().equals(userId)) {
            return "redirect:/decks";
        }

        Flashcard card = cardService.getCardById(id);
        if (card == null || !card.getDeckId().equals(deckId)) {
            redirectAttributes.addFlashAttribute("error", "卡片不存在！");
            return "redirect:/decks/" + deckId;
        }

        card.setQuestion(question);
        card.setAnswer(answer);
        
        cardService.updateCard(card);
        
        redirectAttributes.addFlashAttribute("success", "卡片更新成功！");
        return "redirect:/decks/" + deckId;
    }

    /**
     * 删除卡片
     */
    @PostMapping("/decks/{deckId}/cards/{cardId}/delete")
    public String deleteCard(@PathVariable Long deckId,
                            @PathVariable Long cardId,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        FlashcardDeck deck = deckService.getDeckById(deckId);
        if (deck == null || !deck.getUserId().equals(userId)) {
            return "redirect:/decks";
        }

        Flashcard card = cardService.getCardById(cardId);
        if (card == null || !card.getDeckId().equals(deckId)) {
            redirectAttributes.addFlashAttribute("error", "卡片不存在！");
            return "redirect:/decks/" + deckId;
        }

        cardService.deleteCard(cardId);
        
        redirectAttributes.addFlashAttribute("success", "卡片删除成功！");
        return "redirect:/decks/" + deckId;
    }

    /**
     * 批量导入卡片从 Excel 文件
     */
    @PostMapping("/decks/{deckId}/cards/import")
    public String importCards(@PathVariable Long deckId,
                             @RequestParam("file") MultipartFile file,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        FlashcardDeck deck = deckService.getDeckById(deckId);
        if (deck == null || !deck.getUserId().equals(userId)) {
            return "redirect:/decks";
        }

        try {
            int count = cardService.importCards(deckId, file);
            redirectAttributes.addFlashAttribute("success", "成功导入 " + count + " 张卡片！");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "导入失败：" + e.getMessage());
        }
        
        return "redirect:/decks/" + deckId;
    }
}
