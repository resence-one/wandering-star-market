package com.qms.back.web.admin.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.qms.back.model.entity.UserProfile;

public interface UserProfileService extends IService<UserProfile> {
    /**
     * 根据用户ID获取用户详情
     * @param userId 用户ID
     * @return 用户详情
     */
    UserProfile getByUserId(Long userId);
} 