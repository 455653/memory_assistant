-- ===================================================
-- VIP 卡组商店数据表初始化脚本
-- ===================================================

-- 1. 创建商店卡组表
CREATE TABLE IF NOT EXISTS sys_market_deck (
    id          BIGINT AUTO_INCREMENT COMMENT '商品卡组ID' PRIMARY KEY,
    deck_name   VARCHAR(100)                       NOT NULL COMMENT '卡组名称',
    description TEXT                               NULL COMMENT '卡组描述',
    category    VARCHAR(50)                        NULL COMMENT '卡组分类',
    price       DECIMAL(10, 2) DEFAULT 0.00        NOT NULL COMMENT '价格（元）',
    cover_url   VARCHAR(255)                       NULL COMMENT '封面图URL',
    card_count  INT            DEFAULT 0           NULL COMMENT '卡片数量',
    create_time DATETIME       DEFAULT CURRENT_TIMESTAMP NULL COMMENT '创建时间',
    update_time DATETIME       DEFAULT CURRENT_TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    status      TINYINT        DEFAULT 1           NULL COMMENT '状态: 0-下架, 1-上架'
) COMMENT 'VIP商店卡组表' CHARSET = utf8mb4;

-- 2. 创建商店卡片表
CREATE TABLE IF NOT EXISTS sys_market_card (
    id               BIGINT AUTO_INCREMENT COMMENT '商品卡片ID' PRIMARY KEY,
    market_deck_id   BIGINT                             NOT NULL COMMENT '所属商店卡组ID',
    question         TEXT                               NOT NULL COMMENT '问题/正面',
    answer           TEXT                               NOT NULL COMMENT '答案/背面',
    difficulty_level INT      DEFAULT 1                 NULL COMMENT '难度等级: 1-简单, 2-中等, 3-困难',
    create_time      DATETIME DEFAULT CURRENT_TIMESTAMP NULL COMMENT '创建时间',
    update_time      DATETIME DEFAULT CURRENT_TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    status           TINYINT  DEFAULT 1                 NULL COMMENT '状态: 0-禁用, 1-启用',
    CONSTRAINT fk_market_card_deck
        FOREIGN KEY (market_deck_id) REFERENCES sys_market_deck (id)
            ON DELETE CASCADE
) COMMENT 'VIP商店卡片表' CHARSET = utf8mb4;

-- 创建索引
CREATE INDEX idx_market_deck_id ON sys_market_card (market_deck_id);

-- ===================================================
-- 3. 插入测试数据
-- ===================================================

-- 插入测试卡组 1: 托福核心词汇
INSERT INTO sys_market_deck (deck_name, description, category, price, cover_url, card_count, status)
VALUES ('托福核心词汇精选', 
        '精选托福考试高频词汇500个，涵盖听说读写各个部分，助你快速突破词汇关！', 
        '英语学习', 
        19.99, 
        'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=400', 
        5, 
        1);

-- 插入测试卡组 2: Java面试高频题
INSERT INTO sys_market_deck (deck_name, description, category, price, cover_url, card_count, status)
VALUES ('Java面试高频题库', 
        '汇总BAT等一线互联网公司Java面试真题，涵盖集合、并发、JVM、Spring等核心知识点', 
        '编程开发', 
        29.99, 
        'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400', 
        5, 
        1);

-- 为卡组1插入卡片数据（托福词汇）
INSERT INTO sys_market_card (market_deck_id, question, answer, difficulty_level, status)
VALUES 
(1, 'abandon', 'v. 放弃；抛弃\nn. 放任；狂热\n例句：He abandoned his family and went abroad.\n他抛弃家庭，出国去了。', 1, 1),
(1, 'ambiguous', 'adj. 模棱两可的；含糊不清的\n例句：His answer was ambiguous.\n他的回答模棱两可。', 2, 1),
(1, 'arbitrary', 'adj. 任意的；武断的；专制的\n例句：The choice of players for the team seemed completely arbitrary.\n球队挑选队员似乎完全是任意的。', 2, 1),
(1, 'comprehensive', 'adj. 综合的；全面的；广泛的\nn. 综合学校\n例句：The government gave a comprehensive explanation of its plans.\n政府对其计划作了全面的解释。', 2, 1),
(1, 'sophisticated', 'adj. 复杂的；精致的；富有经验的\n例句：Medical techniques are becoming more sophisticated all the time.\n医疗技术日益复杂精妙。', 3, 1);

-- 为卡组2插入卡片数据（Java面试题）
INSERT INTO sys_market_card (market_deck_id, question, answer, difficulty_level, status)
VALUES 
(2, 'HashMap 和 Hashtable 的区别是什么？', 
'1. 线程安全：Hashtable是线程安全的，HashMap不是\n2. null值：HashMap允许一个null键和多个null值，Hashtable不允许null\n3. 性能：HashMap性能更好（无同步开销）\n4. 继承：HashMap继承AbstractMap，Hashtable继承Dictionary\n5. 推荐使用：现在推荐使用ConcurrentHashMap代替Hashtable', 
2, 1),
(2, '什么是JVM内存模型？请简述各个区域的作用', 
'JVM内存分为以下区域：\n1. 程序计数器：当前线程执行的字节码行号指示器\n2. 虚拟机栈：存储局部变量表、操作数栈、方法出口等\n3. 本地方法栈：为Native方法服务\n4. 堆：存放对象实例，GC主要区域\n5. 方法区：存储类信息、常量、静态变量等\n6. 运行时常量池：方法区的一部分，存放编译期生成的字面量和符号引用', 
3, 1),
(2, 'Spring中的Bean作用域有哪些？', 
'Spring中Bean的作用域包括：\n1. singleton（单例）：默认，Spring容器中只有一个实例\n2. prototype（原型）：每次请求都创建新实例\n3. request：每次HTTP请求创建新实例（Web应用）\n4. session：同一HTTP Session共享一个实例（Web应用）\n5. application：整个ServletContext生命周期内共享\n6. websocket：WebSocket生命周期内共享', 
2, 1),
(2, '什么是AOP？Spring AOP的实现原理是什么？', 
'AOP（面向切面编程）是一种编程范式，用于将横切关注点与业务逻辑分离。\n\nSpring AOP实现原理：\n1. 基于代理模式实现\n2. JDK动态代理：针对实现了接口的类\n3. CGLIB代理：针对没有实现接口的类\n4. 在运行时动态生成代理对象\n5. 通过代理对象调用目标方法前后执行切面逻辑', 
3, 1),
(2, 'synchronized 和 ReentrantLock 的区别？', 
'主要区别：\n1. 实现层面：synchronized是JVM层面的关键字，ReentrantLock是API层面的类\n2. 灵活性：ReentrantLock更灵活，支持公平锁、可中断、尝试获取锁等\n3. 释放方式：synchronized自动释放，ReentrantLock需手动释放（finally块）\n4. 等待可中断：ReentrantLock支持lockInterruptibly()\n5. 性能：JDK6后synchronized优化，性能相当', 
2, 1);

-- 更新卡组的卡片数量统计
UPDATE sys_market_deck SET card_count = 5 WHERE id = 1;
UPDATE sys_market_deck SET card_count = 5 WHERE id = 2;
