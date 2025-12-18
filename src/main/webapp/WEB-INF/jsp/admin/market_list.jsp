<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VIP卡组管理 - Memory Assistant Admin</title>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/market">
                            <i class="bi bi-box-seam"></i> VIP卡组管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/feedback">
                            <i class="bi bi-chat-dots"></i> 反馈管理
                        </a>
                    </li>
                    <li class="nav-item mt-4">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="bi bi-arrow-left-circle"></i> 返回用户端
                        </a>
                    </li>
                </ul>
            </div>

            <!-- 主内容区 -->
            <div class="col-md-10 p-4">
                <h2 class="mb-4">📦 VIP卡组管理</h2>

                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>卡组名称</th>
                                        <th>分类</th>
                                        <th>价格</th>
                                        <th>卡片数</th>
                                        <th>状态</th>
                                        <th>创建时间</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="deck" items="${marketDecks}">
                                        <tr>
                                            <td>${deck.id}</td>
                                            <td><strong>${deck.deckName}</strong></td>
                                            <td><span class="badge bg-info">${deck.category}</span></td>
                                            <td class="text-danger fw-bold">¥<fmt:formatNumber value="${deck.price}" pattern="#0.00"/></td>
                                            <td>${deck.cardCount}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${deck.status == 1}">
                                                        <span class="badge bg-success">已上架</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">已下架</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                ${deck.createTime.toString().substring(0, 10)}
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${deck.status == 1}">
                                                        <button class="btn btn-sm btn-warning" onclick="toggleStatus(${deck.id}, 0)">
                                                            <i class="bi bi-eye-slash"></i> 下架
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-sm btn-success" onclick="toggleStatus(${deck.id}, 1)">
                                                            <i class="bi bi-eye"></i> 上架
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleStatus(id, status) {
            const action = status === 1 ? '上架' : '下架';
            if (confirm('确认' + action + '该卡组吗？')) {
                fetch('${pageContext.request.contextPath}/admin/market/status', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'id=' + id + '&status=' + status
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    alert('操作失败');
                    console.error('Error:', error);
                });
            }
        }
    </script>
</body>
</html>
