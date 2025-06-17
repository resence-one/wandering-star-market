package com.qms.back.web.admin.service;

import com.qms.back.model.dto.UserLoginDTO;
import com.qms.back.model.dto.UserRegisterDTO;
import com.qms.back.model.dto.LoginResponseDTO;
import com.qms.back.model.entity.User;

public interface UserService {
    User register(UserRegisterDTO registerDTO);
    LoginResponseDTO login(UserLoginDTO loginDTO);
} 