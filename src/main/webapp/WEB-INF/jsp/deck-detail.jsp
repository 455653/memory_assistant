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

        <!-- 错误消息 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
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
                    <div>
                        <button class="btn btn-success me-2" data-bs-toggle="modal" data-bs-target="#addCardModal">
                            ➕ 添加卡片
                        </button>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#importModal">
                            📂 批量导入
                        </button>
                    </div>
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
                            <div class="small text-muted mb-3">
                                <div>复习 ${card.reviewCount} 次</div>
                                <div>正确 ${card.correctCount} 次</div>
                            </div>
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-sm btn-primary edit-card-btn"
                                        data-card-id="${card.id}"
                                        data-card-question="${card.question}"
                                        data-card-answer="${card.answer}"
                                        data-bs-toggle="modal" 
                                        data-bs-target="#editCardModal">
                                    ✏️ 编辑
                                </button>
                                <button type="button" class="btn btn-sm btn-danger delete-card-btn"
                                        data-card-id="${card.id}"
                                        onclick="deleteCard(${card.id})">
                                    🗑️ 删除
                                </button>
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

    <!-- 编辑卡片弹窗 -->
    <div class="modal fade" id="editCardModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">编辑卡片</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/decks/${deck.id}/cards/update">
                    <input type="hidden" id="editCardId" name="id">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">问题（正面） *</label>
                            <textarea class="form-control" id="editCardQuestion" name="question" rows="4" required 
                                      placeholder="输入卡片的问题..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">答案（背面） *</label>
                            <textarea class="form-control" id="editCardAnswer" name="answer" rows="6" required 
                                      placeholder="输入卡片的答案..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">保存修改</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 导入 Excel 弹窗 -->
    <div class="modal fade" id="importModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">📂 批量导入卡片</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/decks/${deck.id}/cards/import" 
                      enctype="multipart/form-data">
                    <div class="modal-body">
                        <div class="alert alert-info">
                            <small>💡 提示：</small>
                            <ul class="small mb-0">
                                <li>支持 <strong>.xlsx</strong> 和 <strong>.csv</strong> 两种格式</li>
                                <li>第一列为<strong>问题</strong>，第二列为<strong>答案</strong></li>
                                <li>第一行为表头，从第二行开始导入数据</li>
                                <li>CSV 文件请使用 <strong>UTF-8</strong> 编码保存，避免中文乱码</li>
                            </ul>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">选择文件 (.xlsx 或 .csv) *</label>
                            <input type="file" class="form-control" name="file" 
                                   accept=".xlsx,.csv,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,text/csv" 
                                   required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">模板示例：</label>
                            <div class="mb-2">
                                <small class="text-muted"><strong>Excel (.xlsx) / CSV (.csv) 格式：</strong></small>
                            </div>
                            <table class="table table-sm table-bordered">
                                <thead class="table-light">
                                    <tr>
                                        <th>问题</th>
                                        <th>答案</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Java中的JVM是什么？</td>
                                        <td>Java虚拟机，负责执行Java字节码</td>
                                    </tr>
                                    <tr>
                                        <td>HTTP协议的默认端口是？</td>
                                        <td>80</td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="alert alert-warning alert-sm mt-2">
                                <small>⚠️ <strong>CSV 文件注意：</strong>在 Excel 中编辑后，请选择“另存为” → 保存类型选择“CSV UTF-8（逗号分隔）”或使用文本编辑器以 UTF-8 编码保存。</small>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">🚀 开始导入</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 编辑卡片 - 回显数据到Modal
        document.addEventListener('DOMContentLoaded', function() {
            const editButtons = document.querySelectorAll('.edit-card-btn');
            
            editButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const cardId = this.getAttribute('data-card-id');
                    const cardQuestion = this.getAttribute('data-card-question');
                    const cardAnswer = this.getAttribute('data-card-answer');
                    
                    // 填充表单数据
                    document.getElementById('editCardId').value = cardId;
                    document.getElementById('editCardQuestion').value = cardQuestion;
                    document.getElementById('editCardAnswer').value = cardAnswer;
                });
            });
        });

        // 删除卡片
        function deleteCard(cardId) {
            if (confirm('确定要删除这张卡片吗？此操作不可恢复！')) {
                // 创建并提交表单
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/decks/${deck.id}/cards/' + cardId + '/delete';
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
