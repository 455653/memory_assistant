<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>卡组管理 - Memory Assistant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .deck-card {
            border-radius: 10px;
            transition: all 0.3s;
            height: 100%;
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
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-light btn-sm me-2">返回首页</a>
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

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3>📚 我的卡组</h3>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createDeckModal">
                <i class="bi bi-plus-circle"></i> 创建新卡组
            </button>
        </div>

        <c:if test="${empty decks}">
            <div class="alert alert-info text-center">
                <h5>暂无卡组</h5>
                <p>快去创建你的第一个卡组吧！</p>
            </div>
        </c:if>

        <div class="row">
            <c:forEach var="deck" items="${decks}">
                <div class="col-md-4 mb-4">
                    <div class="card deck-card">
                        <div class="card-body">
                            <h5 class="card-title">${deck.deckName}</h5>
                            <p class="text-muted small">${deck.description}</p>
                            <div class="d-flex justify-content-between align-items-center mt-3">
                                <span class="badge bg-primary">${deck.category}</span>
                                <span class="text-muted">${deck.cardCount} 张卡片</span>
                            </div>
                        </div>
                        <div class="card-footer bg-transparent">
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/decks/${deck.id}" class="btn btn-sm btn-outline-primary">
                                    查看详情
                                </a>
                                <div>
                                    <button class="btn btn-sm btn-outline-secondary" 
                                            onclick="editDeck(${deck.id}, '${deck.deckName}', '${deck.description}', '${deck.category}')">
                                        编辑
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger" 
                                            onclick="deleteDeck(${deck.id}, '${deck.deckName}')">
                                        删除
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- 创建卡组弹窗 -->
    <div class="modal fade" id="createDeckModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">创建新卡组</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/decks/create">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">卡组名称 *</label>
                            <input type="text" class="form-control" name="deckName" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">卡组描述</label>
                            <textarea class="form-control" name="description" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">卡组分类</label>
                            <input type="text" class="form-control" name="category" placeholder="例如：编程、语言、历史">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">创建</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 编辑卡组弹窗 -->
    <div class="modal fade" id="editDeckModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">编辑卡组</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" id="editDeckForm">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">卡组名称 *</label>
                            <input type="text" class="form-control" name="deckName" id="editDeckName" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">卡组描述</label>
                            <textarea class="form-control" name="description" id="editDescription" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">卡组分类</label>
                            <input type="text" class="form-control" name="category" id="editCategory">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">保存</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editDeck(deckId, deckName, description, category) {
            document.getElementById('editDeckForm').action = '${pageContext.request.contextPath}/decks/' + deckId + '/update';
            document.getElementById('editDeckName').value = deckName;
            document.getElementById('editDescription').value = description || '';
            document.getElementById('editCategory').value = category || '';
            
            new bootstrap.Modal(document.getElementById('editDeckModal')).show();
        }

        function deleteDeck(deckId, deckName) {
            if (confirm('确定要删除卡组 "' + deckName + '" 吗？删除后将无法恢复！')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/decks/' + deckId + '/delete';
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
