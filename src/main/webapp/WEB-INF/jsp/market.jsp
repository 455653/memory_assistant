<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VIP商店 - Memory Assistant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .market-card {
            border-radius: 15px;
            transition: all 0.3s;
            height: 100%;
            overflow: hidden;
        }
        .market-card:hover {
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            transform: translateY(-5px);
        }
        .card-cover {
            height: 200px;
            object-fit: cover;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .price-tag {
            font-size: 1.8rem;
            font-weight: bold;
            color: #e74c3c;
        }
        .category-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 1;
        }
        .buy-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 10px 30px;
            font-weight: bold;
        }
        .buy-btn:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-dark mb-4">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1">🛒 VIP卡组商店</span>
            <div class="d-flex">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-light btn-sm me-2">返回首页</a>
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

        <!-- 页面标题 -->
        <div class="text-center mb-5">
            <h2 class="fw-bold">✨ 精选VIP卡组</h2>
            <p class="text-muted">购买专业卡组，快速提升学习效率</p>
        </div>

        <!-- 商品列表 -->
        <c:if test="${empty marketDecks}">
            <div class="alert alert-info text-center">
                <h5>暂无商品</h5>
                <p>敬请期待更多精品卡组上架！</p>
            </div>
        </c:if>

        <div class="row">
            <c:forEach var="deck" items="${marketDecks}">
                <div class="col-md-6 col-lg-4 mb-4">
                    <div class="card market-card">
                        <!-- 分类标签 -->
                        <span class="badge bg-primary category-badge">${deck.category}</span>
                        
                        <!-- 封面图 -->
                        <c:choose>
                            <c:when test="${not empty deck.coverUrl}">
                                <img src="${deck.coverUrl}" class="card-img-top card-cover" alt="${deck.deckName}">
                            </c:when>
                            <c:otherwise>
                                <div class="card-cover"></div>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- 卡组信息 -->
                        <div class="card-body">
                            <h5 class="card-title fw-bold">${deck.deckName}</h5>
                            <p class="text-muted small" style="min-height: 60px;">
                                ${deck.description}
                            </p>
                            
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <span class="text-muted">
                                    <i class="bi bi-card-list"></i> ${deck.cardCount} 张卡片
                                </span>
                                <span class="price-tag">
                                    ¥<fmt:formatNumber value="${deck.price}" pattern="#0.00"/>
                                </span>
                            </div>
                            
                            <!-- 购买按钮 -->
                            <button class="btn btn-primary buy-btn w-100 mb-2" 
                                    onclick="confirmBuy(${deck.id}, '${deck.deckName}', ${deck.price})">
                                <i class="bi bi-cart-plus"></i> 立即购买
                            </button>
                            
                            <!-- 查看详情按钮 -->
                            <a href="${pageContext.request.contextPath}/market/deck/${deck.id}" 
                               class="btn btn-outline-secondary w-100">
                                <i class="bi bi-eye"></i> 查看详情与评价
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmBuy(deckId, deckName, price) {
            // 格式化价格
            const formattedPrice = price.toFixed(2);
            
            // 确认购买对话框
            if (confirm('确认支付 ¥' + formattedPrice + ' 购买「' + deckName + '」吗？\n\n购买后将自动添加到您的卡组列表中。')) {
                // 创建表单并提交
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
