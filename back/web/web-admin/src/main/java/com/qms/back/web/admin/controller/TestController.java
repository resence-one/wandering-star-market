package com.qms.back.web.admin.controller;

import com.qms.back.common.Result.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.nio.charset.StandardCharsets;

@RestController
@RequestMapping("/api/test")
public class TestController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/db")
    public Result<String> testDb() {
        try {
            String result = jdbcTemplate.queryForObject("SELECT 1", String.class);
            return Result.ok("数据库连接成功: " + result);
        } catch (Exception e) {
            return Result.fail(500, "数据库连接失败: " + e.getMessage());
        }
    }

    @GetMapping("/init")
    public Result<String> initDb() {
        try {
            // 读取SQL文件
            ClassPathResource resource = new ClassPathResource("db/init.sql");
            String sql = StreamUtils.copyToString(resource.getInputStream(), StandardCharsets.UTF_8);
            
            // 执行SQL语句
            String[] statements = sql.split(";");
            for (String statement : statements) {
                if (!statement.trim().isEmpty()) {
                    jdbcTemplate.execute(statement);
                }
            }
            
            return Result.ok("数据库初始化成功");
        } catch (Exception e) {
            return Result.fail(500, "数据库初始化失败: " + e.getMessage());
        }
    }
} 