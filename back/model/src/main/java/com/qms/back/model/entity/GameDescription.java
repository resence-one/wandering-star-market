package com.qms.back.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("game_description")
public class GameDescription {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 游戏ID（逻辑外键）
     */
    private Long gameId;
    
    /**
     * 游戏简介
     */
    private String shortDescription;
    
    /**
     * 游戏详细描述
     */
    private String longDescription;
    
    /**
     * 游戏特色功能
     */
    private String features;
    
    /**
     * 系统要求
     */
    private String systemRequirements;
    
    /**
     * 创建时间
     */
    private LocalDateTime createdAt;
    
    /**
     * 更新时间
     */
    private LocalDateTime updatedAt;
} 