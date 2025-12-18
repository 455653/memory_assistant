-- 为 flashcard_deck 表添加 source_market_id 字段，用于标识购买来源
ALTER TABLE flashcard_deck 
ADD COLUMN source_market_id BIGINT NULL COMMENT '购买源ID: NULL-用户自建, 其他-从商店购买的对应sys_market_deck.id';

-- 添加普通索引以加快查询速度
CREATE INDEX idx_user_market ON flashcard_deck (user_id, source_market_id);
