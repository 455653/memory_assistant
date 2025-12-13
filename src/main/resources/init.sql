
-- 创建数据库
DROP DATABASE IF EXISTS  memory_assistant;
CREATE DATABASE  memory_assistant DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE  memory_assistant;

-- ============================================
-- 1. 用户表 (sys_user)
-- ============================================
CREATE TABLE sys_user (
                          id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
                          username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
                          password VARCHAR(100) NOT NULL COMMENT '密码',
                          email VARCHAR(100) COMMENT '邮箱',
                          nickname VARCHAR(50) COMMENT '昵称',
                          avatar_url VARCHAR(255) COMMENT '头像URL',
                          create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                          update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                          status TINYINT DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ============================================
-- 2. 卡组表 (flashcard_deck)
-- ============================================
CREATE TABLE flashcard_deck (
                                id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '卡组ID',
                                user_id BIGINT NOT NULL COMMENT '所属用户ID',
                                deck_name VARCHAR(100) NOT NULL COMMENT '卡组名称',
                                description TEXT COMMENT '卡组描述',
                                category VARCHAR(50) COMMENT '卡组分类',
                                card_count INT DEFAULT 0 COMMENT '卡片数量',
                                create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                status TINYINT DEFAULT 1 COMMENT '状态: 0-删除, 1-正常',
                                FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='卡组表';

-- ============================================
-- 3. 闪卡表 (flashcard)
-- ============================================
CREATE TABLE flashcard (
                           id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '卡片ID',
                           deck_id BIGINT NOT NULL COMMENT '所属卡组ID',
                           question TEXT NOT NULL COMMENT '问题/正面',
                           answer TEXT NOT NULL COMMENT '答案/背面',
                           next_review_date DATE NOT NULL COMMENT '下次复习日期',
                           stage INT DEFAULT 0 COMMENT '记忆阶段: 0-新卡片, 1-第1次复习, 2-第2次复习... 7-已完成',
                           review_count INT DEFAULT 0 COMMENT '复习次数',
                           correct_count INT DEFAULT 0 COMMENT '正确次数',
                           wrong_count INT DEFAULT 0 COMMENT '错误次数',
                           difficulty DECIMAL(3,2) DEFAULT 1.00 COMMENT '难度系数: 0.50-2.00',
                           create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                           update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                           status TINYINT DEFAULT 1 COMMENT '状态: 0-归档, 1-学习中, 2-已掌握',
                           FOREIGN KEY (deck_id) REFERENCES flashcard_deck(id) ON DELETE CASCADE,
                           INDEX idx_next_review (next_review_date, status),
                           INDEX idx_deck_status (deck_id, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='闪卡表';

-- ============================================
-- 4. 复习记录表 (review_log)
-- ============================================
CREATE TABLE review_log (
                            id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
                            card_id BIGINT NOT NULL COMMENT '卡片ID',
                            user_id BIGINT NOT NULL COMMENT '用户ID',
                            review_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '复习时间',
                            is_correct TINYINT NOT NULL COMMENT '是否记得: 0-忘了, 1-记得',
                            old_stage INT COMMENT '复习前阶段',
                            new_stage INT COMMENT '复习后阶段',
                            old_next_review_date DATE COMMENT '复习前下次复习日期',
                            new_next_review_date DATE COMMENT '复习后下次复习日期',
                            response_time INT COMMENT '响应时间(秒)',
                            FOREIGN KEY (card_id) REFERENCES flashcard(id) ON DELETE CASCADE,
                            FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE CASCADE,
                            INDEX idx_card_date (card_id, review_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='复习记录表';

-- ============================================
-- 测试数据插入
-- ============================================

-- 插入测试用户
INSERT INTO sys_user (username, password, email, nickname, status) VALUES
                                                                       ('testuser', 'password123', 'test@example.com', '测试用户', 1),
                                                                       ('admin', 'admin123', 'admin@example.com', '管理员', 1);

-- 插入测试卡组
INSERT INTO flashcard_deck (user_id, deck_name, description, category, card_count) VALUES
                                                                                       (1, 'Java 基础知识', '包含 Java 核心概念和语法', '编程', 5),
                                                                                       (1, '英语单词', '常用英语词汇记忆', '语言', 3),
                                                                                       (2, 'Spring Boot 知识点', 'Spring Boot 框架学习', '编程', 2);

-- 插入测试闪卡
-- 即将到期的卡片（今天需要复习）
INSERT INTO flashcard (deck_id, question, answer, next_review_date, stage, review_count, correct_count, wrong_count, difficulty, status) VALUES
    (1, 'Java 中 String 是可变的吗？', 'String 是不可变的（immutable）。String 类被声明为 final，其内部的 char[] value 数组也是 final 的。', CURDATE(), 2, 2, 2, 0, 1.00, 1);

-- 明天需要复习的卡片
INSERT INTO flashcard (deck_id, question, answer, next_review_date, stage, review_count, correct_count, wrong_count, difficulty, status) VALUES
    (1, '什么是 JVM？', 'JVM（Java Virtual Machine）是 Java 虚拟机，它是 Java 程序的运行环境，负责将字节码解释或编译为机器码执行。', DATE_ADD(CURDATE(), INTERVAL 1 DAY), 3, 3, 3, 0, 1.00, 1);

-- 新卡片（今天需要学习）
INSERT INTO flashcard (deck_id, question, answer, next_review_date, stage, review_count, correct_count, wrong_count, difficulty, status) VALUES
                                                                                                                                             (1, 'Java 中 == 和 equals() 的区别是什么？', '== 比较的是引用（内存地址），equals() 比较的是对象的内容。对于基本数据类型，== 比较值；对于引用类型，== 比较地址。', CURDATE(), 0, 0, 0, 0, 1.00, 1),
                                                                                                                                             (1, '什么是多态？', '多态是面向对象编程的三大特性之一，指同一个方法调用可以产生不同的行为。Java 中通过继承、接口实现和方法重写来实现多态。', CURDATE(), 0, 0, 0, 0, 1.00, 1);

-- 英语单词卡片
INSERT INTO flashcard (deck_id, question, answer, next_review_date, stage, review_count, correct_count, wrong_count, difficulty, status) VALUES
                                                                                                                                             (2, 'algorithm', 'n. 算法；运算法则', DATE_ADD(CURDATE(), INTERVAL 2 DAY), 4, 4, 4, 0, 0.80, 1),
                                                                                                                                             (2, 'implement', 'v. 实施；执行；实现', CURDATE(), 1, 1, 0, 1, 1.50, 1),
                                                                                                                                             (2, 'framework', 'n. 框架；体系；结构', DATE_ADD(CURDATE(), INTERVAL 7 DAY), 5, 5, 5, 0, 0.90, 1);

-- Spring Boot 卡片
INSERT INTO flashcard (deck_id, question, answer, next_review_date, stage, review_count, correct_count, wrong_count, difficulty, status) VALUES
                                                                                                                                             (3, '什么是 Spring Boot 自动配置？', 'Spring Boot 自动配置是一种基于约定优于配置的机制，通过 @EnableAutoConfiguration 注解自动配置 Spring 应用所需的 Bean。', CURDATE(), 0, 0, 0, 0, 1.00, 1),
                                                                                                                                             (3, 'Spring Boot 启动类的作用是什么？', '启动类使用 @SpringBootApplication 注解，是应用的入口点，负责启动 Spring 容器并自动扫描配置。', DATE_ADD(CURDATE(), INTERVAL 3 DAY), 3, 3, 3, 0, 1.00, 1);

-- 插入部分复习记录
INSERT INTO review_log (card_id, user_id, is_correct, old_stage, new_stage, old_next_review_date, new_next_review_date, response_time) VALUES
                                                                                                                                           (1, 1, 1, 1, 2, DATE_SUB(CURDATE(), INTERVAL 2 DAY), CURDATE(), 5),
                                                                                                                               (1, 1, 1, 0, 1, DATE_SUB(CURDATE(), INTERVAL 3 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 8),
                                                                                                                                           (2, 1, 1, 2, 3, DATE_SUB(CURDATE(), INTERVAL 7 DAY), DATE_ADD(CURDATE(), INTERVAL 1 DAY), 6),
                                                                                                                                           (5, 1, 1, 3, 4, DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_ADD(CURDATE(), INTERVAL 2 DAY), 4),
                                                                                                                                           (7, 1, 0, 0, 1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), CURDATE(), 12);
