<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>销售记录 - Memory Assistant Admin</title>
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
        .revenue-card {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/sales">
                            <i class="bi bi-cash-stack"></i> 销售记录
                        </a>
                    </li>
                    <li class="nav-item mt-4">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right"></i> 退出登录
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 主内容区 -->
            <div class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>💰 销售记录</h2>
                    <div class="revenue-card">
                        <div class="d-flex align-items-center">
                            <i class="bi bi-currency-dollar" style="font-size: 2.5rem; margin-right: 15px;"></i>
                            <div>
                                <div style="font-size: 0.9rem; opacity: 0.9;">总销售额</div>
                                <div style="font-size: 1.8rem; font-weight: bold;">
                                    ¥<fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>订单ID</th>
                                        <th>购买用户</th>
                                        <th>昵称</th>
                                        <th>卡组名称</th>
                                        <th>价格</th>
                                        <th>购买时间</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="record" items="${salesRecords}">
                                        <tr>
                                            <td>#${record.purchaseId}</td>
                                            <td><strong>${record.username}</strong></td>
                                            <td>${record.nickname}</td>
                                            <td>
                                                <i class="bi bi-box-seam text-primary"></i>
                                                ${record.deckName}
                                            </td>
                                            <td class="text-danger fw-bold">
                                                ¥<fmt:formatNumber value="${record.price}" pattern="#0.00"/>
                                            </td>
                                            <td>
                                                ${record.purchaseTime.toString().replace('T', ' ').substring(0, 16)}
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        
                        <c:if test="${empty salesRecords}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-inbox" style="font-size: 3rem;"></i>
                                <p class="mt-2">暂无销售记录</p>
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
