<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI卡片预览 - Memory Assistant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 20px 0;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .card-preview {
            border-radius: 10px;
            margin-bottom: 15px;
            transition: all 0.3s;
            border-left: 4px solid #667eea;
        }
        .card-preview:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .card-preview.selected {
            background: #f0f7ff;
            border-left-color: #28a745;
        }
        .question-col {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px 0 0 10px;
        }
        .answer-col {
            padding: 20px;
        }
        .submit-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 40px;
            font-weight: bold;
        }
        .select-all-btn {
            background: #6c757d;
            color: white;
            border: none;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-dark mb-4">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1">🤖 AI生成卡片预览</span>
            <a href="${pageContext.request.contextPath}/decks" class="btn btn-outline-light btn-sm">返回卡组列表</a>
        </div>
    </nav>

    <div class="container">
        <!-- 提示信息 -->
        <div class="alert alert-info">
            <i class="bi bi-info-circle"></i>
            AI已为您生成 <strong>${cards.size()}</strong> 张卡片，请勾选需要保存的卡片（默认全选）
        </div>

        <!-- 保存表单 -->
        <form action="${pageContext.request.contextPath}/deck/ai/save" method="post" id="saveForm">
            <!-- 卡组名称 -->
            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title mb-3">卡组设置</h5>
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <label for="deckName" class="form-label">卡组名称</label>
                            <input type="text" 
                                   class="form-control" 
                                   id="deckName" 
                                   name="deckName" 
                                   value="${deckName}" 
                                   required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label d-block">&nbsp;</label>
                            <button type="button" class="btn select-all-btn me-2" onclick="toggleSelectAll()">
                                <i class="bi bi-check-all"></i> 全选/取消
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 卡片列表 -->
            <div id="cardsList">
                <c:forEach var="card" items="${cards}" varStatus="status">
                    <div class="card card-preview selected" id="card-${status.index}">
                        <div class="card-body">
                            <div class="row">
                                <!-- 复选框 -->
                                <div class="col-auto">
                                    <div class="form-check">
                                        <input class="form-check-input card-checkbox" 
                                               type="checkbox" 
                                               name="selectedIndices" 
                                               value="${status.index}" 
                                               id="checkbox-${status.index}"
                                               checked
                                               onchange="toggleCardStyle(${status.index})">
                                    </div>
                                </div>

                                <!-- 卡片内容 -->
                                <div class="col">
                                    <div class="row">
                                        <!-- 问题 -->
                                        <div class="col-md-6 question-col">
                                            <h6 class="text-primary mb-2">
                                                <i class="bi bi-question-circle"></i> 问题
                                            </h6>
                                            <p class="mb-0">${card.question}</p>
                                        </div>

                                        <!-- 答案 -->
                                        <div class="col-md-6 answer-col">
                                            <h6 class="text-success mb-2">
                                                <i class="bi bi-check-circle"></i> 答案
                                            </h6>
                                            <p class="mb-0">${card.answer}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- 提交按钮 -->
            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary submit-btn btn-lg">
                    <i class="bi bi-save"></i> 确认导入到卡组
                </button>
                <a href="${pageContext.request.contextPath}/deck/ai/create" class="btn btn-outline-secondary btn-lg ms-2">
                    <i class="bi bi-arrow-left"></i> 重新上传
                </a>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 切换单个卡片的样式
        function toggleCardStyle(index) {
            const card = document.getElementById('card-' + index);
            const checkbox = document.getElementById('checkbox-' + index);
            
            if (checkbox.checked) {
                card.classList.add('selected');
            } else {
                card.classList.remove('selected');
            }
        }

        // 全选/取消全选
        function toggleSelectAll() {
            const checkboxes = document.querySelectorAll('.card-checkbox');
            const allChecked = Array.from(checkboxes).every(cb => cb.checked);
            
            checkboxes.forEach((checkbox, index) => {
                checkbox.checked = !allChecked;
                toggleCardStyle(index);
            });
        }

        // 表单提交验证
        document.getElementById('saveForm').addEventListener('submit', function(e) {
            const checkedCount = document.querySelectorAll('.card-checkbox:checked').length;
            
            if (checkedCount === 0) {
                e.preventDefault();
                alert('请至少选择一张卡片！');
                return false;
            }
            
            return confirm('确认导入 ' + checkedCount + ' 张卡片到卡组吗？');
        });
    </script>
</body>
</html>
