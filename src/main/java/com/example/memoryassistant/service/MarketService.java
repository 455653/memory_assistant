package com.example.memoryassistant.service;

import com.example.memoryassistant.dto.MarketCommentDTO;
import com.example.memoryassistant.entity.Flashcard;
import com.example.memoryassistant.entity.FlashcardDeck;
import com.example.memoryassistant.entity.MarketCard;
import com.example.memoryassistant.entity.MarketComment;
import com.example.memoryassistant.entity.MarketDeck;
import com.example.memoryassistant.entity.MarketFeedback;
import com.example.memoryassistant.mapper.FlashcardDeckMapper;
import com.example.memoryassistant.mapper.FlashcardMapper;
import com.example.memoryassistant.mapper.MarketCardMapper;
import com.example.memoryassistant.mapper.MarketCommentMapper;
import com.example.memoryassistant.mapper.MarketFeedbackMapper;
import com.example.memoryassistant.mapper.MarketMapper;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * VIP商店服务
 */
@Service
public class MarketService {

    private final MarketMapper marketMapper;
    private final FlashcardDeckMapper deckMapper;
    private final FlashcardMapper flashcardMapper;
    private final MarketCommentMapper commentMapper;
    private final MarketFeedbackMapper feedbackMapper;
    private final MarketCardMapper marketCardMapper;

    public MarketService(MarketMapper marketMapper, 
                        FlashcardDeckMapper deckMapper, 
                        FlashcardMapper flashcardMapper,
                        MarketCommentMapper commentMapper,
                        MarketFeedbackMapper feedbackMapper,
                        MarketCardMapper marketCardMapper) {
        this.marketMapper = marketMapper;
        this.deckMapper = deckMapper;
        this.flashcardMapper = flashcardMapper;
        this.commentMapper = commentMapper;
        this.feedbackMapper = feedbackMapper;
        this.marketCardMapper = marketCardMapper;
    }

    /**
     * 获取所有上架的VIP卡组
     */
    public List<MarketDeck> getAllMarketDecks() {
        return marketMapper.selectAllMarketDecks();
    }

    /**
     * 根据ID获取VIP卡组详情
     */
    public MarketDeck getMarketDeckById(Long id) {
        return marketMapper.selectMarketDeckById(id);
    }

    /**
     * 购买VIP卡组（核心逻辑：深拷贝卡组及卡片到用户账号下）
     * 
     * @param userId 购买用户ID
     * @param marketDeckId VIP卡组ID
     * @return 复制后的用户卡组ID
     */
    @Transactional(rollbackFor = Exception.class)
    public Long buyDeck(Long userId, Long marketDeckId) {
        // 前置检查：用户是否已购买过该卡组
        int count = deckMapper.countByUserIdAndMarketId(userId, marketDeckId);
        if (count > 0) {
            throw new IllegalArgumentException("您已拥有该卡组，无需重复购买");
        }
        
        // 1. 查询商品卡组信息
        MarketDeck marketDeck = marketMapper.selectMarketDeckById(marketDeckId);
        if (marketDeck == null) {
            throw new IllegalArgumentException("VIP卡组不存在或已下架");
        }

        // 2. 创建用户卡组（深拷贝卡组信息）
        FlashcardDeck userDeck = new FlashcardDeck();
        userDeck.setUserId(userId);
        userDeck.setDeckName(marketDeck.getDeckName());
        userDeck.setDescription(marketDeck.getDescription());
        userDeck.setCategory(marketDeck.getCategory());
        userDeck.setCardCount(0); // 初始为0，后续批量插入后会更新
        userDeck.setStatus(1); // 正常状态
        userDeck.setSourceMarketId(marketDeckId); // 设置购买源ID
        
        // 插入卡组，获取生成的卡组ID
        deckMapper.insert(userDeck);
        Long newDeckId = userDeck.getId();

        // 3. 查询该VIP卡组下的所有卡片
        List<MarketCard> marketCards = marketMapper.selectCardsByMarketDeckId(marketDeckId);
        
        if (marketCards != null && !marketCards.isEmpty()) {
            // 4. 批量构建用户卡片对象列表（深拷贝卡片信息）
            List<Flashcard> userFlashcards = new ArrayList<>();
            LocalDate today = LocalDate.now();
            
            for (MarketCard marketCard : marketCards) {
                Flashcard flashcard = new Flashcard();
                
                // 关联到新创建的用户卡组
                flashcard.setDeckId(newDeckId);
                
                // 复制问题和答案
                flashcard.setQuestion(marketCard.getQuestion());
                flashcard.setAnswer(marketCard.getAnswer());
                
                // 初始化复习进度（重置为新卡片状态）
                flashcard.setNextReviewDate(today); // 今天可以开始复习
                flashcard.setStage(0); // 新卡片阶段
                flashcard.setReviewCount(0); // 复习次数为0
                flashcard.setCorrectCount(0); // 正确次数为0
                flashcard.setWrongCount(0); // 错误次数为0
                flashcard.setDifficulty(new BigDecimal("1.00")); // 默认难度系数
                flashcard.setStatus(1); // 学习中状态
                
                userFlashcards.add(flashcard);
            }
            
            // 5. 批量插入卡片到数据库
            flashcardMapper.batchInsert(userFlashcards);
            
            // 6. 更新卡组的卡片数量统计
            deckMapper.updateCardCount(newDeckId);
        }

        return newDeckId;
    }

    /**
     * 添加评论（仅购买用户可评论）
     * 
     * @param userId 用户ID
     * @param marketDeckId 商店卡组ID
     * @param content 评论内容
     * @param rating 评分（1-5星）
     */
    @Transactional(rollbackFor = Exception.class)
    public void addComment(Long userId, Long marketDeckId, String content, Integer rating) {
        // 核心权限校验：检查用户是否购买过该卡组
        int purchaseCount = deckMapper.countByUserIdAndMarketId(userId, marketDeckId);
        if (purchaseCount == 0) {
            throw new IllegalArgumentException("您需要购买后才能评价");
        }
        
        // 验证评分范围
        if (rating == null || rating < 1 || rating > 5) {
            rating = 5; // 默认5星
        }
        
        // 创建评论对象
        MarketComment comment = new MarketComment();
        comment.setMarketDeckId(marketDeckId);
        comment.setUserId(userId);
        comment.setContent(content);
        comment.setRating(rating);
        
        // 插入评论
        commentMapper.insert(comment);
    }

    /**
     * 获取某卡组的所有评论
     * 
     * @param marketDeckId 商店卡组ID
     * @return 评论DTO列表
     */
    public List<MarketCommentDTO> getComments(Long marketDeckId) {
        return commentMapper.selectByMarketDeckId(marketDeckId);
    }

    /**
     * 检查用户是否已购买某卡组
     * 
     * @param userId 用户ID
     * @param marketDeckId 商店卡组ID
     * @return true-已购买, false-未购买
     */
    public boolean hasPurchased(Long userId, Long marketDeckId) {
        int count = deckMapper.countByUserIdAndMarketId(userId, marketDeckId);
        return count > 0;
    }

    /**
     * 提交VIP卡组反馈（仅购买用户可提交）
     * 
     * @param userId 用户ID
     * @param marketDeckId 商店卡组ID
     * @param content 反馈内容
     * @param contactInfo 联系方式（可选）
     */
    @Transactional(rollbackFor = Exception.class)
    public void submitFeedback(Long userId, Long marketDeckId, String content, String contactInfo) {
        // 核心安全校验：检查用户是否购买过该卡组
        int purchaseCount = deckMapper.countByUserIdAndMarketId(userId, marketDeckId);
        if (purchaseCount == 0) {
            throw new IllegalArgumentException("您必须购买该卡组后才能提交反馈");
        }
        
        // 验证反馈内容
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("反馈内容不能为空");
        }
        
        // 创建反馈对象
        MarketFeedback feedback = new MarketFeedback();
        feedback.setMarketDeckId(marketDeckId);
        feedback.setUserId(userId);
        feedback.setContent(content.trim());
        feedback.setContactInfo(contactInfo != null ? contactInfo.trim() : null);
        feedback.setStatus(0); // 默认待处理
        
        // 插入反馈
        feedbackMapper.insert(feedback);
    }
    
    /**
     * 管理员创建VIP卡组（含文件导入）
     * 
     * @param deckName 卡组名称
     * @param description 卡组描述
     * @param category 分类
     * @param price 价格
     * @param file 导入文件 (CSV/XLSX)
     * @return 创建的卡组ID
     */
    @Transactional(rollbackFor = Exception.class)
    public Long createMarketDeck(String deckName, String description, String category, 
                                 BigDecimal price, MultipartFile file) throws IOException {
        // 1. 创建VIP卡组
        MarketDeck deck = new MarketDeck();
        deck.setDeckName(deckName);
        deck.setDescription(description);
        deck.setCategory(category);
        deck.setPrice(price);
        deck.setCardCount(0);
        deck.setStatus(1); // 默认上架
        
        marketMapper.insert(deck);
        Long deckId = deck.getId();
        
        // 2. 解析并导入卡片
        if (file != null && !file.isEmpty()) {
            List<MarketCard> cards = parseCardsFromFile(file, deckId);
            if (!cards.isEmpty()) {
                marketCardMapper.batchInsert(cards);
                // 更新卡片数量
                marketMapper.updateCardCount(deckId, cards.size());
            }
        }
        
        return deckId;
    }
    
    /**
     * 管理员更新VIP卡组
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateMarketDeck(Long id, String deckName, String description, 
                                 String category, BigDecimal price) {
        MarketDeck deck = new MarketDeck();
        deck.setId(id);
        deck.setDeckName(deckName);
        deck.setDescription(description);
        deck.setCategory(category);
        deck.setPrice(price);
        
        marketMapper.update(deck);
    }
    
    /**
     * 管理员追加导入卡片
     */
    @Transactional(rollbackFor = Exception.class)
    public int importMoreCards(Long deckId, MultipartFile file) throws IOException {
        List<MarketCard> cards = parseCardsFromFile(file, deckId);
        if (!cards.isEmpty()) {
            marketCardMapper.batchInsert(cards);
            // 更新卡片数量
            int totalCount = marketCardMapper.countByDeckId(deckId);
            marketMapper.updateCardCount(deckId, totalCount);
        }
        return cards.size();
    }
    
    /**
     * 管理员更新单张卡片
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateMarketCard(Long id, String question, String answer, Integer difficultyLevel) {
        MarketCard card = new MarketCard();
        card.setId(id);
        card.setQuestion(question);
        card.setAnswer(answer);
        card.setDifficultyLevel(difficultyLevel);
        
        marketCardMapper.update(card);
    }
    
    /**
     * 管理员删除卡片
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteMarketCard(Long cardId, Long deckId) {
        marketCardMapper.deleteById(cardId);
        // 更新卡片数量
        int totalCount = marketCardMapper.countByDeckId(deckId);
        marketMapper.updateCardCount(deckId, totalCount);
    }
    
    /**
     * 获取卡组下的所有卡片
     */
    public List<MarketCard> getMarketCards(Long deckId) {
        return marketCardMapper.selectByDeckId(deckId);
    }
    
    /**
     * 解析文件（复用CardService的逻辑）
     */
    private List<MarketCard> parseCardsFromFile(MultipartFile file, Long deckId) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("文件不能为空");
        }
        
        String filename = file.getOriginalFilename();
        if (filename == null) {
            throw new IllegalArgumentException("文件名不能为空");
        }
        
        if (filename.toLowerCase().endsWith(".xlsx")) {
            return parseExcelFile(file, deckId);
        } else if (filename.toLowerCase().endsWith(".csv")) {
            return parseCsvFile(file, deckId);
        } else {
            throw new IllegalArgumentException("只支持 .xlsx 或 .csv 格式的文件");
        }
    }
    
    /**
     * 解析Excel文件
     */
    private List<MarketCard> parseExcelFile(MultipartFile file, Long deckId) throws IOException {
        List<MarketCard> cards = new ArrayList<>();
        
        try (Workbook workbook = new XSSFWorkbook(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            
            for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
                Row row = sheet.getRow(rowIndex);
                if (row == null) continue;
                
                Cell questionCell = row.getCell(0);
                Cell answerCell = row.getCell(1);
                
                if (questionCell == null || answerCell == null) continue;
                
                String question = getCellValueAsString(questionCell);
                String answer = getCellValueAsString(answerCell);
                
                if (question.trim().isEmpty() || answer.trim().isEmpty()) continue;
                
                MarketCard card = new MarketCard();
                card.setMarketDeckId(deckId);
                card.setQuestion(question.trim());
                card.setAnswer(answer.trim());
                card.setDifficultyLevel(1); // 默认简单
                card.setStatus(1);
                
                cards.add(card);
            }
        }
        
        return cards;
    }
    
    /**
     * 解析CSV文件
     */
    private List<MarketCard> parseCsvFile(MultipartFile file, Long deckId) throws IOException {
        List<MarketCard> cards = new ArrayList<>();
        
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8));
             CSVParser csvParser = new CSVParser(reader, 
                CSVFormat.DEFAULT.builder()
                    .setHeader()
                    .setSkipHeaderRecord(true)
                    .setTrim(true)
                    .build())) {
            
            for (CSVRecord record : csvParser) {
                if (record.size() < 2) continue;
                
                String question = record.get(0);
                String answer = record.get(1);
                
                if (question == null || answer == null || 
                    question.trim().isEmpty() || answer.trim().isEmpty()) {
                    continue;
                }
                
                MarketCard card = new MarketCard();
                card.setMarketDeckId(deckId);
                card.setQuestion(question.trim());
                card.setAnswer(answer.trim());
                card.setDifficultyLevel(1);
                card.setStatus(1);
                
                cards.add(card);
            }
        }
        
        return cards;
    }
    
    /**
     * 获取单元格的字符串值
     */
    private String getCellValueAsString(Cell cell) {
        if (cell == null) return "";
        
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue();
            case NUMERIC -> {
                if (DateUtil.isCellDateFormatted(cell)) {
                    yield cell.getDateCellValue().toString();
                } else {
                    yield String.valueOf((long) cell.getNumericCellValue());
                }
            }
            case BOOLEAN -> String.valueOf(cell.getBooleanCellValue());
            case FORMULA -> cell.getCellFormula();
            default -> "";
        };
    }
}
