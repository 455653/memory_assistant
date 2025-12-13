<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>仪表盘 - Memory Assistant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .stat-card {
            border-radius: 15px;
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .deck-card {
            border-radius: 10px;
            transition: all 0.3s;
        }
        .deck-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transform: translateY(-3px);
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-dark mb-4">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1">🧠 Memory Assistant</span>
            <div class="d-flex">
                <span class="text-white me-3">欢迎, ${sessionScope.nickname}</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">退出</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- 统计卡片 -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card stat-card shadow-sm">
                    <div class="card-body text-center">
                        <h3 class="text-primary">${dueCount}</h3>
                        <p class="text-muted mb-0">今日待复习卡片</p>
                        <c:if test="${dueCount > 0}">
                            <a href="${pageContext.request.contextPath}/review" class="btn btn-primary mt-3">
                                开始复习 🚀
                            </a>
                        </c:if>
                        <c:if test="${dueCount == 0}">
                            <p class="text-success mt-3 mb-0">✅ 今天已完成所有复习！</p>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card stat-card shadow-sm">
                    <div class="card-body text-center">
                        <h3 class="text-success">${decks.size()}</h3>
                        <p class="text-muted mb-0">我的卡组数量</p>
                        <a href="${pageContext.request.contextPath}/decks" class="btn btn-outline-success mt-3">
                            管理卡组
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- 今日待复习卡片列表 -->
        <c:if test="${not empty dueCards}">
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-white">
                    <h5 class="mb-0">📝 今日待复习卡片 (${dueCount})</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>问题</th>
                                    <th>阶段</th>
                                    <th>复习次数</th>
                                    <th>正确率</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="card" items="${dueCards}" varStatus="status">
                                    <c:if test="${status.index < 5}">
                                        <tr>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${card.question.length() > 50}">
                                                        ${card.question.substring(0, 50)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${card.question}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge bg-info">阶段 ${card.stage}</span>
                                            </td>
                                            <td>${card.reviewCount}</td>
                                            <td>
                                                <c:set var="rate" value="${card.reviewCount > 0 ? (card.correctCount * 100.0 / card.reviewCount) : 0}" />
                                                <c:choose>
                                                    <c:when test="${rate >= 80}">
                                                        <span class="text-success">${rate}%</span>
                                                    </c:when>
                                                    <c:when test="${rate >= 50}">
                                                        <span class="text-warning">${rate}%</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-danger">${rate}%</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${dueCount > 5}">
                        <p class="text-muted text-center mb-0">还有 ${dueCount - 5} 张卡片...</p>
                    </c:if>
                </div>
            </div>
        </c:if>

        <!-- 我的卡组列表 -->
        <div class="card shadow-sm">
            <div class="card-header bg-white">
                <h5 class="mb-0">📚 我的卡组</h5>
            </div>
            <div class="card-body">
                <c:if test="${empty decks}">
                    <p class="text-muted text-center">暂无卡组，快去创建一个吧！</p>
                </c:if>
                
                <div class="row">
                    <c:forEach var="deck" items="${decks}">
                        <div class="col-md-4 mb-3">
                            <div class="card deck-card h-100">
                                <div class="card-body">
                                    <h6 class="card-title">${deck.deckName}</h6>
                                    <p class="text-muted small mb-2">${deck.description}</p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="badge bg-secondary">${deck.category}</span>
                                        <span class="text-muted">${deck.cardCount} 张卡片</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
