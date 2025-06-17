package com.qms.back.web.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.qms.back.model.entity.Game;
import com.qms.back.model.dto.GameDetailDTO;

public interface GameService extends IService<Game> {
    
    /**
     * 获取游戏详情（包含描述信息）
     * @param gameId 游戏ID
     * @return 游戏详情DTO
     */
    GameDetailDTO getGameDetail(Long gameId);
} 