<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - Memory Assistant Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding-top: 20px;
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 15px 20px;
            margin: 5px 0;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            color: #fff;
            background: rgba(255,255,255,0.2);
            border-radius: 5px;
        }
        .avatar-img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- 侧边栏 -->
            <div class="col-md-2 sidebar">
                <h4 class="text-white text-center mb-4">
                    <i class="bi bi-shield-check"></i> 管理后台
                </h4>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-speedometer2"></i> 仪表盘
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people"></i> 用户管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/market">
                            <i class="bi bi-box-seam"></i> VIP卡组管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/feedback">
                            <i class="bi bi-chat-dots"></i> 反馈管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/sales">
                            <i class="bi bi-cash-stack"></i> 销售记录
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 主内容区 -->
            <div class="col-md-10 p-4">
                <h2 class="mb-4">👥 用户管理</h2>

                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>头像</th>
                                        <th>用户名</th>
                                        <th>昵称</th>
                                        <th>邮箱</th>
                                        <th>角色</th>
                                        <th>注册时间</th>
                                        <th>状态</th>
                                        <!-- <th>操作</th> -->
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty user.avatarUrl}">
                                                        <img src="${user.avatarUrl}" alt="头像" class="avatar-img">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="avatar-img bg-secondary d-flex align-items-center justify-content-center text-white">
                                                            ${user.username.substring(0, 1).toUpperCase()}
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><strong>${user.username}</strong></td>
                                            <td>${user.nickname}</td>
                                            <td>${user.email != null ? user.email : '-'}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.role == 'ADMIN'}">
                                                        <span class="badge bg-danger">管理员</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-primary">普通用户</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${user.createTime.toString().substring(0, 10)}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.status == 1}">
                                                        <span class="badge bg-success">正常</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">禁用</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <!-- <td>
                                                <button class="btn btn-sm btn-outline-secondary" disabled>
                                                    TODO
                                                </button>
                                            </td> -->
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <c:if test="${empty users}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-inbox" style="font-size: 3rem;"></i>
                                <p class="mt-2">暂无用户数据</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
