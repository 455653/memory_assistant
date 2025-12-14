# VIP卡组商店功能使用说明

## 功能概述
VIP卡组商店是Memory Assistant新增的核心功能，用户可以在商店中浏览和购买官方精选的VIP卡组，购买后系统会自动将卡组及其所有卡片复制到用户账号下。

## 部署步骤

### 1. 数据库初始化
在MySQL数据库中执行以下脚本文件：
```bash
# 进入MySQL
mysql -u root -p

# 选择数据库
USE memory_assistant;

# 执行初始化脚本
source /path/to/market_init.sql;
```

或者直接复制 `src/main/resources/market_init.sql` 文件的内容在数据库管理工具中执行。

该脚本会：
- 创建 `sys_market_deck` 表（VIP商店卡组表）
- 创建 `sys_market_card` 表（VIP商店卡片表）
- 插入2个测试VIP卡组数据
- 为每个卡组插入5张测试卡片

### 2. 启动项目
```bash
# Maven项目启动
mvn spring-boot:run

# 或使用IDE直接运行 MemoryAssistantApplication
```

### 3. 访问商店
启动后，在浏览器访问：
- 登录系统后，在导航栏点击 "VIP商店" 按钮
- 或直接访问：`http://localhost:8080/market`

## 功能特性

### 核心特性
1. **商品浏览**：展示所有上架的VIP卡组，包含封面、名称、描述、价格、分类等信息
2. **一键购买**：点击"立即购买"按钮，确认后自动完成购买
3. **深拷贝机制**：购买后会将VIP卡组及其所有卡片完整复制到用户账号下
4. **进度重置**：复制后的卡片会重置复习进度（stage=0，今天可开始复习）
5. **独立管理**：用户可以随意修改、删除购买后的卡组和卡片

### 技术实现要点

#### 1. 数据库设计
- 使用独立的 `sys_market_deck` 和 `sys_market_card` 表存储商店数据
- 不污染用户数据表（`flashcard_deck` 和 `flashcard`）
- 商店表不包含 `user_id` 字段（公共商品）

#### 2. 深拷贝逻辑（MarketService.buyDeck）
```java
购买流程：
1. 查询VIP卡组信息
2. 创建用户卡组（复制名称、描述、分类等）
3. 查询该VIP卡组下的所有卡片
4. 批量创建用户卡片（复制问题、答案，重置复习进度）
5. 更新卡组的卡片数量统计
```

关键点：
- 使用 `deckMapper.insert()` 后会自动获取生成的卡组ID
- 使用 `flashcardMapper.batchInsert()` 批量插入卡片，性能更好
- 卡片的 `nextReviewDate` 设为今天，`stage` 设为0（新卡片）
- 所有字段都重置为初始状态（reviewCount=0, correctCount=0等）

#### 3. 事务管理
`@Transactional(rollbackFor = Exception.class)` 确保购买过程的原子性：
- 如果任何步骤失败，整个操作会回滚
- 不会出现卡组创建了但卡片没创建的情况

## 文件清单

### 后端文件
```
src/main/java/com/example/memoryassistant/
├── entity/
│   ├── MarketDeck.java          # VIP商店卡组实体类
│   └── MarketCard.java          # VIP商店卡片实体类
├── mapper/
│   └── MarketMapper.java        # VIP商店Mapper接口
├── service/
│   └── MarketService.java       # VIP商店业务逻辑（核心）
└── controller/
    └── MarketController.java    # VIP商店控制器
```

### 配置文件
```
src/main/resources/
├── mapper/
│   └── MarketMapper.xml         # MyBatis XML映射文件
└── market_init.sql              # 数据库初始化脚本
```

### 前端文件
```
src/main/webapp/WEB-INF/jsp/
├── market.jsp                   # VIP商店页面
├── dashboard.jsp                # 首页（已更新导航栏）
└── decks.jsp                    # 卡组管理页（已更新导航栏）
```

## 使用示例

### 购买流程
1. 用户点击导航栏的 "VIP商店" 按钮
2. 浏览商品列表，查看卡组详情
3. 点击"立即购买"按钮
4. 弹出确认对话框，显示价格和卡组名称
5. 点击"确定"后，系统自动完成购买
6. 跳转到"我的卡组"页面，可以看到新购买的卡组
7. 进入卡组详情，可以看到所有卡片
8. 立即开始复习

### 测试数据说明
脚本中包含2个测试VIP卡组：

#### 1. 托福核心词汇精选
- 价格：¥19.99
- 分类：英语学习
- 包含5个托福高频词汇
- 适合英语学习场景测试

#### 2. Java面试高频题库
- 价格：¥29.99
- 分类：编程开发
- 包含5道Java面试题
- 适合技术学习场景测试

## 扩展建议

### 添加更多VIP卡组
直接在数据库中插入新的商店数据：
```sql
-- 插入新的VIP卡组
INSERT INTO sys_market_deck (deck_name, description, category, price, cover_url, card_count, status)
VALUES ('你的卡组名称', '卡组描述', '分类', 价格, '封面URL', 卡片数量, 1);

-- 插入卡片（注意market_deck_id需要替换为实际ID）
INSERT INTO sys_market_card (market_deck_id, question, answer, difficulty_level, status)
VALUES 
(卡组ID, '问题1', '答案1', 1, 1),
(卡组ID, '问题2', '答案2', 2, 1);
```

### 未来功能增强
1. **支付集成**：接入真实支付系统（微信支付、支付宝等）
2. **购买历史**：记录用户购买记录，避免重复购买
3. **卡组评价**：用户可以对购买的VIP卡组进行评价和评分
4. **卡组预览**：购买前可以预览部分卡片内容
5. **分类筛选**：按分类、价格等条件筛选VIP卡组
6. **推荐系统**：根据用户学习历史推荐合适的VIP卡组

## 注意事项

1. **不要修改现有业务代码**：本次新增功能完全独立，不影响原有的卡组和卡片功能
2. **数据库字符集**：确保使用 `utf8mb4` 字符集，支持中文和特殊字符
3. **封面图URL**：当前使用Unsplash的图片链接，需要网络访问。可以替换为本地图片
4. **事务配置**：确保Spring Boot已启用事务管理（默认已启用）

## 常见问题

### Q1: 购买后找不到卡组？
A: 检查以下几点：
- 购买是否成功（是否有成功提示）
- 在"我的卡组"页面刷新查看
- 检查数据库中 `flashcard_deck` 表是否有新记录

### Q2: 卡片数量不对？
A: 检查：
- `sys_market_card` 表中该卡组的卡片数量
- `flashcard` 表中是否成功插入
- 查看服务器日志是否有异常

### Q3: 如何下架某个VIP卡组？
A: 执行SQL：
```sql
UPDATE sys_market_deck SET status = 0 WHERE id = 卡组ID;
```

## 总结
VIP卡组商店功能已完全实现，包括：
✅ 数据库表结构设计
✅ 完整的后端业务逻辑（深拷贝机制）
✅ 美观的前端页面
✅ 导航栏入口
✅ 测试数据

现在可以直接运行项目进行测试！
