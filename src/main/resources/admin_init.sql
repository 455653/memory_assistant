-- 给 sys_user 表添加 role 字段
ALTER TABLE sys_user 
ADD COLUMN role VARCHAR(20) DEFAULT 'USER' NOT NULL COMMENT '角色: USER-普通用户, ADMIN-管理员';

-- 将 admin 用户设置为管理员
UPDATE sys_user SET role = 'ADMIN' WHERE username = 'admin';

-- 如果没有 admin 用户，创建一个（密码: admin123）
INSERT INTO sys_user (username, password, email, nickname, role, status)
SELECT 'admin', 'admin123', 'admin@example.com', '系统管理员', 'ADMIN', 1
WHERE NOT EXISTS (SELECT 1 FROM sys_user WHERE username = 'admin');
