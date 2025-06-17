package com.qms.back.web.admin.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.qms.back.common.Result.Result;
import com.qms.back.model.entity.Category;
import com.qms.back.web.admin.mapper.CategoryMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/category")
public class CategoryController {

    @Autowired
    private CategoryMapper categoryMapper;

    @GetMapping("/list")
    public Result<List<Category>> list() {
        LambdaQueryWrapper<Category> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.orderByAsc(Category::getSort);
        List<Category> categories = categoryMapper.selectList(queryWrapper);
        return Result.ok(categories);
    }

    @GetMapping("/{id}")
    public Result<Category> getById(@PathVariable Long id) {
        Category category = categoryMapper.selectById(id);
        if (category == null) {
            return Result.fail(404, "分类不存在");
        }
        return Result.ok(category);
    }
} 