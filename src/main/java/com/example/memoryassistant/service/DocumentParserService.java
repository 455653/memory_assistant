package com.example.memoryassistant.service;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;

/**
 * 文档解析服务
 */
@Service
public class DocumentParserService {

    /**
     * 解析PDF文件，提取纯文本
     * 
     * @param file PDF文件
     * @return 提取的文本内容
     */
    public String parsePdf(MultipartFile file) throws IOException {
        try (InputStream inputStream = file.getInputStream();
             PDDocument document = PDDocument.load(inputStream)) {
            
            PDFTextStripper stripper = new PDFTextStripper();
            String text = stripper.getText(document);
            
            return cleanAndChunk(text);
        }
    }

    /**
     * 解析Word文档（.docx），提取纯文本
     * 
     * @param file Word文件
     * @return 提取的文本内容
     */
    public String parseDocx(MultipartFile file) throws IOException {
        try (InputStream inputStream = file.getInputStream();
             XWPFDocument document = new XWPFDocument(inputStream);
             XWPFWordExtractor extractor = new XWPFWordExtractor(document)) {
            
            String text = extractor.getText();
            
            return cleanAndChunk(text);
        }
    }

    /**
     * 清洗并切分文本
     * 策略：由于API Token限制，目前仅取前5000字符发送给AI
     * 
     * TODO: 未来可扩展为多次调用AI处理长文档
     * 
     * @param text 原始文本
     * @return 清洗后的文本（限制长度）
     */
    private String cleanAndChunk(String text) {
        if (text == null || text.isEmpty()) {
            return "";
        }
        
        // 去除多余空白字符
        text = text.replaceAll("\\s+", " ").trim();
        
        // 限制长度为5000字符（约2个2000字符的切片）
        // 这样可以避免Token溢出，同时保留足够的上下文
        if (text.length() > 5000) {
            text = text.substring(0, 5000);
        }
        
        return text;
    }

    /**
     * 根据文件扩展名自动选择解析方法
     * 
     * @param file 上传的文件
     * @return 提取的文本内容
     */
    public String parseDocument(MultipartFile file) throws IOException {
        String filename = file.getOriginalFilename();
        if (filename == null) {
            throw new IllegalArgumentException("文件名不能为空");
        }
        
        String extension = filename.substring(filename.lastIndexOf(".")).toLowerCase();
        
        return switch (extension) {
            case ".pdf" -> parsePdf(file);
            case ".docx" -> parseDocx(file);
            default -> throw new IllegalArgumentException("不支持的文件格式，仅支持 .pdf 和 .docx");
        };
    }
}
