package com.example.memoryassistant.interceptor;

import com.example.memoryassistant.entity.SysUser;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 管理员权限拦截器
 */
public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        SysUser loginUser = (SysUser) session.getAttribute("loginUser");
        
        // 检查是否登录
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        // 检查是否是管理员
        if (!"ADMIN".equals(loginUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return false;
        }
        
        return true;
    }
}
