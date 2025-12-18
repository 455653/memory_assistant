<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>反馈管理 - Memory Assistant Admin</title>
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
        .feedback-card {
            margin-bottom: 15px;
            border-left: 4px solid #667eea;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/market">
                            <i class="bi bi-box-seam"></i> VIP卡组管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/feedback">
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
                <h2 class="mb-4">💬 用户反馈管理</h2>

                <c:if test="${empty feedbacks}">
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle"></i> 暂无反馈记录
                    </div>
                </c:if>

                <c:forEach var="feedback" items="${feedbacks}">
                    <div class="card feedback-card">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-8">
                                    <h5 class="card-title">
                                        <i class="bi bi-box"></i> ${feedback.deckName}
                                        <c:choose>
                                            <c:when test="${feedback.status == 0}">
                                                <span class="badge bg-warning">待处理</span>
                                            </c:when>
                                            <c:when test="${feedback.status == 1}">
                                                <span class="badge bg-success">已采纳</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">已忽略</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </h5>
                                    <p class="card-text"><strong>反馈内容：</strong>${feedback.content}</p>
                                    <p class="text-muted small mb-1">
                                        <i class="bi bi-person"></i> 提交人：${feedback.userNickname != null ? feedback.userNickname : feedback.username}
                                    </p>
                                    <c:if test="${not empty feedback.contactInfo}">
                                        <p class="text-muted small mb-1">
                                            <i class="bi bi-telephone"></i> 联系方式：${feedback.contactInfo}
                                        </p>
                                    </c:if>
                                    <p class="text-muted small">
                                        <i class="bi bi-clock"></i> 提交时间：${feedback.createTime.toString().replace('T', ' ').substring(0, 19)}
                                    </p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <c:if test="${feedback.status == 0}">
                                        <button class="btn btn-success mb-2" onclick="updateStatus(${feedback.id}, 1)">
                                            <i class="bi bi-check-circle"></i> 采纳
                                        </button>
                                        <br>
                                        <button class="btn btn-secondary" onclick="updateStatus(${feedback.id}, 2)">
                                            <i class="bi bi-x-circle"></i> 忽略
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateStatus(id, status) {
            const action = status === 1 ? '采纳' : '忽略';
            if (confirm('确认' + action + '该反馈吗？')) {
                fetch('${pageContext.request.contextPath}/admin/feedback/status', {
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
