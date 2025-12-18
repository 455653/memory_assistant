package com.example.memoryassistant.config;

import com.example.memoryassistant.interceptor.AdminInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Web MVC 配置
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 注册管理员拦截器
        registry.addInterceptor(new AdminInterceptor())
                .addPathPatterns("/admin/**")  // 拦截所有 /admin/** 路径
                .excludePathPatterns("/admin/login");  // 排除登录页面
    }
}
