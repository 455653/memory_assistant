<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${deck.deckName} - Memory Assistant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .card-item {
            border-radius: 10px;
            transition: all 0.3s;
            margin-bottom: 15px;
        }
        .card-item:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-dark mb-4">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1">🧠 Memory Assistant</span>
            <div class="d-flex">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-light btn-sm me-2">返回首页</a>
                <a href="${pageContext.request.contextPath}/decks" class="btn btn-outline-light btn-sm me-2">卡组列表</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">退出</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- 成功消息 -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 卡组信息 -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h3 class="mb-2">${deck.deckName}</h3>
                        <p class="text-muted mb-2">${deck.description}</p>
                        <div>
                            <span class="badge bg-primary">${deck.category}</span>
                            <span class="badge bg-info ms-2">${cards.size()} 张卡片</span>
                        </div>
                    </div>
                    <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addCardModal">
                        ➕ 添加卡片
                    </button>
                </div>
            </div>
        </div>

        <!-- 卡片列表 -->
        <h5 class="mb-3">📝 卡片列表</h5>
        
        <c:if test="${empty cards}">
            <div class="alert alert-info text-center">
                <h5>暂无卡片</h5>
                <p>点击上方"添加卡片"按钮创建第一张卡片吧！</p>
            </div>
        </c:if>

        <c:forEach var="card" items="${cards}" varStatus="status">
            <div class="card card-item">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-5">
                            <h6 class="text-primary">问题</h6>
                            <p>${card.question}</p>
                        </div>
                        <div class="col-md-5">
                            <h6 class="text-success">答案</h6>
                            <p>${card.answer}</p>
                        </div>
                        <div class="col-md-2 text-end">
                            <div class="mb-2">
                                <span class="badge bg-info">阶段 ${card.stage}</span>
                            </div>
                            <div class="small text-muted">
                                <div>复习 ${card.reviewCount} 次</div>
                                <div>正确 ${card.correctCount} 次</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 添加卡片弹窗 -->
    <div class="modal fade" id="addCardModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">添加新卡片到 "${deck.deckName}"</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/decks/${deck.id}/cards/add">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">问题（正面） *</label>
                            <textarea class="form-control" name="question" rows="4" required 
                                      placeholder="输入卡片的问题..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">答案（背面） *</label>
                            <textarea class="form-control" name="answer" rows="6" required 
                                      placeholder="输入卡片的答案..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-success">添加</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
