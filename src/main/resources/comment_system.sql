-- VIP卡组评论表
CREATE TABLE sys_market_comment
(
    id             BIGINT AUTO_INCREMENT COMMENT '评论ID'
        PRIMARY KEY,
    market_deck_id BIGINT                             NOT NULL COMMENT '所属商店卡组ID',
    user_id        BIGINT                             NOT NULL COMMENT '评论用户ID',
    content        TEXT                               NOT NULL COMMENT '评论内容',
    rating         TINYINT  DEFAULT 5                 NULL COMMENT '评分: 1-5星',
    create_time    DATETIME DEFAULT CURRENT_TIMESTAMP NULL COMMENT '创建时间',
    CONSTRAINT fk_comment_market_deck
        FOREIGN KEY (market_deck_id) REFERENCES sys_market_deck (id)
            ON DELETE CASCADE,
    CONSTRAINT fk_comment_user
        FOREIGN KEY (user_id) REFERENCES sys_user (id)
            ON DELETE CASCADE
)
    COMMENT 'VIP商店评论表' CHARSET = utf8mb4;

-- 创建索引
CREATE INDEX idx_market_deck_id ON sys_market_comment (market_deck_id);
CREATE INDEX idx_user_id ON sys_market_comment (user_id);
CREATE INDEX idx_create_time ON sys_market_comment (create_time DESC);
