package com.qms.back.web.admin.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.qms.back.model.entity.Game;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface GameMapper extends BaseMapper<Game> {
}