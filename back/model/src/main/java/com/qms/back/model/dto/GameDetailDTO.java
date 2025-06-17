package com.qms.back.model.dto;

import com.qms.back.model.entity.Game;
import com.qms.back.model.entity.GameDescription;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class GameDetailDTO {
    /**
     * 游戏基本信息
     */
    private Long id;
    private String name;
    private String coverImage;
    private BigDecimal price;
    private Long categoryId;
    private LocalDateTime releaseDate;
    private Boolean isFeatured;
    private Integer status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    /**
     * 游戏描述信息
     */
    private String shortDescription;
    private String longDescription;
    private String features;
    private String systemRequirements;
    
    /**
     * 从Game和GameDescription构建DTO
     */
    public static GameDetailDTO fromGameAndDescription(Game game, GameDescription description) {
        GameDetailDTO dto = new GameDetailDTO();
        
        // 复制游戏基本信息
        dto.setId(game.getId());
        dto.setName(game.getName());
        dto.setCoverImage(game.getCoverImage());
        dto.setPrice(game.getPrice());
        dto.setCategoryId(game.getCategoryId());
        dto.setReleaseDate(game.getReleaseDate());
        dto.setIsFeatured(game.getIsFeatured());
        dto.setStatus(game.getStatus());
        dto.setCreatedAt(game.getCreatedAt());
        dto.setUpdatedAt(game.getUpdatedAt());
        
        // 复制游戏描述信息
        if (description != null) {
            dto.setShortDescription(description.getShortDescription());
            dto.setLongDescription(description.getLongDescription());
            dto.setFeatures(description.getFeatures());
            dto.setSystemRequirements(description.getSystemRequirements());
        }
        
        return dto;
    }
} 