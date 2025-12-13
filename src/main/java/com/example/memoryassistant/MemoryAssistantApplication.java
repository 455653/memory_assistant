package com.example.memoryassistant;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.example.memoryassistant.mapper")
public class MemoryAssistantApplication {

    public static void main(String[] args) {
        SpringApplication.run(MemoryAssistantApplication.class, args);
    }

}
