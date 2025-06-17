package com.qms.back.web.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qms.back.model.entity.GameDescription;
import com.qms.back.web.admin.mapper.GameDescriptionMapper;
import com.qms.back.web.admin.service.GameDescriptionService;
import org.springframework.stereotype.Service;

@Service
public class GameDescriptionServiceImpl extends ServiceImpl<GameDescriptionMapper, GameDescription> implements GameDescriptionService {
    
    @Override
    public GameDescription getByGameId(Long gameId) {
        QueryWrapper<GameDescription> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("game_id", gameId);
        return getOne(queryWrapper);
    }
} 