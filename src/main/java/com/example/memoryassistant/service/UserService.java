package com.example.memoryassistant.service;

import com.example.memoryassistant.entity.SysUser;
import com.example.memoryassistant.mapper.SysUserMapper;
import org.springframework.stereotype.Service;

/**
 * 用户服务
 */
@Service
public class UserService {

    private final SysUserMapper userMapper;

    public UserService(SysUserMapper userMapper) {
        this.userMapper = userMapper;
    }

    /**
     * 根据用户名查询用户
     */
    public SysUser getUserByUsername(String username) {
        return userMapper.selectByUsername(username);
    }

    /**
     * 根据ID查询用户
     */
    public SysUser getUserById(Long userId) {
        return userMapper.selectById(userId);
    }

    /**
     * 用户登录验证
     */
    public SysUser login(String username, String password) {
        SysUser user = userMapper.selectByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    /**
     * 创建用户
     */
    public SysUser createUser(SysUser user) {
        user.setStatus(1);
        userMapper.insert(user);
        return user;
    }
}
