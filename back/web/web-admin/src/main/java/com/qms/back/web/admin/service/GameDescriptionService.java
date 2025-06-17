package com.qms.back.web.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.qms.back.model.entity.GameDescription;

public interface GameDescriptionService extends IService<GameDescription> {
    
    /**
     * 根据游戏ID获取游戏描述
     * @param gameId 游戏ID
     * @return 游戏描述
     */
    GameDescription getByGameId(Long gameId);
} 