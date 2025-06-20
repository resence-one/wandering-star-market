package com.qms.back.web.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qms.back.model.entity.Game;
import com.qms.back.model.entity.GameDescription;
import com.qms.back.model.dto.GameDetailDTO;
import com.qms.back.web.admin.mapper.GameMapper;
import com.qms.back.web.admin.service.GameService;
import com.qms.back.web.admin.service.GameDescriptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GameServiceImpl extends ServiceImpl<GameMapper, Game> implements GameService {
    
    @Autowired
    private GameDescriptionService gameDescriptionService;
    
    @Override
    public GameDetailDTO getGameDetail(Long gameId) {
        // 获取游戏基本信息
        Game game = getById(gameId);
        if (game == null) {
            return null;
        }
        
        // 获取游戏描述信息
        GameDescription gameDescription = gameDescriptionService.getByGameId(gameId);
        
        // 构建并返回DTO
        return GameDetailDTO.fromGameAndDescription(game, gameDescription);
    }

    @Override
    public List<Game> getUpcomingGames() {
        QueryWrapper<Game> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("status", 2); // 查询 status 为 2 的预发售游戏
        queryWrapper.orderByAsc("release_date"); // 按照发布日期升序排序
        return list(queryWrapper);
    }
} 