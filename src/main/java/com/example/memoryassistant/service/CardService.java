package com.example.memoryassistant.service;

import com.example.memoryassistant.entity.Flashcard;
import com.example.memoryassistant.mapper.FlashcardDeckMapper;
import com.example.memoryassistant.mapper.FlashcardMapper;
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
     * 批量导入卡片从 Excel 或 CSV 文件
     * @param deckId 卡组ID
     * @param file Excel 或 CSV 文件
     * @return 导入的卡片数量
     * @throws IOException 文件读取异常
     */
    @Transactional(rollbackFor = Exception.class)
    public int importCards(Long deckId, MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("文件不能为空");
        }

        // 获取文件名和后缀
        String filename = file.getOriginalFilename();
        if (filename == null) {
            throw new IllegalArgumentException("文件名不能为空");
        }

        List<Flashcard> cards;
        
        // 根据文件后缀分流处理
        if (filename.toLowerCase().endsWith(".xlsx")) {
            cards = parseExcelFile(file, deckId);
        } else if (filename.toLowerCase().endsWith(".csv")) {
            cards = parseCsvFile(file, deckId);
        } else {
            throw new IllegalArgumentException("只支持 .xlsx 或 .csv 格式的文件");
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
     * 解析 Excel 文件
     */
    private List<Flashcard> parseExcelFile(MultipartFile file, Long deckId) throws IOException {
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
                Flashcard card = createFlashcard(deckId, question, answer, today);
                cards.add(card);
            }
        }

        return cards;
    }

    /**
     * 解析 CSV 文件（强制 UTF-8 编码）
     */
    private List<Flashcard> parseCsvFile(MultipartFile file, Long deckId) throws IOException {
        List<Flashcard> cards = new ArrayList<>();
        LocalDate today = LocalDate.now();

        // 关键：强制使用 UTF-8 编码读取，防止中文乱码
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8));
             CSVParser csvParser = new CSVParser(reader, 
                CSVFormat.DEFAULT.builder()
                    .setHeader()  // 设置第一行为表头
                    .setSkipHeaderRecord(true)  // 跳过表头
                    .setTrim(true)  // 自动去除空格
                    .build())) {
            
            for (CSVRecord record : csvParser) {
                // 跳过空行
                if (record.size() < 2) {
                    continue;
                }

                // 读取第一列（问题）和第二列（答案）
                String question = record.get(0);
                String answer = record.get(1);

                // 跳过空值
                if (question == null || answer == null || 
                    question.trim().isEmpty() || answer.trim().isEmpty()) {
                    continue;
                }

                // 创建卡片对象
                Flashcard card = createFlashcard(deckId, question.trim(), answer.trim(), today);
                cards.add(card);
            }
        }

        return cards;
    }

    /**
     * 创建卡片对象（公共逻辑）
     */
    private Flashcard createFlashcard(Long deckId, String question, String answer, LocalDate today) {
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
        return card;
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
