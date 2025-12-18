package com.example.memoryassistant.mapper;

import com.example.memoryassistant.entity.SysUser;
import java.util.List;

/**
 * 用户 Mapper 接口
 */
public interface SysUserMapper {
    
    /**
     * 根据ID查询用户
     */
    SysUser selectById(Long id);
    
    /**
     * 根据用户名查询用户
     */
    SysUser selectByUsername(String username);
    
    /**
     * 插入用户
     */
    int insert(SysUser user);
    
    /**
     * 更新用户
     */
    int update(SysUser user);
    
    /**
     * 统计用户总数
     */
    int countAll();
    
    /**
     * 查询所有用户
     */
    List<SysUser> selectAll();
}
