<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${deck.deckName} - VIP商店</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .deck-header {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .price-tag {
            font-size: 2rem;
            font-weight: bold;
            color: #e74c3c;
        }
        .buy-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 40px;
            font-weight: bold;
        }
        .comment-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .comment-item {
            border-bottom: 1px solid #eee;
            padding: 20px 0;
        }
        .comment-item:last-child {
            border-bottom: none;
        }
        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 20px;
        }
        .rating-stars {
            color: #ffc107;
        }
        .comment-form {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-dark mb-4">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1">🛒 VIP卡组详情</span>
            <div class="d-flex">
                <a href="${pageContext.request.contextPath}/market" class="btn btn-outline-light btn-sm me-2">返回商店</a>
                <a href="${pageContext.request.contextPath}/decks" class="btn btn-outline-light btn-sm me-2">我的卡组</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">退出</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- 成功/错误消息 -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 卡组详情 -->
        <div class="deck-header">
            <div class="row">
                <div class="col-md-8">
                    <h2 class="fw-bold mb-3">${deck.deckName}</h2>
                    <p class="text-muted mb-3">${deck.description}</p>
                    <div class="mb-3">
                        <span class="badge bg-primary me-2">${deck.category}</span>
                        <span class="text-muted">
                            <i class="bi bi-card-list"></i> ${deck.cardCount} 张卡片
                        </span>
                    </div>
                </div>
                <div class="col-md-4 text-end">
                    <div class="price-tag mb-3">
                        ¥<fmt:formatNumber value="${deck.price}" pattern="#0.00"/>
                    </div>
                    <c:if test="${!hasPurchased}">
                        <button class="btn btn-primary buy-btn" 
                                onclick="confirmBuy(${deck.id}, '${deck.deckName}', ${deck.price})">
                            <i class="bi bi-cart-plus"></i> 立即购买
                        </button>
                    </c:if>
                    <c:if test="${hasPurchased}">
                        <button class="btn btn-success btn-lg" disabled>
                            <i class="bi bi-check-circle"></i> 已购买
                        </button>
                        <button class="btn btn-warning btn-lg ms-2" data-bs-toggle="modal" data-bs-target="#feedbackModal">
                            <i class="bi bi-pencil-square"></i> 内容纠错/反馈
                        </button>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- 评论区 -->
        <div class="comment-section">
            <h4 class="fw-bold mb-4">
                <i class="bi bi-chat-dots"></i> 用户评价
                <span class="badge bg-secondary">${comments.size()}</span>
            </h4>

            <!-- 评论表单（仅已购买用户可见） -->
            <c:if test="${hasPurchased}">
                <div class="comment-form">
                    <h5 class="mb-3">发表评价</h5>
                    <form action="${pageContext.request.contextPath}/market/comment" method="post">
                        <input type="hidden" name="marketDeckId" value="${deck.id}">
                        
                        <!-- 评分选择 -->
                        <div class="mb-3">
                            <label class="form-label">评分</label>
                            <div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" value="5" id="rating5" checked>
                                    <label class="form-check-label" for="rating5">
                                        ⭐⭐⭐⭐⭐ 非常好
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" value="4" id="rating4">
                                    <label class="form-check-label" for="rating4">
                                        ⭐⭐⭐⭐ 好
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" value="3" id="rating3">
                                    <label class="form-check-label" for="rating3">
                                        ⭐⭐⭐ 一般
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" value="2" id="rating2">
                                    <label class="form-check-label" for="rating2">
                                        ⭐⭐ 较差
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="rating" value="1" id="rating1">
                                    <label class="form-check-label" for="rating1">
                                        ⭐ 很差
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- 评论内容 -->
                        <div class="mb-3">
                            <label for="content" class="form-label">评论内容</label>
                            <textarea class="form-control" id="content" name="content" rows="4" 
                                      placeholder="分享您的使用体验..." required maxlength="500"></textarea>
                            <div class="form-text">最多500字</div>
                        </div>

                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-send"></i> 发布评论
                        </button>
                    </form>
                </div>
            </c:if>

            <c:if test="${!hasPurchased}">
                <div class="alert alert-info">
                    <i class="bi bi-info-circle"></i> 购买后即可发表评价
                </div>
            </c:if>

            <!-- 评论列表 -->
            <div class="mt-4">
                <c:if test="${empty comments}">
                    <div class="text-center text-muted py-5">
                        <i class="bi bi-chat-square-text" style="font-size: 3rem;"></i>
                        <p class="mt-3">暂无评论，快来抢沙发吧！</p>
                    </div>
                </c:if>

                <c:forEach var="comment" items="${comments}">
                    <div class="comment-item">
                        <div class="d-flex">
                            <!-- 用户头像 -->
                            <div class="me-3">
                                <c:choose>
                                    <c:when test="${not empty comment.avatarUrl}">
                                        <img src="${comment.avatarUrl}" class="user-avatar" alt="${comment.nickname}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="user-avatar">
                                            ${comment.nickname.substring(0, 1)}
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- 评论内容 -->
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty comment.nickname}">
                                                    ${comment.nickname}
                                                </c:when>
                                                <c:otherwise>
                                                    ${comment.username}
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>
                                        <span class="rating-stars ms-2">
                                            <c:forEach begin="1" end="${comment.rating}">⭐</c:forEach>
                                        </span>
                                    </div>
                                    <small class="text-muted">
                                        ${comment.createTime.toString().replace('T', ' ').substring(0, 16)}
                                    </small>
                                </div>
                                <p class="mb-0">${comment.content}</p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- 反馈模态框 -->
    <c:if test="${hasPurchased}">
        <div class="modal fade" id="feedbackModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="bi bi-pencil-square"></i> 内容纠错/反馈
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/market/feedback" method="post">
                        <input type="hidden" name="marketDeckId" value="${deck.id}">
                        
                        <div class="modal-body">
                            <!-- 卡组名称 -->
                            <div class="mb-3">
                                <label class="form-label">卡组名称</label>
                                <input type="text" class="form-control" value="${deck.deckName}" readonly>
                            </div>

                            <!-- 反馈内容 -->
                            <div class="mb-3">
                                <label for="feedbackContent" class="form-label">反馈内容 *</label>
                                <textarea class="form-control" 
                                          id="feedbackContent" 
                                          name="content" 
                                          rows="5" 
                                          required 
                                          maxlength="1000"
                                          placeholder="请描述您发现的问题或建议，例如：\n- 卡片内容有误\n- 答案不严谨\n- 排版错误\n- 其他建议"></textarea>
                                <div class="form-text">最多1000字</div>
                            </div>

                            <!-- 联系方式 -->
                            <div class="mb-3">
                                <label for="contactInfo" class="form-label">联系方式（选填）</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="contactInfo" 
                                       name="contactInfo" 
                                       maxlength="100"
                                       placeholder="邮箱或微信，方便我们联系您">
                            </div>

                            <div class="alert alert-info mb-0">
                                <i class="bi bi-info-circle"></i>
                                您的反馈将帮助我们改进卡组质量，感谢您的支持！
                            </div>
                        </div>
                        
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-send"></i> 提交反馈
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </c:if>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmBuy(deckId, deckName, price) {
            const formattedPrice = price.toFixed(2);
            
            if (confirm('确认支付 ¥' + formattedPrice + ' 购买「' + deckName + '」吗？\n\n购买后将自动添加到您的卡组列表中。')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/market/buy/' + deckId;
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
