package com.qms.back.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("game")
public class Game {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 游戏名称
     */
    private String name;
    
    /**
     * 游戏封面图片URL
     */
    private String coverImage;
    
    /**
     * 游戏价格
     */
    private BigDecimal price;
    
    /**
     * 游戏分类ID
     */
    private Long categoryId;
    
    /**
     * 游戏发行日期
     */
    private LocalDateTime releaseDate;
    
    /**
     * 是否推荐
     */
    private Boolean isFeatured;
    
    /**
     * 游戏状态（0-下架，1-上架，2-预发售）
     */
    private Integer status;
    
    /**
     * 创建时间
     */
    private LocalDateTime createdAt;
    
    /**
     * 更新时间
     */
    private LocalDateTime updatedAt;
}