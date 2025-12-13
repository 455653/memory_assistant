<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册 - Memory Assistant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Noto+Sans+SC:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', 'Noto Sans SC', sans-serif;
            background: url('https://images.unsplash.com/photo-1557683316-973673baf926?w=1920') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }
        
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(78, 115, 223, 0.85) 0%, rgba(118, 75, 162, 0.85) 100%);
        }
        
        .register-container {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 500px;
            padding: 20px;
        }
        
        .register-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-radius: 25px;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.3), 0 0 0 1px rgba(255, 255, 255, 0.1);
            padding: 50px 40px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .logo {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .logo-icon {
            font-size: 60px;
            margin-bottom: 15px;
            display: block;
        }
        
        .logo h1 {
            color: #4e73df;
            font-weight: 700;
            font-size: 32px;
            margin-bottom: 10px;
            letter-spacing: -0.5px;
        }
        
        .logo p {
            color: #6c757d;
            font-size: 14px;
            font-weight: 400;
        }
        
        .form-label {
            color: #3a3b45;
            font-weight: 500;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .form-control {
            border: none;
            border-bottom: 2px solid #e3e6f0;
            border-radius: 8px;
            padding: 15px 20px;
            background: #f8f9fc;
            font-size: 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            background: #fff;
            border-bottom-color: #4e73df;
            box-shadow: 0 5px 15px rgba(78, 115, 223, 0.1);
            outline: none;
        }
        
        .input-group-icon {
            position: relative;
        }
        
        .input-group-icon .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #858796;
            font-size: 18px;
        }
        
        .input-group-icon .form-control {
            padding-left: 45px;
        }
        
        .btn-register {
            background: linear-gradient(135deg, #4e73df 0%, #764ba2 100%);
            border: none;
            border-radius: 12px;
            padding: 15px;
            font-size: 16px;
            font-weight: 600;
            color: white;
            width: 100%;
            margin-top: 25px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(78, 115, 223, 0.3);
        }
        
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(78, 115, 223, 0.4);
            background: linear-gradient(135deg, #5a7ee6 0%, #8257ad 100%);
        }
        
        .btn-register:active {
            transform: translateY(0);
        }
        
        .alert {
            border-radius: 12px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 25px;
            font-size: 14px;
            background: rgba(220, 53, 69, 0.1);
            color: #dc3545;
            border-left: 4px solid #dc3545;
        }
        
        .login-link {
            text-align: center;
            color: #858796;
            font-size: 14px;
            padding: 15px;
            background: #f8f9fc;
            border-radius: 10px;
        }
        
        .login-link a {
            color: #4e73df;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        
        .login-link a:hover {
            color: #2e59d9;
            text-decoration: underline;
        }
        
        .form-text {
            font-size: 12px;
            color: #858796;
            margin-top: 5px;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .register-card {
            animation: fadeIn 0.6s ease;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-card">
            <div class="logo">
                <span class="logo-icon">🧠</span>
                <h1>Memory Assistant</h1>
                <p>创建你的学习账户</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert" role="alert">
                    <i class="bi bi-exclamation-circle me-2"></i>${error}
                </div>
            </c:if>
            
            <form method="post" action="${pageContext.request.contextPath}/register">
                <div class="mb-4">
                    <label for="username" class="form-label">
                        <i class="bi bi-person-fill me-1"></i>用户名 *
                    </label>
                    <div class="input-group-icon">
                        <i class="bi bi-person input-icon"></i>
                        <input type="text" class="form-control" id="username" name="username" 
                               placeholder="请输入用户名" value="${username}" required autofocus
                               minlength="3" maxlength="50">
                    </div>
                    <div class="form-text">用户名长度为 3-50 个字符</div>
                </div>
                
                <div class="mb-4">
                    <label for="password" class="form-label">
                        <i class="bi bi-lock-fill me-1"></i>密码 *
                    </label>
                    <div class="input-group-icon">
                        <i class="bi bi-shield-lock input-icon"></i>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="请输入密码" required
                               minlength="6" maxlength="100">
                    </div>
                    <div class="form-text">密码长度至少为 6 个字符</div>
                </div>
                
                <div class="mb-4">
                    <label for="email" class="form-label">
                        <i class="bi bi-envelope-fill me-1"></i>邮箱
                    </label>
                    <div class="input-group-icon">
                        <i class="bi bi-envelope input-icon"></i>
                        <input type="email" class="form-control" id="email" name="email" 
                               placeholder="请输入邮箱（选填）" value="${email}"
                               maxlength="100">
                    </div>
                    <div class="form-text">用于账户找回和通知</div>
                </div>
                
                <div class="mb-4">
                    <label for="nickname" class="form-label">
                        <i class="bi bi-tag-fill me-1"></i>昵称
                    </label>
                    <div class="input-group-icon">
                        <i class="bi bi-tag input-icon"></i>
                        <input type="text" class="form-control" id="nickname" name="nickname" 
                               placeholder="请输入昵称（选填，默认使用用户名）" value="${nickname}"
                               maxlength="50">
                    </div>
                    <div class="form-text">显示在个人资料中</div>
                </div>
                
                <button type="submit" class="btn-register">
                    <i class="bi bi-person-plus me-2"></i>注册
                </button>
                
                <div class="login-link">
                    <i class="bi bi-info-circle me-1"></i>
                    已有账户？<a href="${pageContext.request.contextPath}/login">立即登录</a>
                </div>
            </form>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
