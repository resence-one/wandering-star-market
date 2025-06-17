package com.qms.back.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("user")
public class User {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String username;
    private String passwordHash;
    private String email;
    private String phone;
    private LocalDateTime registrationDate;
    private LocalDateTime lastLoginDate;
    private Integer status;
    private String role;

    /**
     * 用户详情信息（非数据库字段，用于关联查询）
     */
    @TableField(exist = false)
    private UserProfile userProfile;
} 