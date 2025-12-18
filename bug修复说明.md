# VIP卡组重复购买Bug修复说明

## 问题描述
用户点击购买同一个VIP卡组多次，系统会重复创建多个相同的卡组到用户的 `flashcard_deck` 表中。

## 解决方案
限制用户**只能购买同一个VIP卡组一次**。如果用户已经拥有该卡组，再次点击购买时提示"您已拥有该卡组，无需重复购买"。

## 修改内容

### 1. 数据库变更
**文件**: `src/main/resources/add_source_market_id.sql`

在 `flashcard_deck` 表中新增字段：
- `source_market_id` (BIGINT, Nullable): 用于存储购买源ID
  - NULL: 用户自建卡组
  - 其他值: 从商店购买的对应 `sys_market_deck.id`
- 新增索引 `idx_user_market` (user_id, source_market_id) 以加快查询速度

**执行SQL**:
```sql
ALTER TABLE flashcard_deck 
ADD COLUMN source_market_id BIGINT NULL COMMENT '购买源ID: NULL-用户自建, 其他-从商店购买的对应sys_market_deck.id';

CREATE INDEX idx_user_market ON flashcard_deck (user_id, source_market_id);
```

### 2. 实体类更新
**文件**: `src/main/java/com/example/memoryassistant/entity/FlashcardDeck.java`

新增字段：
```java
/**
 * 购买源ID: NULL-用户自建, 其他-从商店购买的对应sys_market_deck.id
 */
private Long sourceMarketId;
```

### 3. Mapper层更新

#### FlashcardDeckMapper.java
**文件**: `src/main/java/com/example/memoryassistant/mapper/FlashcardDeckMapper.java`

新增方法：
```java
/**
 * 统计用户是否已购买指定商店卡组
 * @param userId 用户ID
 * @param marketId 商店卡组ID
 * @return 购买次数（0表示未购买，>0表示已购买）
 */
int countByUserIdAndMarketId(@Param("userId") Long userId, @Param("marketId") Long marketId);
```

#### FlashcardDeckMapper.xml
**文件**: `src/main/resources/mapper/FlashcardDeckMapper.xml`

修改内容：
1. 在 `BaseResultMap` 中新增字段映射
2. 更新 `insert` 语句，包含 `source_market_id` 字段
3. 新增查询方法 `countByUserIdAndMarketId`

### 4. Service层更新
**文件**: `src/main/java/com/example/memoryassistant/service/MarketService.java`

在 `buyDeck` 方法中：
1. **新增前置检查**（方法开头）:
   ```java
   // 前置检查：用户是否已购买过该卡组
   int count = deckMapper.countByUserIdAndMarketId(userId, marketDeckId);
   if (count > 0) {
       throw new IllegalArgumentException("您已拥有该卡组，无需重复购买");
   }
   ```

2. **设置购买源ID**（创建卡组时）:
   ```java
   userDeck.setSourceMarketId(marketDeckId); // 设置购买源ID
   ```

### 5. Controller层更新
**文件**: `src/main/java/com/example/memoryassistant/controller/MarketController.java`

更新异常处理注释，明确包含"已购买"的情况。

## 测试步骤

1. **执行数据库迁移**:
   ```bash
   mysql -u你的用户名 -p你的密码 你的数据库名 < src/main/resources/add_source_market_id.sql
   ```

2. **重启应用程序**

3. **测试场景**:
   - 场景1: 首次购买VIP卡组 → 应该成功，跳转到卡组列表
   - 场景2: 再次购买同一个VIP卡组 → 应该提示"您已拥有该卡组，无需重复购买"
   - 场景3: 购买不同的VIP卡组 → 应该成功

## 注意事项

1. 对于已存在的用户自建卡组，`source_market_id` 字段将为 NULL
2. 只有从商店购买的卡组，该字段才会有值
3. 该修复向后兼容，不影响现有功能

## 修复日期
2025-12-18
