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

    /**
     * 用户注册
     * @param username 用户名
     * @param password 密码
     * @param email 邮箱
     * @param nickname 昵称
     * @return 注册成功的用户对象
     * @throws IllegalArgumentException 当用户名已存在时抛出
     */
    public SysUser register(String username, String password, String email, String nickname) {
        // 检查用户名是否已存在
        if (userMapper.selectByUsername(username) != null) {
            throw new IllegalArgumentException("用户名已存在");
        }
        
        // 创建新用户
        SysUser user = new SysUser();
        user.setUsername(username);
        user.setPassword(password); // 注意：实际项目中应该对密码进行加密
        user.setEmail(email);
        user.setNickname(nickname != null && !nickname.isEmpty() ? nickname : username);
        user.setStatus(1);
        
        userMapper.insert(user);
        return user;
    }

    /**
     * 检查用户名是否已存在
     */
    public boolean isUsernameExists(String username) {
        return userMapper.selectByUsername(username) != null;
    }
}
