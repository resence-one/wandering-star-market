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
('休闲游戏', '轻松休闲的游戏', 4, '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('竞技游戏', '多人在线竞技游戏', 5, '2024-03-17 10:00:00', '2024-03-17 10:00:00'),
('冒险游戏', '充满探索和谜题的游戏', 6, '2024-03-18 10:00:00', '2024-03-18 10:00:00');

INSERT INTO `game` (`name`, `price`, `category_id`, `is_featured`, `status`, `release_date`, `cover_image`, `created_at`, `updated_at`) VALUES
('超级马里奥', 199.00, 1, 1, 1, '2024-03-16 10:00:00', 'https://p1.ssl.qhmsg.com/t013a2f2e58559889ce.jpg', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('最终幻想', 299.00, 2, 1, 1, '2024-03-16 10:00:00', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.vnaSA6NA--cyGRJ0Lwxg0wHaLe?r=0&rs=1&pid=ImgDetMain', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('文明6', 199.00, 3, 0, 1, '2024-03-16 10:00:00', 'https://pics.bing.com/images/search?view=detailv2&ccid=hRzI2sJm&id=6A07E46EF9B82245353528A6D3F9B79B7F1B17B0&thid=OIP.hRzI2sJm01b4c5j7x4x4gHaFj&mediaurl=https%3a%2f%2fstore.playstation.com%2fstore%2fapi%2ffull%2fproduct%2fEP1001-CUSA03011_00-CIV6BASE00000000.png%3fw%3d800%26h%3d800%26fm%3dpng%26q%3d80', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('俄罗斯方块', 29.00, 4, 0, 1, '2024-03-16 10:00:00', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.B6b4x4FQIHoIaYsZ0kcc6QHaNK?r=0&o=7rm=3&rs=1&pid=ImgDetMain', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('赛博朋克2077', 399.00, 2, 1, 2, '2024-12-01 00:00:00', 'https://tse3-mm.cn.bing.net/th/id/OIP-C.PlnX2mFQIHoIaYsZ0kcc6QHaNK?r=0&o=7rm=3&rs=1&pid=ImgDetMain', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
('CS:GO', 99.00, 5, 1, 1, '2020-08-26 10:00:00', 'https://tse4-mm.cn.bing.net/th/id/OIP-C.vnaSA6NA--cyGRJ0Lwxg0wHaLe?r=0&rs=1&pid=ImgDetMain', '2024-03-19 10:00:00', '2024-03-19 10:00:00'),
('艾尔登法环', 298.00, 2, 1, 1, '2022-02-25 00:00:00', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.vnaSA6NA--cyGRJ0Lwxg0wHaLe?r=0&rs=1&pid=ImgDetMain', '2024-03-20 10:00:00', '2024-03-20 10:00:00'),
('星空', 288.00, 6, 0, 2, '2024-09-06 00:00:00', 'https://tse3-mm.cn.bing.net/th/id/OIP-C.PlnX2mFQIHoIaYsZ0kcc6QHaNK?r=0&o=7rm=3&rs=1&pid=ImgDetMain', '2024-03-21 10:00:00', '2024-03-21 10:00:00'),
('地平线：西之绝境', 268.00, 2, 0, 1, '2022-02-18 00:00:00', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.vnaSA6NA--cyGRJ0Lwxg0wHaLe?r=0&rs=1&pid=ImgDetMain', '2024-03-22 10:00:00', '2024-03-22 10:00:00'),
('死亡搁浅', 168.00, 6, 0, 1, '2019-11-08 00:00:00', 'https://tse3-mm.cn.bing.net/th/id/OIP-C.PlnX2mFQIHoIaYsZ0kcc6QHaNK?r=0&o=7rm=3&rs=1&pid=ImgDetMain', '2024-03-23 10:00:00', '2024-03-23 10:00:00'),
('巫师3', 128.00, 2, 1, 1, '2015-05-19 00:00:00', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.vnaSA6NA--cyGRJ0Lwxg0wHaLe?r=0&rs=1&pid=ImgDetMain', '2024-03-24 10:00:00', '2024-03-24 10:00:00'),
('我的世界', 165.00, 4, 1, 1, '2011-11-18 00:00:00', 'https://tse4-mm.cn.bing.net/th/id/OIP-C.vnaSA6NA--cyGRJ0Lwxg0wHaLe?r=0&rs=1&pid=ImgDetMain', '2024-03-25 10:00:00', '2024-03-25 10:00:00'),
('英雄联盟', 0.00, 5, 0, 1, '2009-10-27 00:00:00', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.B6b4x4FQIHoIaYsZ0kcc6QHaNK?r=0&o=7rm=3&rs=1&pid=ImgDetMain', '2024-03-26 10:00:00', '2024-03-26 10:00:00'),
('泰拉瑞亚', 36.00, 6, 0, 1, '2011-05-16 00:00:00', 'https://tse3-mm.cn.bing.net/th/id/OIP-C.PlnX2mFQIHoIaYsZ0kcc6QHaNK?r=0&o=7rm=3&rs=1&pid=ImgDetMain', '2024-03-27 10:00:00', '2024-03-27 10:00:00'),
('暗黑破坏神4', 468.00, 2, 1, 0, '2023-06-06 00:00:00', 'https://tse1-mm.cn.bing.net/th/id/OIP-C.vnaSA6NA--cyGRJ0Lwxg0wHaLe?r=0&rs=1&pid=ImgDetMain', '2024-03-28 10:00:00', '2024-03-28 10:00:00');

-- 插入游戏描述数据
INSERT INTO `game_description` (`game_id`, `short_description`, `long_description`, `features`, `system_requirements`, `created_at`, `updated_at`) VALUES
(1, '经典的横版动作游戏', '超级马里奥是一款经典的横版动作游戏，玩家需要控制马里奥在各种关卡中冒险，收集金币，打败敌人，拯救公主。游戏画面精美，操作简单，适合所有年龄段的玩家。', '1. 经典的横版动作玩法\n2. 丰富的关卡设计\n3. 多种道具和技能\n4. 支持多人游戏', '操作系统：Windows 10/11\n处理器：Intel Core i3 或同等性能\n内存：4 GB RAM\n显卡：集成显卡即可\n存储空间：需要 2 GB 可用空间', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
(2, '经典的RPG游戏', '最终幻想是一款经典的RPG游戏，拥有丰富的剧情和角色设定。玩家将在广阔的世界中探索，与各种角色互动，体验史诗般的冒险故事。', '1. 丰富的剧情故事\n2. 多样化的角色系统\n3. 精美的画面和音乐\n4. 深度的战斗系统', '操作系统：Windows 10/11\n处理器：Intel Core i5 或同等性能\n内存：8 GB RAM\n显卡：NVIDIA GTX 1060 或同等性能\n存储空间：需要 50 GB 可用空间', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
(3, '回合制策略游戏', '文明6是一款回合制策略游戏，玩家需要建立自己的文明，发展科技，扩张领土，与其他文明竞争或合作。游戏具有极高的可玩性和策略深度。', '1. 深度的策略玩法\n2. 丰富的文明选择\n3. 多样的胜利条件\n4. 精美的历史还原', '操作系统：Windows 10/11\n处理器：Intel Core i5 或同等性能\n内存：8 GB RAM\n显卡：NVIDIA GTX 970 或同等性能\n存储空间：需要 12 GB 可用空间', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
(4, '经典的休闲游戏', '俄罗斯方块是一款经典的休闲游戏，玩家需要控制不同形状的方块，将它们排列成完整的行来消除。游戏简单易上手，但具有很高的挑战性。', '1. 简单易上手的玩法\n2. 高挑战性的游戏体验\n3. 多种游戏模式\n4. 支持多人对战', '操作系统：Windows 7/8/10/11\n处理器：任何现代处理器\n内存：2 GB RAM\n显卡：集成显卡即可\n存储空间：需要 100 MB 可用空间', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
(5, '未来科幻RPG游戏', '赛博朋克2077是一款未来科幻RPG游戏，设定在2077年的夜之城。玩家将扮演一名雇佣兵，在这个充满危险和机遇的城市中生存和发展。', '1. 开放世界探索\n2. 丰富的角色定制\n3. 深度的剧情选择\n4. 未来科技设定', '操作系统：Windows 10/11\n处理器：Intel Core i7-4790 或同等性能\n内存：12 GB RAM\n显卡：NVIDIA GTX 1060 6GB 或同等性能\n存储空间：需要 70 GB 可用空间', '2024-03-16 10:00:00', '2024-03-16 10:00:00'),
(6, '经典FPS游戏', '反恐精英：全球攻势（CS:GO）是一款由Valve Corporation开发的第一人称射击游戏，是《反恐精英》系列游戏的第四款作品。', '1. 竞技模式\n2. 休闲模式\n3. 死亡竞赛\n4. 军备竞赛\n5. 爆破模式\n6. 飞天狙击', '操作系统：Windows 7/Vista/XP\n处理器：Intel Core 2 Duo E6600 或 AMD Phenom X3 8750 处理器\n内存：2 GB RAM\n显卡：拥有 256 MB 以上显存且支持 Shader Model 3.0 的显卡\nDirectX：版本 9.0c\n存储空间：需要 15 GB 可用空间', '2024-03-19 10:00:00', '2024-03-19 10:00:00'),
(7, '开放世界魂系RPG', '艾尔登法环（Elden Ring）是一款由FromSoftware开发，万代南梦宫娱乐发行的魂系动作角色扮演游戏，拥有广阔的开放世界和极具挑战性的战斗。', '1. 开放世界探索\n2. 高难度战斗\n3. 丰富的武器和法术\n4. 多样化的敌人和Boss', '操作系统：Windows 10/11\n处理器：Intel Core i5-8400 或 AMD Ryzen 3 3300X\n内存：12 GB RAM\n显卡：NVIDIA GeForce GTX 1060 3GB 或 AMD Radeon RX 580 4GB\nDirectX：版本 12\n存储空间：需要 60 GB 可用空间', '2024-03-20 10:00:00', '2024-03-20 10:00:00'),
(8, '史诗级太空探索RPG', '星空（Starfield）是一款由Bethesda Game Studios开发的角色扮演游戏，设定在一个广阔的宇宙中，玩家可以自由探索星系，建造飞船，发现外星生命。', '1. 自由探索广阔宇宙\n2. 飞船建造和定制\n3. 丰富的任务和剧情\n4. 独特的外星生物和行星', '操作系统：Windows 10/11\n处理器：Intel Core i7-6800K 或 AMD Ryzen 5 2600X\n内存：16 GB RAM\n显卡：NVIDIA GeForce GTX 1070 Ti 或 AMD Radeon RX 5700 XT\nDirectX：版本 12\n存储空间：需要 125 GB 可用空间 (SSD)', '2024-03-21 10:00:00', '2024-03-21 10:00:00'),
(9, '末日生存动作RPG', '地平线：西之绝境（Horizon Forbidden West）是一款由Guerrilla Games开发，索尼互动娱乐发行的动作角色扮演游戏。玩家将扮演埃洛伊，在一个被机械生物统治的末日世界中探索和战斗。', '1. 广阔的开放世界\n2. 刺激的机械兽战斗\n3. 丰富的故事情节\n4. 精美的画面表现', '操作系统：Windows 10/11\n处理器：Intel Core i5-8600 或 AMD Ryzen 5 3600\n内存：16 GB RAM\n显卡：NVIDIA GeForce RTX 3060 或 AMD Radeon RX 5700 XT\nDirectX：版本 12\n存储空间：需要 90 GB 可用空间 (SSD)', '2024-03-22 10:00:00', '2024-03-22 10:00:00'),
(10, '奇幻冒险游戏', '死亡搁浅（Death Stranding）是一款由小岛制作开发，索尼互动娱乐发行的开放世界动作游戏。玩家将扮演送货员山姆，在末日后的美国传递希望，重建联系。', '1. 独特的送货玩法\n2. 电影般的叙事\n3. 广阔的开放世界\n4. 丰富的社交元素', '操作系统：Windows 10/11\n处理器：Intel Core i5-3470 或 AMD Ryzen 3 1200\n内存：8 GB RAM\n显卡：NVIDIA GeForce GTX 1050 或 AMD Radeon RX 560\nDirectX：版本 12\n存储空间：需要 80 GB 可用空间', '2024-03-23 10:00:00', '2024-03-23 10:00:00'),
(11, '史诗级角色扮演巨作', '巫师3：狂猎（The Witcher 3: Wild Hunt）是一款由CD Projekt RED开发的角色扮演游戏，拥有庞大的开放世界，丰富的剧情和任务，以及引人入胜的怪物狩猎体验。', '1. 广阔的开放世界\n2. 深入的剧情选择\n3. 刺激的战斗系统\n4. 丰富的支线任务', '操作系统：Windows 7/8/8.1/10 (64-bit)\n处理器：Intel Core i5-2500K 或 AMD Phenom II X4 940\n内存：6 GB RAM\n显卡：NVIDIA GeForce GTX 660 或 AMD Radeon HD 7870\nDirectX：版本 11\n存储空间：需要 35 GB 可用空间', '2024-03-24 10:00:00', '2024-03-24 10:00:00'),
(12, '经典沙盒建造游戏', '我的世界（Minecraft）是一款由Mojang Studios开发的沙盒建造游戏。玩家可以在一个由方块组成的世界中自由探索、建造、挖矿和战斗。', '1. 开放世界沙盒玩法\n2. 自由建造和创造\n3. 多种游戏模式\n4. 支持多人游戏', '操作系统：Windows 7/8/10/11\n处理器：Intel Core i3-3210 或 AMD A8-7600\n内存：4 GB RAM\n显卡：Intel HD Graphics 4000 或 AMD Radeon R5\n存储空间：需要 1 GB 可用空间', '2024-03-25 10:00:00', '2024-03-25 10:00:00'),
(13, '全球热门MOBA游戏', '英雄联盟（League of Legends）是一款由Riot Games开发的多人在线竞技游戏。玩家选择不同的英雄，在召唤师峡谷中进行5v5对战，目标是摧毁对方的水晶枢纽。', '1. 丰富的英雄选择\n2. 竞技性强\n3. 持续更新的游戏内容\n4. 大型电竞赛事', '操作系统：Windows 7/8/10 (64-bit)\n处理器：Intel Core i3-530 或 AMD Phenom II X4 910\n内存：4 GB RAM\n显卡：NVIDIA GeForce 9600GT 或 AMD Radeon HD 6570\nDirectX：版本 9.0c\n存储空间：需要 16 GB 可用空间', '2024-03-26 10:00:00', '2024-03-26 10:00:00'),
(14, '像素风格沙盒冒险游戏', '泰拉瑞亚（Terraria）是一款由Re-Logic开发的2D像素风格沙盒冒险游戏。玩家可以在一个随机生成的世界中探索、挖掘、建造和战斗。', '1. 自由探索和建造\n2. 丰富的物品和装备\n3. 多样化的怪物和Boss\n4. 支持多人游戏', '操作系统：Windows XP/Vista/7/8/10\n处理器：1.6 GHz 双核处理器\n内存：2 GB RAM\n显卡：256MB 显存，支持 Shader Model 2.0+ \nDirectX：版本 9.0c\n存储空间：需要 200 MB 可用空间', '2024-03-27 10:00:00', '2024-03-27 10:00:00'),
(15, '暗黑系动作RPG', '暗黑破坏神4（Diablo IV）是一款由暴雪娱乐开发，即将推出的动作角色扮演游戏，设定在圣休亚瑞的世界中，玩家将与邪恶势力对抗，拯救世界。', '1. 黑暗哥特式风格\n2. 开放世界探索\n3. 职业多样性\n4. 地下城探险', '操作系统：Windows 10 (64-bit)\n处理器：Intel Core i5-2500K 或 AMD FX-8350\n内存：8 GB RAM\n显卡：NVIDIA GeForce GTX 660 或 AMD Radeon R9 280\nDirectX：版本 12\n存储空间：需要 45 GB 可用空间 (SSD)', '2024-03-28 10:00:00', '2024-03-28 10:00:00');

-- 插入一些测试数据（用户表）
INSERT INTO `user` (`username`, `password_hash`, `email`, `phone`, `registration_date`, `last_login_date`, `status`, `role`) VALUES
('testuser', '$2a$10$A/cT7J2P.z.bF.m.x.e/3.t7/t6/J7/t6/J7/t6/J7', 'test@example.com', '12345678900', '2024-01-01 10:00:00', '2024-01-01 10:00:00', 1, 'user');

-- 插入一些测试数据（用户详情表）
INSERT INTO `user_profile` (`user_id`, `avatar_url`, `nickname`, `gender`, `bio`, `created_at`, `updated_at`) VALUES
(1, 'https://example.com/avatar/testuser.png', '测试用户', 1, '这是一个测试用户的个人简介。', '2024-01-01 10:00:00', '2024-01-01 10:00:00'); 