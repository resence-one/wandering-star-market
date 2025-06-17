package com.qms.back.web.admin.controller;

import com.qms.back.common.Result.Result;
import com.qms.back.web.admin.service.UserService;
import com.qms.back.model.dto.UserLoginDTO;
import com.qms.back.model.dto.UserRegisterDTO;
import com.qms.back.model.dto.LoginResponseDTO;
import com.qms.back.model.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public Result<User> register(@RequestBody UserRegisterDTO registerDTO) {
        try {
            User user = userService.register(registerDTO);
            return Result.ok(user);
        } catch (Exception e) {
            return Result.fail(400, e.getMessage());
        }
    }

    @PostMapping("/login")
    public Result<LoginResponseDTO> login(@RequestBody UserLoginDTO loginDTO) {
        try {
            LoginResponseDTO response = userService.login(loginDTO);
            return Result.ok(response);
        } catch (Exception e) {
            return Result.fail(400, e.getMessage());
        }
    }
}