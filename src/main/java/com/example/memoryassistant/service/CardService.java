package com.example.memoryassistant.service;

import com.example.memoryassistant.entity.Flashcard;
import com.example.memoryassistant.mapper.FlashcardDeckMapper;
import com.example.memoryassistant.mapper.FlashcardMapper;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * 闪卡服务
 */
@Service
public class CardService {

    private final FlashcardMapper cardMapper;
    private final FlashcardDeckMapper deckMapper;

    public CardService(FlashcardMapper cardMapper, FlashcardDeckMapper deckMapper) {
        this.cardMapper = cardMapper;
        this.deckMapper = deckMapper;
    }

    /**
     * 获取用户的所有卡片
     */
    public List<Flashcard> getUserCards(Long userId) {
        return cardMapper.selectByUserId(userId);
    }

    /**
     * 根据卡组ID获取卡片
     */
    public List<Flashcard> getCardsByDeckId(Long deckId) {
        return cardMapper.selectByDeckId(deckId);
    }

    /**
     * 根据ID查询卡片
     */
    public Flashcard getCardById(Long cardId) {
        return cardMapper.selectById(cardId);
    }

    /**
     * 创建卡片
     */
    @Transactional(rollbackFor = Exception.class)
    public Flashcard createCard(Flashcard card) {
        // 初始化默认值
        if (card.getStage() == null) {
            card.setStage(0);
        }
        if (card.getReviewCount() == null) {
            card.setReviewCount(0);
        }
        if (card.getCorrectCount() == null) {
            card.setCorrectCount(0);
        }
        if (card.getWrongCount() == null) {
            card.setWrongCount(0);
        }
        if (card.getDifficulty() == null) {
            card.setDifficulty(new BigDecimal("1.00"));
        }
        if (card.getStatus() == null) {
            card.setStatus(1);
        }
        if (card.getNextReviewDate() == null) {
            card.setNextReviewDate(LocalDate.now());
        }
        
        cardMapper.insert(card);
        
        // 更新卡组的卡片数量
        deckMapper.updateCardCount(card.getDeckId());
        
        return card;
    }

    /**
     * 更新卡片
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateCard(Flashcard card) {
        cardMapper.update(card);
    }

    /**
     * 删除卡片
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteCard(Long cardId) {
        Flashcard card = cardMapper.selectById(cardId);
        if (card != null) {
            cardMapper.deleteById(cardId);
            // 更新卡组的卡片数量
            deckMapper.updateCardCount(card.getDeckId());
        }
    }

    /**
     * 批量导入卡片从 Excel 文件
     * @param deckId 卡组ID
     * @param file Excel 文件
     * @return 导入的卡片数量
     * @throws IOException 文件读取异常
     */
    @Transactional(rollbackFor = Exception.class)
    public int importCards(Long deckId, MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("文件不能为空");
        }

        // 验证文件格式
        String filename = file.getOriginalFilename();
        if (filename == null || !filename.endsWith(".xlsx")) {
            throw new IllegalArgumentException("只支持 .xlsx 格式的 Excel 文件");
        }

        List<Flashcard> cards = new ArrayList<>();
        LocalDate today = LocalDate.now();

        try (Workbook workbook = new XSSFWorkbook(file.getInputStream())) {
            // 读取第一个 Sheet
            Sheet sheet = workbook.getSheetAt(0);
            
            // 遍历行，跳过第一行（表头）
            for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
                Row row = sheet.getRow(rowIndex);
                if (row == null) {
                    continue;
                }

                // 读取第一列（问题）和第二列（答案）
                Cell questionCell = row.getCell(0);
                Cell answerCell = row.getCell(1);

                if (questionCell == null || answerCell == null) {
                    continue;
                }

                String question = getCellValueAsString(questionCell);
                String answer = getCellValueAsString(answerCell);

                // 跳过空行
                if (question.trim().isEmpty() || answer.trim().isEmpty()) {
                    continue;
                }

                // 创建卡片对象
                Flashcard card = new Flashcard();
                card.setDeckId(deckId);
                card.setQuestion(question);
                card.setAnswer(answer);
                card.setStage(0);
                card.setReviewCount(0);
                card.setCorrectCount(0);
                card.setWrongCount(0);
                card.setDifficulty(new BigDecimal("1.00"));
                card.setStatus(1);
                card.setNextReviewDate(today);

                cards.add(card);
            }
        }

        // 批量插入
        if (!cards.isEmpty()) {
            cardMapper.batchInsert(cards);
            // 更新卡组的卡片数量
            deckMapper.updateCardCount(deckId);
        }

        return cards.size();
    }

    /**
     * 获取单元格的字符串值
     */
    private String getCellValueAsString(Cell cell) {
        if (cell == null) {
            return "";
        }

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
