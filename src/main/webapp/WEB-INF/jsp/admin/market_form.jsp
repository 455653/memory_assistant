<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? '编辑' : '创建'}VIP卡组 - Memory Assistant Admin</title>
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people"></i> 用户管理
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
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/sales">
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
                    <h2><i class="bi bi-${isEdit ? 'pencil' : 'plus-circle'}"></i> ${isEdit ? '编辑' : '创建'}VIP卡组</h2>
                    <a href="${pageContext.request.contextPath}/admin/market" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> 返回列表
                    </a>
                </div>

                <!-- 成功/错误消息 -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show">
                        ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- 卡组信息表单 -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">基本信息</h5>
                    </div>
                    <div class="card-body">
                        <form method="post" enctype="multipart/form-data" 
                              action="${pageContext.request.contextPath}/admin/market/${isEdit ? 'update' : 'create'}">
                            <c:if test="${isEdit}">
                                <input type="hidden" name="id" value="${deck.id}">
                            </c:if>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">卡组名称 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="deckName" 
                                           value="${deck.deckName}" required>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label class="form-label">分类</label>
                                    <input type="text" class="form-control" name="category" 
                                           value="${deck.category}" placeholder="如：英语、历史">
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label class="form-label">价格(元) <span class="text-danger">*</span></label>
                                    <input type="number" step="0.01" class="form-control" name="price" 
                                           value="${deck.price}" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">卡组描述</label>
                                <textarea class="form-control" name="description" rows="3">${deck.description}</textarea>
                            </div>
                            
                            <c:if test="${!isEdit}">
                                <div class="mb-3">
                                    <label class="form-label">导入卡片文件 <span class="text-danger">*</span></label>
                                    <input type="file" class="form-control" name="file" 
                                           accept=".csv,.xlsx" required>
                                    <div class="form-text">
                                        支持 CSV 或 XLSX 格式，第一行为表头，第一列为问题，第二列为答案
                                    </div>
                                </div>
                            </c:if>
                            
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save"></i> ${isEdit ? '保存修改' : '创建卡组'}
                            </button>
                        </form>
                    </div>
                </div>

                <!-- 编辑模式：卡片管理 -->
                <c:if test="${isEdit}">
                    <!-- 追加导入卡片 -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0">追加导入卡片</h5>
                        </div>
                        <div class="card-body">
                            <form method="post" enctype="multipart/form-data" 
                                  action="${pageContext.request.contextPath}/admin/market/import">
                                <input type="hidden" name="deckId" value="${deck.id}">
                                <div class="row">
                                    <div class="col-md-9">
                                        <input type="file" class="form-control" name="file" 
                                               accept=".csv,.xlsx" required>
                                    </div>
                                    <div class="col-md-3">
                                        <button type="submit" class="btn btn-success w-100">
                                            <i class="bi bi-upload"></i> 导入
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- 卡片列表 -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">卡片管理 (共 ${cards.size()} 张)</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead>
                                        <tr>
                                            <th width="5%">ID</th>
                                            <th width="40%">问题</th>
                                            <th width="40%">答案</th>
                                            <th width="15%">操作</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="card" items="${cards}">
                                            <tr id="card-${card.id}">
                                                <td>${card.id}</td>
                                                <td class="question-cell">${card.question}</td>
                                                <td class="answer-cell">${card.answer}</td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary" 
                                                            onclick="editCard(${card.id}, '${card.question}', '${card.answer}', ${card.difficultyLevel})">
                                                        <i class="bi bi-pencil"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger" 
                                                            onclick="deleteCard(${card.id}, ${deck.id})">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- 编辑卡片模态框 -->
    <div class="modal fade" id="editCardModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">编辑卡片</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="editCardId">
                    <div class="mb-3">
                        <label class="form-label">问题</label>
                        <textarea class="form-control" id="editQuestion" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">答案</label>
                        <textarea class="form-control" id="editAnswer" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">难度等级</label>
                        <select class="form-select" id="editDifficulty">
                            <option value="1">简单</option>
                            <option value="2">中等</option>
                            <option value="3">困难</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" onclick="saveCard()">保存</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let editModal;
        
        document.addEventListener('DOMContentLoaded', function() {
            editModal = new bootstrap.Modal(document.getElementById('editCardModal'));
        });
        
        function editCard(id, question, answer, difficulty) {
            document.getElementById('editCardId').value = id;
            document.getElementById('editQuestion').value = question;
            document.getElementById('editAnswer').value = answer;
            document.getElementById('editDifficulty').value = difficulty || 1;
            editModal.show();
        }
        
        function saveCard() {
            const id = document.getElementById('editCardId').value;
            const question = document.getElementById('editQuestion').value;
            const answer = document.getElementById('editAnswer').value;
            const difficulty = document.getElementById('editDifficulty').value;
            
            fetch('${pageContext.request.contextPath}/admin/market/card/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'id=' + id + '&question=' + encodeURIComponent(question) + 
                      '&answer=' + encodeURIComponent(answer) + '&difficultyLevel=' + difficulty
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
        
        function deleteCard(id, deckId) {
            if (confirm('确认删除这张卡片吗？')) {
                fetch('${pageContext.request.contextPath}/admin/market/card/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'id=' + id + '&deckId=' + deckId
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
