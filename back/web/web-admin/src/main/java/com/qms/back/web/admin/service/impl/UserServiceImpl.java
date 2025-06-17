package com.qms.back.web.admin.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.qms.back.model.dto.UserLoginDTO;
import com.qms.back.model.dto.UserRegisterDTO;
import com.qms.back.model.dto.LoginResponseDTO;
import com.qms.back.model.entity.User;
import com.qms.back.model.entity.UserProfile;
import com.qms.back.web.admin.mapper.UserMapper;
import com.qms.back.web.admin.service.UserService;
import com.qms.back.web.admin.service.UserProfileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private UserProfileService userProfileService;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    public User register(UserRegisterDTO registerDTO) {
        // 检查用户名是否已存在
        if (userMapper.selectCount(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, registerDTO.getUsername())) > 0) {
            throw new RuntimeException("用户名已存在");
        }

        // 创建新用户
        User user = new User();
        user.setUsername(registerDTO.getUsername());
        user.setPasswordHash(passwordEncoder.encode(registerDTO.getPassword()));
        user.setEmail(registerDTO.getEmail());
        user.setPhone(registerDTO.getPhone());
        user.setRegistrationDate(LocalDateTime.now());
        user.setStatus(1);
        user.setRole("user");

        // 保存用户
        userMapper.insert(user);

        // 创建用户详情
        UserProfile userProfile = new UserProfile();
        userProfile.setUserId(user.getId()); // 关联用户ID
        userProfile.setCreatedAt(LocalDateTime.now());
        userProfile.setUpdatedAt(LocalDateTime.now());
        // 可以设置默认的头像、昵称等
        userProfile.setAvatarUrl(""); // 默认头像
        userProfile.setNickname(user.getUsername()); // 默认昵称为用户名
        userProfileService.save(userProfile);

        // 将用户详情设置到User对象中
        user.setUserProfile(userProfile);

        return user;
    }

    @Override
    public LoginResponseDTO login(UserLoginDTO loginDTO) {
        // 查找用户
        User user = userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getUsername, loginDTO.getUsername()));

        // 验证用户存在性和密码
        if (user == null || !passwordEncoder.matches(loginDTO.getPassword(), user.getPasswordHash())) {
            throw new RuntimeException("用户名或密码错误");
        }

        // 更新最后登录时间
        user.setLastLoginDate(LocalDateTime.now());
        userMapper.updateById(user);

        // 获取用户详情并设置到User对象中
        UserProfile userProfile = userProfileService.getByUserId(user.getId());
        user.setUserProfile(userProfile);
     
        // 生成一个简单的token（实际项目中会使用JWT等）
        String token = UUID.randomUUID().toString();

        return new LoginResponseDTO(user, token);
    }
} 