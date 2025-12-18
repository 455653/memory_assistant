package com.example.memoryassistant.controller;

import com.example.memoryassistant.dto.GeneratedCardDTO;
import com.example.memoryassistant.entity.Flashcard;
import com.example.memoryassistant.entity.FlashcardDeck;
import com.example.memoryassistant.mapper.FlashcardDeckMapper;
import com.example.memoryassistant.mapper.FlashcardMapper;
import com.example.memoryassistant.service.DeepSeekAIService;
import com.example.memoryassistant.service.DocumentParserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * AI自动制卡控制器
 */
@Controller
@RequestMapping("/deck/ai")
public class AiDeckController {

    private final DocumentParserService documentParserService;
    private final DeepSeekAIService deepSeekAIService;
    private final FlashcardDeckMapper deckMapper;
    private final FlashcardMapper flashcardMapper;

    public AiDeckController(DocumentParserService documentParserService,
                           DeepSeekAIService deepSeekAIService,
                           FlashcardDeckMapper deckMapper,
                           FlashcardMapper flashcardMapper) {
        this.documentParserService = documentParserService;
        this.deepSeekAIService = deepSeekAIService;
        this.deckMapper = deckMapper;
        this.flashcardMapper = flashcardMapper;
    }

    /**
     * 显示AI创建卡组页面
     */
    @GetMapping("/create")
    public String createPage(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        return "ai_create";
    }

    /**
     * 阶段一：上传文档并预览AI生成的卡片
     */
    @PostMapping("/preview")
    public String preview(@RequestParam("file") MultipartFile file,
                         @RequestParam(value = "deckName", required = false) String deckName,
                         HttpSession session,
                         Model model,
                         RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            // 验证文件
            if (file.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "请选择要上传的文件");
                return "redirect:/deck/ai/create";
            }

            // 1. 解析文档
            String documentText = documentParserService.parseDocument(file);
            
            if (documentText.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "文档内容为空，无法生成卡片");
                return "redirect:/deck/ai/create";
            }

            // 2. 调用AI生成卡片
            List<GeneratedCardDTO> generatedCards = deepSeekAIService.generateFlashcards(documentText);

            if (generatedCards == null || generatedCards.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "AI未能生成有效的卡片，请尝试其他文档");
                return "redirect:/deck/ai/create";
            }

            // 3. 存入Session（避免重复调用AI）
            session.setAttribute("generatedCards", generatedCards);
            
            // 设置默认卡组名称
            if (deckName == null || deckName.isEmpty()) {
                String filename = file.getOriginalFilename();
                deckName = filename != null ? filename.substring(0, filename.lastIndexOf(".")) : "AI生成卡组";
            }
            session.setAttribute("tempDeckName", deckName);

            // 4. 跳转到预览页面
            model.addAttribute("cards", generatedCards);
            model.addAttribute("deckName", deckName);
            
            return "ai_preview";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "处理失败: " + e.getMessage());
            return "redirect:/deck/ai/create";
        }
    }

    /**
     * 阶段二：保存用户选择的卡片
     */
    @PostMapping("/save")
    public String save(@RequestParam("deckName") String deckName,
                      @RequestParam(value = "selectedIndices", required = false) List<Integer> selectedIndices,
                      HttpSession session,
                      RedirectAttributes redirectAttributes) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            // 从Session获取生成的卡片
            @SuppressWarnings("unchecked")
            List<GeneratedCardDTO> generatedCards = (List<GeneratedCardDTO>) session.getAttribute("generatedCards");

            if (generatedCards == null || generatedCards.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "未找到生成的卡片，请重新上传文档");
                return "redirect:/deck/ai/create";
            }

            // 如果没有选择任何卡片，默认全选
            if (selectedIndices == null || selectedIndices.isEmpty()) {
                selectedIndices = new ArrayList<>();
                for (int i = 0; i < generatedCards.size(); i++) {
                    selectedIndices.add(i);
                }
            }

            // 1. 创建新卡组
            FlashcardDeck deck = new FlashcardDeck();
            deck.setUserId(userId);
            deck.setDeckName(deckName);
            deck.setDescription("由AI自动生成");
            deck.setCategory("AI生成");
            deck.setCardCount(0);
            deck.setStatus(1);
            
            deckMapper.insert(deck);
            Long newDeckId = deck.getId();

            // 2. 批量插入选中的卡片
            List<Flashcard> flashcards = new ArrayList<>();
            LocalDate today = LocalDate.now();

            for (Integer index : selectedIndices) {
                if (index >= 0 && index < generatedCards.size()) {
                    GeneratedCardDTO cardDTO = generatedCards.get(index);
                    
                    Flashcard flashcard = new Flashcard();
                    flashcard.setDeckId(newDeckId);
                    flashcard.setQuestion(cardDTO.getQuestion());
                    flashcard.setAnswer(cardDTO.getAnswer());
                    flashcard.setNextReviewDate(today);
                    flashcard.setStage(0);
                    flashcard.setReviewCount(0);
                    flashcard.setCorrectCount(0);
                    flashcard.setWrongCount(0);
                    flashcard.setDifficulty(new BigDecimal("1.00"));
                    flashcard.setStatus(1);
                    
                    flashcards.add(flashcard);
                }
            }

            if (!flashcards.isEmpty()) {
                flashcardMapper.batchInsert(flashcards);
                deckMapper.updateCardCount(newDeckId);
            }

            // 3. 清除Session中的临时数据
            session.removeAttribute("generatedCards");
            session.removeAttribute("tempDeckName");

            redirectAttributes.addFlashAttribute("success", 
                "AI卡组创建成功！共导入 " + flashcards.size() + " 张卡片");
            
            return "redirect:/decks";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "保存失败: " + e.getMessage());
            return "redirect:/deck/ai/create";
        }
    }
}
