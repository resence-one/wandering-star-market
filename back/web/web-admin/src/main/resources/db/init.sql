-- 用户表
CREATE TABLE `user` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50) UNIQUE NOT NULL COMMENT '用户名',
    `password_hash` VARCHAR(255) NOT NULL COMMENT '密码哈希值',
    `email` VARCHAR(100) UNIQUE COMMENT '邮箱',
    `phone` VARCHAR(20) UNIQUE COMMENT '手机号',
    `registration_date` DATETIME NOT NULL COMMENT '注册时间',
    `last_login_date` DATETIME COMMENT '最后登录时间',
    `status` TINYINT DEFAULT 1 COMMENT '状态：1-正常，0-禁用',
    `role` VARCHAR(20) DEFAULT 'user' COMMENT '角色：user-普通用户，admin-管理员'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 创建用户详情表
CREATE TABLE IF NOT EXISTS `user_profile` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` bigint NOT NULL COMMENT '用户ID',
    `avatar_url` varchar(255) DEFAULT NULL COMMENT '头像URL',
    `nickname` varchar(50) DEFAULT NULL COMMENT '用户昵称',
    `gender` tinyint DEFAULT NULL COMMENT '性别（0-未知，1-男，2-女）',
    `bio` varchar(500) DEFAULT NULL COMMENT '个人简介',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户详情表';

-- 创建分类表
CREATE TABLE IF NOT EXISTS `category` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `name` varchar(50) NOT NULL COMMENT '分类名称',
    `description` varchar(200) DEFAULT NULL COMMENT '分类描述',
    `sort` int DEFAULT 0 COMMENT '排序字段',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='游戏分类表';

-- 创建游戏描述表
CREATE TABLE IF NOT EXISTS `game_description` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `game_id` bigint NOT NULL COMMENT '游戏ID',
    `short_description` varchar(500) DEFAULT NULL COMMENT '游戏简介',
    `long_description` text COMMENT '游戏详细描述',
    `features` text COMMENT '游戏特色功能',
    `system_requirements` text COMMENT '系统要求',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_game_id` (`game_id`),
    KEY `idx_game_id` (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='游戏描述表';

-- 创建游戏表
CREATE TABLE IF NOT EXISTS `game` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `name` varchar(100) NOT NULL COMMENT '游戏名称',
    `cover_image` varchar(255) DEFAULT NULL COMMENT '游戏封面图片URL',
    `price` decimal(10,2) NOT NULL COMMENT '游戏价格',
    `category_id` bigint NOT NULL COMMENT '游戏分类ID',
    `release_date` datetime DEFAULT NULL COMMENT '游戏发行日期',
    `is_featured` tinyint(1) DEFAULT 0 COMMENT '是否推荐',
    `status` tinyint DEFAULT 1 COMMENT '游戏状态（0-下架，1-上架，2-预发售）',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_category_id` (`category_id`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='游戏表';

-- 插入一些测试数据
INSERT INTO `category` (`name`, `description`, `sort`, `created_at`, `updated_at`) VALUES
('动作游戏', '包含各种动作元素的游戏', 1, '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('角色扮演', '以角色扮演为主的游戏', 2, '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('策略游戏', '需要策略思考的游戏', 3, '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('休闲游戏', '轻松休闲的游戏', 4, '2024-03-16 10:00:00', '2024-03-16 10:00:00');

INSERT INTO `game` (`name`, `price`, `category_id`, `is_featured`, `status`, `release_date`, `created_at`, `updated_at`) VALUES
('超级马里奥', 199.00, 1, 1, 1, '2024-03-16 10:00:00', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('最终幻想', 299.00, 2, 1, 1, '2024-03-16 10:00:00', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('文明6', 199.00, 3, 0, 1, '2024-03-16 10:00:00', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('俄罗斯方块', 29.00, 4, 0, 1, '2024-03-16 10:00:00', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('赛博朋克2077', 399.00, 2, 1, 2, '2024-12-01 00:00:00', '2024-03-16 10:00:00', '2024-03-16 10:00:00');

-- 插入游戏描述数据
INSERT INTO `game_description` (`game_id`, `short_description`, `long_description`, `features`, `system_requirements`, `created_at`, `updated_at`) VALUES
(1, '经典的横版动作游戏', '超级马里奥是一款经典的横版动作游戏，玩家需要控制马里奥在各种关卡中冒险，收集金币，打败敌人，拯救公主。游戏画面精美，操作简单，适合所有年龄段的玩家。', '1. 经典的横版动作玩法\n2. 丰富的关卡设计\n3. 多种道具和技能\n4. 支持多人游戏', '操作系统：Windows 10/11\n处理器：Intel Core i3 或同等性能\n内存：4 GB RAM\n显卡：集成显卡即可\n存储空间：需要 2 GB 可用空间', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
(2, '经典的RPG游戏', '最终幻想是一款经典的RPG游戏，拥有丰富的剧情和角色设定。玩家将在广阔的世界中探索，与各种角色互动，体验史诗般的冒险故事。', '1. 丰富的剧情故事\n2. 多样化的角色系统\n3. 精美的画面和音乐\n4. 深度的战斗系统', '操作系统：Windows 10/11\n处理器：Intel Core i5 或同等性能\n内存：8 GB RAM\n显卡：NVIDIA GTX 1060 或同等性能\n存储空间：需要 50 GB 可用空间', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
(3, '回合制策略游戏', '文明6是一款回合制策略游戏，玩家需要建立自己的文明，发展科技，扩张领土，与其他文明竞争或合作。游戏具有极高的可玩性和策略深度。', '1. 深度的策略玩法\n2. 丰富的文明选择\n3. 多样的胜利条件\n4. 精美的历史还原', '操作系统：Windows 10/11\n处理器：Intel Core i5 或同等性能\n内存：8 GB RAM\n显卡：NVIDIA GTX 970 或同等性能\n存储空间：需要 12 GB 可用空间', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
(4, '经典的休闲游戏', '俄罗斯方块是一款经典的休闲游戏，玩家需要控制不同形状的方块，将它们排列成完整的行来消除。游戏简单易上手，但具有很高的挑战性。', '1. 简单易上手的玩法\n2. 高挑战性的游戏体验\n3. 多种游戏模式\n4. 支持多人对战', '操作系统：Windows 7/8/10/11\n处理器：任何现代处理器\n内存：2 GB RAM\n显卡：集成显卡即可\n存储空间：需要 100 MB 可用空间', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
(5, '未来科幻RPG游戏', '赛博朋克2077是一款未来科幻RPG游戏，设定在2077年的夜之城。玩家将扮演一名雇佣兵，在这个充满危险和机遇的城市中生存和发展。', '1. 开放世界探索\n2. 丰富的角色定制\n3. 深度的剧情选择\n4. 未来科技设定', '操作系统：Windows 10/11\n处理器：Intel Core i7-4790 或同等性能\n内存：12 GB RAM\n显卡：NVIDIA GTX 1060 6GB 或同等性能\n存储空间：需要 70 GB 可用空间', '2024-03-16 10:00:00', '2024-03-16 10:00:00');

-- 插入一些测试数据（用户表）
INSERT INTO `user` (`username`, `password_hash`, `email`, `phone`, `registration_date`, `last_login_date`, `status`, `role`) VALUES
('testuser', '$2a$10$A/cT7J2P.z.bF.m.x.e/3.t7/t6/J7/t6/J7/t6/J7', 'test@example.com', '12345678900', '2024-01-01 10:00:00', '2024-01-01 10:00:00', 1, 'user');

-- 插入一些测试数据（用户详情表）
INSERT INTO `user_profile` (`user_id`, `avatar_url`, `nickname`, `gender`, `bio`, `created_at`, `updated_at`) VALUES
(1, 'https://example.com/avatar/testuser.png', '测试用户', 1, '这是一个测试用户的个人简介。', '2024-01-01 10:00:00', '2024-01-01 10:00:00'); 