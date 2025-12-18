package com.example.memoryassistant.service;

import com.example.memoryassistant.dto.GeneratedCardDTO;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * DeepSeek AI服务
 */
@Service
public class DeepSeekAIService {

    @Value("${deepseek.api.key}")
    private String apiKey;

    @Value("${deepseek.api.url}")
    private String apiUrl;

    @Value("${deepseek.model}")
    private String model;

    private final OkHttpClient client;
    private final ObjectMapper objectMapper;

    public DeepSeekAIService() {
        this.client = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(60, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .build();
        this.objectMapper = new ObjectMapper();
    }

    /**
     * 调用DeepSeek API生成问答对
     * 
     * @param documentText 文档文本内容
     * @return 生成的卡片列表
     */
    public List<GeneratedCardDTO> generateFlashcards(String documentText) throws IOException {
        // 构建System Prompt
        String systemPrompt = "你是一个专业的助教。请根据用户提供的文本，提取关键知识点，生成5-10个'问题'和'答案'对。" +
                "必须严格返回JSON格式，数组结构，无需Markdown标记。" +
                "格式示例: [{\"question\":\"...\", \"answer\":\"...\"}]";

        // 构建请求体
        String requestBody = String.format("""
                {
                    "model": "%s",
                    "messages": [
                        {
                            "role": "system",
                            "content": "%s"
                        },
                        {
                            "role": "user",
                            "content": "%s"
                        }
                    ],
                    "stream": false
                }
                """,
                model,
                escapeJson(systemPrompt),
                escapeJson(documentText)
        );

        // 创建HTTP请求
        Request request = new Request.Builder()
                .url(apiUrl)
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + apiKey)
                .post(RequestBody.create(requestBody, MediaType.parse("application/json")))
                .build();

        // 发送请求并处理响应
        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("API调用失败: " + response.code() + " - " + response.message());
            }

            String responseBody = response.body().string();
            
            // 解析响应
            return parseResponse(responseBody);
        }
    }

    /**
     * 解析DeepSeek API响应
     * 
     * @param responseBody API响应体
     * @return 生成的卡片列表
     */
    private List<GeneratedCardDTO> parseResponse(String responseBody) throws IOException {
        try {
            // 解析API响应的JSON结构
            JsonNode root = objectMapper.readTree(responseBody);
            JsonNode choices = root.path("choices");
            
            if (choices.isEmpty()) {
                throw new IOException("API响应中没有生成内容");
            }

            // 获取AI生成的内容
            String content = choices.get(0).path("message").path("content").asText();
            
            // 清理可能存在的Markdown代码块标记
            content = cleanJsonContent(content);
            
            // 解析为卡片列表
            return objectMapper.readValue(content, new TypeReference<List<GeneratedCardDTO>>() {});
            
        } catch (Exception e) {
            throw new IOException("解析AI响应失败: " + e.getMessage(), e);
        }
    }

    /**
     * 清理JSON内容中的Markdown标记
     * 
     * @param content 原始内容
     * @return 清理后的JSON字符串
     */
    private String cleanJsonContent(String content) {
        // 去除可能的Markdown代码块标记
        content = content.replaceAll("```json\\s*", "");
        content = content.replaceAll("```\\s*", "");
        content = content.trim();
        
        return content;
    }

    /**
     * 转义JSON字符串中的特殊字符
     * 
     * @param text 原始文本
     * @return 转义后的文本
     */
    private String escapeJson(String text) {
        return text
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
