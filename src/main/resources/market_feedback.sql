-- VIP商店反馈表
CREATE TABLE sys_market_feedback
(
    id             BIGINT AUTO_INCREMENT COMMENT '反馈ID'
        PRIMARY KEY,
    market_deck_id BIGINT                             NOT NULL COMMENT '所属商店卡组ID',
    user_id        BIGINT                             NOT NULL COMMENT '提交反馈的用户ID',
    content        TEXT                               NOT NULL COMMENT '反馈内容',
    contact_info   VARCHAR(100)                       NULL COMMENT '联系方式（选填）',
    status         TINYINT  DEFAULT 0                 NOT NULL COMMENT '处理状态: 0-待处理, 1-已采纳, 2-忽略',
    create_time    DATETIME DEFAULT CURRENT_TIMESTAMP NULL COMMENT '提交时间',
    CONSTRAINT fk_feedback_market_deck
        FOREIGN KEY (market_deck_id) REFERENCES sys_market_deck (id)
            ON DELETE CASCADE,
    CONSTRAINT fk_feedback_user
        FOREIGN KEY (user_id) REFERENCES sys_user (id)
            ON DELETE CASCADE
)
    COMMENT 'VIP商店反馈表' CHARSET = utf8mb4;

-- 创建索引
CREATE INDEX idx_market_deck_id ON sys_market_feedback (market_deck_id);
CREATE INDEX idx_user_id ON sys_market_feedback (user_id);
CREATE INDEX idx_status ON sys_market_feedback (status);
CREATE INDEX idx_create_time ON sys_market_feedback (create_time DESC);
