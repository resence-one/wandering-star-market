package com.qms.back.web.admin.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.qms.back.common.Result.Result;
import com.qms.back.model.entity.Game;
import com.qms.back.model.dto.GameDetailDTO;
import com.qms.back.web.admin.mapper.GameMapper;
import com.qms.back.web.admin.service.GameService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/game")
public class GameController {

    @Autowired
    private GameMapper gameMapper;
    
    @Autowired
    private GameService gameService;

    @GetMapping("/list")
    public Result<Page<Game>> list(
        @RequestParam(defaultValue = "1") Integer page,
        @RequestParam(defaultValue = "10") Integer size,
        @RequestParam(required = false) Long categoryId,
        @RequestParam(required = false) Double minPrice,
        @RequestParam(required = false) Double maxPrice,
        @RequestParam(required = false) String sortBy,
        @RequestParam(required = false) String sortOrder) {
        
        // 创建分页对象
        Page<Game> pageInfo = new Page<>(page, size);
        
        // 创建查询条件
        LambdaQueryWrapper<Game> queryWrapper = new LambdaQueryWrapper<>();
        
        // 添加分类筛选
        if (categoryId != null) {
            queryWrapper.eq(Game::getCategoryId, categoryId);
        }
        if (minPrice != null) {
            queryWrapper.ge(Game::getPrice, minPrice);
        }
        if (maxPrice != null) {
            queryWrapper.le(Game::getPrice, maxPrice);
        }

        // 添加排序
        if (sortBy != null) {
            switch (sortBy) {
                case "price":
                    queryWrapper.orderBy(true, 
                        "asc".equalsIgnoreCase(sortOrder), 
                        Game::getPrice);
                    break;
                case "releaseDate":
                    queryWrapper.orderBy(true, 
                        "asc".equalsIgnoreCase(sortOrder), 
                        Game::getReleaseDate);
                    break;
                default:
                    queryWrapper.orderByDesc(Game::getCreatedAt);
            }
        } else {
            queryWrapper.orderByDesc(Game::getCreatedAt);
        }
        
        // 执行查询
        Page<Game> result = gameMapper.selectPage(pageInfo, queryWrapper);
        
        return Result.ok(result);
    }

    @GetMapping("/featured")
    public Result<Page<Game>> featured(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        
        Page<Game> pageInfo = new Page<>(page, size);
        LambdaQueryWrapper<Game> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Game::getIsFeatured, true);
        queryWrapper.orderByDesc(Game::getCreatedAt);
        
        Page<Game> result = gameMapper.selectPage(pageInfo, queryWrapper);
        return Result.ok(result);
    }

    @GetMapping("/{id}")
    public Result<Game> getById(@PathVariable Long id) {
        Game game = gameMapper.selectById(id);
        if (game == null) {
            return Result.fail(404, "游戏不存在");
        }
        return Result.ok(game);
    }
    
    @GetMapping("/{id}/detail")
    public Result<GameDetailDTO> getGameDetail(@PathVariable Long id) {
        GameDetailDTO gameDetail = gameService.getGameDetail(id);
        if (gameDetail == null) {
            return Result.fail(404, "游戏不存在");
        }
        return Result.ok(gameDetail);
    }
} 