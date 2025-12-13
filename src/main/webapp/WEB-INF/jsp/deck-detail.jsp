<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${deck.deckName} - Memory Assistant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Noto+Sans+SC:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Inter', 'Noto Sans SC', sans-serif;
        }
        
        body {
            background-color: #f8f9fc;
        }
        
        .navbar {
            background: linear-gradient(135deg, #4e73df 0%, #764ba2 100%);
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            padding: 1rem 0;
        }
        
        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 700;
        }
        
        .btn-modern {
            border-radius: 10px;
            padding: 10px 24px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
        }
        
        .btn-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
        }
        
        .card-modern {
            background: white;
            border-radius: 15px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            border: none;
            margin-bottom: 25px;
        }
        
        .deck-header {
            background: linear-gradient(135deg, #4e73df 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 35px;
            margin-bottom: 30px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(78, 115, 223, 0.3);
        }
        
        .deck-header h3 {
            font-weight: 700;
            margin-bottom: 10px;
            font-size: 2rem;
        }
        
        .badge-modern {
            padding: 8px 14px;
            border-radius: 10px;
            font-weight: 500;
            font-size: 0.9rem;
        }
        
        /* 卡片列表项 - 长条形悬浮卡片 */
        .flashcard-item {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 15px;
            border: 1px solid #e3e6f0;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }
        
        .flashcard-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(78, 115, 223, 0.2);
            border-color: #4e73df;
        }
        
        .question-text {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2e59d9;
            margin-bottom: 8px;
        }
        
        .answer-text {
            font-size: 0.95rem;
            color: #858796;
            line-height: 1.6;
        }
        
        .card-stats {
            display: flex;
            gap: 15px;
            margin-top: 10px;
        }
        
        .stat-badge {
            background: #f8f9fc;
            padding: 5px 12px;
            border-radius: 8px;
            font-size: 0.85rem;
            color: #5a5c69;
        }
        
        .modal-modern .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 0.5rem 2rem rgba(0, 0, 0, 0.2);
        }
        
        .modal-modern .modal-header {
            border-bottom: 2px solid #f8f9fc;
            padding: 25px;
            border-radius: 15px 15px 0 0;
            background: linear-gradient(135deg, #4e73df 0%, #764ba2 100%);
            color: white;
        }
        
        .modal-modern .modal-title {
            font-weight: 600;
            font-size: 1.3rem;
        }
        
        .modal-modern .btn-close {
            filter: brightness(0) invert(1);
        }
        
        .form-control {
            border: 2px solid #e3e6f0;
            border-radius: 10px;
            padding: 12px 16px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }
        
        .alert-modern {
            border-radius: 12px;
            border: none;
            padding: 18px 22px;
            border-left: 4px solid;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        }
        
        .empty-state i {
            font-size: 80px;
            color: #d1d3e2;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-dark mb-4">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-brain"></i> Memory Assistant
            </a>
            <div class="d-flex">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-light btn-modern me-2">
                    <i class="bi bi-house me-1"></i>首页
                </a>
                <a href="${pageContext.request.contextPath}/decks" class="btn btn-light btn-modern me-2">
                    <i class="bi bi-grid me-1"></i>卡组
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-modern">
                    <i class="bi bi-box-arrow-right me-1"></i>退出
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- 成功消息 -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-modern alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 错误消息 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-modern alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 卡组信息头部 -->
        <div class="deck-header">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h3><i class="bi bi-folder2-open me-2"></i>${deck.deckName}</h3>
                    <p class="mb-3 opacity-90">${deck.description}</p>
                    <div>
                        <span class="badge badge-modern bg-light text-dark">
                            <i class="bi bi-tag me-1"></i>${deck.category}
                        </span>
                        <span class="badge badge-modern bg-light text-dark ms-2">
                            <i class="bi bi-card-list me-1"></i>${cards.size()} 张卡片
                        </span>
                    </div>
                </div>
                <div class="col-md-4 text-end">
                    <button class="btn btn-light btn-modern me-2" data-bs-toggle="modal" data-bs-target="#addCardModal">
                        <i class="bi bi-plus-circle me-2"></i>添加卡片
                    </button>
                    <button class="btn btn-outline-light btn-modern" data-bs-toggle="modal" data-bs-target="#importModal">
                        <i class="bi bi-file-earmark-arrow-up me-2"></i>批量导入
                    </button>
                </div>
            </div>
        </div>

        <!-- 卡片列表标题 -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="mb-0">
                <i class="bi bi-card-checklist me-2 text-primary"></i>卡片列表
            </h5>
        </div>
        
        <!-- 空状态 -->
        <c:if test="${empty cards}">
            <div class="empty-state">
                <i class="bi bi-inbox"></i>
                <h5 class="text-muted">暂无卡片</h5>
                <p class="text-muted">点击上方"添加卡片"按钮创建第一张卡片吧！</p>
                <button class="btn btn-primary btn-modern mt-3" data-bs-toggle="modal" data-bs-target="#addCardModal">
                    <i class="bi bi-plus-circle me-2"></i>创建第一张卡片
                </button>
            </div>
        </c:if>

        <!-- 卡片列表 - 长条形卡片设计 -->
        <c:forEach var="card" items="${cards}" varStatus="status">
            <div class="flashcard-item">
                <div class="row align-items-start">
                    <div class="col-md-5">
                        <div class="mb-2">
                            <small class="text-uppercase text-muted fw-bold" style="font-size: 0.75rem;">
                                <i class="bi bi-question-circle me-1"></i>问题
                            </small>
                        </div>
                        <div class="question-text">${card.question}</div>
                    </div>
                    <div class="col-md-4">
                        <div class="mb-2">
                            <small class="text-uppercase text-muted fw-bold" style="font-size: 0.75rem;">
                                <i class="bi bi-check-circle me-1"></i>答案
                            </small>
                        </div>
                        <div class="answer-text">${card.answer}</div>
                    </div>
                    <div class="col-md-3">
                        <div class="d-flex flex-column align-items-end">
                            <span class="badge badge-modern bg-info mb-2">
                                <i class="bi bi-bar-chart me-1"></i>阶段 ${card.stage}
                            </span>
                            <div class="card-stats">
                                <span class="stat-badge">
                                    <i class="bi bi-arrow-repeat me-1"></i>${card.reviewCount} 次
                                </span>
                                <span class="stat-badge">
                                    <i class="bi bi-check-lg me-1"></i>${card.correctCount} 对
                                </span>
                            </div>
                            <div class="btn-group mt-3" role="group">
                                <button type="button" class="btn btn-sm btn-primary edit-card-btn"
                                        data-card-id="${card.id}"
                                        data-card-question="${card.question}"
                                        data-card-answer="${card.answer}"
                                        data-bs-toggle="modal" 
                                        data-bs-target="#editCardModal">
                                    <i class="bi bi-pencil me-1"></i>编辑
                                </button>
                                <button type="button" class="btn btn-sm btn-danger delete-card-btn"
                                        data-card-id="${card.id}"
                                        onclick="deleteCard(${card.id})">
                                    <i class="bi bi-trash me-1"></i>删除
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 添加卡片弹窗 -->
    <div class="modal fade modal-modern" id="addCardModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-plus-circle me-2"></i>添加新卡片到 "${deck.deckName}"
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/decks/${deck.id}/cards/add">
                    <div class="modal-body p-4">
                        <div class="mb-4">
                            <label class="form-label fw-bold">
                                <i class="bi bi-question-circle me-1"></i>问题（正面） *
                            </label>
                            <textarea class="form-control" name="question" rows="4" required 
                                      placeholder="输入卡片的问题..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                <i class="bi bi-check-circle me-1"></i>答案（背面） *
                            </label>
                            <textarea class="form-control" name="answer" rows="6" required 
                                      placeholder="输入卡片的答案..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-modern" data-bs-dismiss="modal">
                            <i class="bi bi-x-circle me-1"></i>取消
                        </button>
                        <button type="submit" class="btn btn-success btn-modern">
                            <i class="bi bi-check-lg me-1"></i>添加
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 编辑卡片弹窗 -->
    <div class="modal fade modal-modern" id="editCardModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-pencil me-2"></i>编辑卡片
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/decks/${deck.id}/cards/update">
                    <input type="hidden" id="editCardId" name="id">
                    <div class="modal-body p-4">
                        <div class="mb-4">
                            <label class="form-label fw-bold">
                                <i class="bi bi-question-circle me-1"></i>问题（正面） *
                            </label>
                            <textarea class="form-control" id="editCardQuestion" name="question" rows="4" required 
                                      placeholder="输入卡片的问题..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">
                                <i class="bi bi-check-circle me-1"></i>答案（背面） *
                            </label>
                            <textarea class="form-control" id="editCardAnswer" name="answer" rows="6" required 
                                      placeholder="输入卡片的答案..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-modern" data-bs-dismiss="modal">
                            <i class="bi bi-x-circle me-1"></i>取消
                        </button>
                        <button type="submit" class="btn btn-primary btn-modern">
                            <i class="bi bi-save me-1"></i>保存修改
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 导入批量卡片弹窗 -->
    <div class="modal fade modal-modern" id="importModal" tabindex="-1">
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
