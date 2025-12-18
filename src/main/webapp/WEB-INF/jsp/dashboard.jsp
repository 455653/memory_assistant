<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>仪表盘 - Memory Assistant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Noto+Sans+SC:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Inter', 'Noto Sans SC', sans-serif;
        }
        
        body {
            background-color: #f8f9fc;
            min-height: 100vh;
        }
        
        .navbar {
            background: linear-gradient(135deg, #4e73df 0%, #764ba2 100%);
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            padding: 1rem 0;
        }
        
        .navbar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: -0.5px;
        }
        
        .welcome-banner {
            background: linear-gradient(135deg, #4e73df 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 40px;
            margin-bottom: 30px;
            color: white;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(78, 115, 223, 0.3);
            position: relative;
            overflow: hidden;
        }
        
        .welcome-banner::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
        }
        
        .welcome-banner h2 {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }
        
        .welcome-banner p {
            font-size: 1.1rem;
            opacity: 0.95;
            position: relative;
            z-index: 1;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            transition: all 0.3s ease;
            border: none;
            overflow: hidden;
            position: relative;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.5rem 2rem 0 rgba(58, 59, 69, 0.25);
        }
        
        .stat-card .card-body {
            padding: 30px;
        }
        
        .stat-icon {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 80px;
            opacity: 0.15;
            color: currentColor;
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 5px;
            position: relative;
            z-index: 1;
        }
        
        .stat-label {
            font-size: 0.95rem;
            color: #858796;
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.5px;
            position: relative;
            z-index: 1;
        }
        
        .btn-modern {
            border-radius: 10px;
            padding: 12px 28px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
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
        
        .card-header-modern {
            background: white;
            border-bottom: 2px solid #f8f9fc;
            padding: 20px 25px;
            border-radius: 15px 15px 0 0 !important;
        }
        
        .card-header-modern h5 {
            margin: 0;
            font-weight: 600;
            color: #3a3b45;
            font-size: 1.2rem;
        }
        
        .deck-card {
            border-radius: 12px;
            transition: all 0.3s ease;
            border: 1px solid #e3e6f0;
            background: white;
        }
        
        .deck-card:hover {
            box-shadow: 0 0.5rem 1.5rem rgba(0, 0, 0, 0.1);
            transform: translateY(-3px);
            border-color: #4e73df;
        }
        
        .badge-modern {
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 500;
            font-size: 0.85rem;
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
        }
        
        .modal-modern .modal-title {
            font-weight: 600;
            font-size: 1.3rem;
        }
        
        .form-check-modern .form-check-input {
            width: 20px;
            height: 20px;
            border-radius: 5px;
            border: 2px solid #d1d3e2;
        }
        
        .form-check-modern .form-check-input:checked {
            background-color: #4e73df;
            border-color: #4e73df;
        }
        
        .alert-modern {
            border-radius: 12px;
            border: none;
            padding: 15px 20px;
            border-left: 4px solid;
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
            <div class="d-flex align-items-center">
                <c:choose>
                    <c:when test="${sessionScope.loginUser.role == 'ADMIN'}">
                        <!-- 管理员菜单 -->
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-light btn-modern me-2">
                            <i class="bi bi-speedometer2 me-1"></i>管理后台
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/market" class="btn btn-outline-light btn-modern me-2">
                            <i class="bi bi-shop me-1"></i>VIP卡组管理
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/feedback" class="btn btn-outline-light btn-modern me-2">
                            <i class="bi bi-chat-square-text me-1"></i>反馈管理
                        </a>
                    </c:when>
                    <c:otherwise>
                        <!-- 普通用户菜单 -->
                        <a href="${pageContext.request.contextPath}/market" class="btn btn-outline-light btn-modern me-2">
                            <i class="bi bi-cart me-1"></i>VIP商店
                        </a>
                        <a href="${pageContext.request.contextPath}/decks" class="btn btn-light btn-modern me-2">
                            <i class="bi bi-folder me-1"></i>卡组管理
                        </a>
                    </c:otherwise>
                </c:choose>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-modern">
                    <i class="bi bi-box-arrow-right me-1"></i>退出
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- 欢迎 Banner -->
        <div class="welcome-banner">
            <h2><i class="bi bi-emoji-smile me-2"></i>欢迎回来, ${sessionScope.nickname}!</h2>
            <p><i class="bi bi-calendar-check me-2"></i>今天也要努力学习哦 💪</p>
        </div>
        
        <!-- 成功消息（注册成功后显示） -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-modern alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <!-- 统计卡片 -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card stat-card">
                    <div class="card-body text-center">
                        <i class="bi bi-card-checklist stat-icon text-primary"></i>
                        <h3 class="stat-number text-primary">${dueCount}</h3>
                        <p class="stat-label">今日待复习卡片</p>
                        <c:choose>
                            <c:when test="${dueCount > 0}">
                                <button type="button" class="btn btn-primary btn-modern mt-2" onclick="openReviewModal()">
                                    <i class="bi bi-rocket-takeoff me-2"></i>开始复习
                                </button>
                            </c:when>
                            <c:when test="${not empty decks}">
                                <button type="button" class="btn btn-outline-primary btn-modern mt-2" onclick="openReviewModal()">
                                    <i class="bi bi-book me-2"></i>选择卡组复习
                                </button>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-success mt-3 mb-0">
                                    <i class="bi bi-check-circle me-2"></i>今天已完成所有复习！
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card stat-card">
                    <div class="card-body text-center">
                        <i class="bi bi-collection stat-icon text-success"></i>
                        <h3 class="stat-number text-success">${decks.size()}</h3>
                        <p class="stat-label">我的卡组数量</p>
                        <a href="${pageContext.request.contextPath}/decks" class="btn btn-success btn-modern mt-2">
                            <i class="bi bi-gear me-2"></i>管理卡组
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- 近7天学习统计图表 -->
        <div class="card card-modern">
            <div class="card-header card-header-modern">
                <h5><i class="bi bi-graph-up me-2"></i>近 7 天学习情况</h5>
            </div>
            <div class="card-body">
                <div id="weeklyChart" style="width: 100%; height: 350px;"></div>
            </div>
        </div>

        <!-- 今日待复习卡片列表 -->
        <c:if test="${not empty dueCards}">
            <div class="card card-modern">
                <div class="card-header card-header-modern">
                    <h5><i class="bi bi-clipboard-check me-2"></i>今日待复习卡片 (${dueCount})</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th><i class="bi bi-question-circle me-1"></i>问题</th>
                                    <th><i class="bi bi-bar-chart me-1"></i>阶段</th>
                                    <th><i class="bi bi-arrow-repeat me-1"></i>复习次数</th>
                                    <th><i class="bi bi-percent me-1"></i>正确率</th>
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
                                                <span class="badge badge-modern bg-info">阶段 ${card.stage}</span>
                                            </td>
                                            <td><strong>${card.reviewCount}</strong></td>
                                            <td>
                                                <c:set var="rate" value="${card.reviewCount > 0 ? (card.correctCount * 100.0 / card.reviewCount) : 0}" />
                                                <c:choose>
                                                    <c:when test="${rate >= 80}">
                                                        <span class="badge badge-modern bg-success">${rate}%</span>
                                                    </c:when>
                                                    <c:when test="${rate >= 50}">
                                                        <span class="badge badge-modern bg-warning">${rate}%</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-modern bg-danger">${rate}%</span>
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
                        <p class="text-muted text-center mb-0">
                            <i class="bi bi-three-dots me-1"></i>还有 ${dueCount - 5} 张卡片...
                        </p>
                    </c:if>
                </div>
            </div>
        </c:if>

        <!-- 我的卡组列表 -->
        <div class="card card-modern">
            <div class="card-header card-header-modern">
                <h5><i class="bi bi-collection me-2"></i>我的卡组</h5>
            </div>
            <div class="card-body">
                <c:if test="${empty decks}">
                    <div class="text-center py-5">
                        <i class="bi bi-inbox" style="font-size: 60px; color: #d1d3e2;"></i>
                        <p class="text-muted mt-3">暂无卡组，快去创建一个吧！</p>
                        <a href="${pageContext.request.contextPath}/decks" class="btn btn-primary btn-modern">
                            <i class="bi bi-plus-circle me-2"></i>创建卡组
                        </a>
                    </div>
                </c:if>
                
                <div class="row">
                    <c:forEach var="deck" items="${decks}">
                        <div class="col-md-4 mb-3">
                            <div class="card deck-card h-100">
                                <div class="card-body">
                                    <h6 class="card-title fw-bold mb-2">
                                        <i class="bi bi-folder2-open me-1 text-primary"></i>${deck.deckName}
                                    </h6>
                                    <p class="text-muted small mb-3">
                                        ${deck.description != null && !deck.description.isEmpty() ? deck.description : '暂无描述'}
                                    </p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="badge badge-modern bg-secondary">
                                            <i class="bi bi-tag me-1"></i>${deck.category}
                                        </span>
                                        <span class="text-muted small">
                                            <i class="bi bi-card-list me-1"></i>${deck.cardCount} 张
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- 选择卡组复习的弹窗 Modal -->
    <div class="modal fade" id="selectDeckModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">📚 选择要复习的卡组</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/review/start" id="reviewForm">
                    <div class="modal-body">
                        <div class="alert alert-info">
                            <small>💡 提示：</small>
                            <ul class="small mb-0">
                                <li>选择卡组后，只会复习该卡组中<strong>已到期</strong>的卡片</li>
                                <li>不选择任何卡组，将复习所有卡组中<strong>已到期</strong>的卡片</li>
                                <c:if test="${dueCount > 0}">
                                    <li class="text-primary">当前共有 <strong>${dueCount}</strong> 张到期卡片</li>
                                </c:if>
                                <c:if test="${dueCount == 0}">
                                    <li class="text-success">当前没有到期的卡片 ✅</li>
                                </c:if>
                            </ul>
                        </div>
                        
                        <c:if test="${not empty decks}">
                            <div class="mb-3">
                                <button type="button" class="btn btn-sm btn-outline-primary" onclick="toggleSelectAll()">
                                    全选/反选
                                </button>
                            </div>
                            
                            <div class="row">
                                <c:forEach var="deck" items="${decks}">
                                    <div class="col-md-6 mb-3">
                                        <div class="form-check">
                                            <input class="form-check-input deck-checkbox" type="checkbox" 
                                                   name="deckIds" value="${deck.id}" id="deck_${deck.id}">
                                            <label class="form-check-label" for="deck_${deck.id}">
                                                <strong>${deck.deckName}</strong>
                                                <span class="badge bg-secondary ms-2">${deck.cardCount} 张</span>
                                                <br>
                                                <small class="text-muted">${deck.category}</small>
                                            </label>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                        
                        <c:if test="${empty decks}">
                            <p class="text-muted text-center">暂无卡组</p>
                        </c:if>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">开始复习 🚀</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- ECharts 图表库 -->
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <script>
        let selectDeckModal;
        
        // 初始化 Modal
        document.addEventListener('DOMContentLoaded', function() {
            selectDeckModal = new bootstrap.Modal(document.getElementById('selectDeckModal'));
        });
        
        // 打开选择卡组的 Modal
        function openReviewModal() {
            selectDeckModal.show();
        }
        
        // 全选/反选功能
        function toggleSelectAll() {
            const checkboxes = document.querySelectorAll('.deck-checkbox');
            const allChecked = Array.from(checkboxes).every(cb => cb.checked);
            
            checkboxes.forEach(checkbox => {
                checkbox.checked = !allChecked;
            });
        }

        // 加载近7天学习统计图表
        function loadWeeklyChart() {
            // 初始化 ECharts 实例
            const chartDom = document.getElementById('weeklyChart');
            const myChart = echarts.init(chartDom);
            
            // 显示加载动画
            myChart.showLoading();
            
            // 请求数据
            fetch('${pageContext.request.contextPath}/api/stats/weekly')
                .then(response => response.json())
                .then(data => {
                    myChart.hideLoading();
                    
                    if (!data.success) {
                        console.error('获取数据失败:', data.message);
                        return;
                    }
                    
                    // 配置图表选项
                    const option = {
                        title: {
                            text: '学习趋势分析',
                            left: 'center',
                            textStyle: {
                                fontSize: 16,
                                fontWeight: 'normal'
                            }
                        },
                        tooltip: {
                            trigger: 'axis',
                            axisPointer: {
                                type: 'cross',
                                crossStyle: {
                                    color: '#999'
                                }
                            }
                        },
                        legend: {
                            data: ['复习数量', '正确率'],
                            bottom: 10
                        },
                        grid: {
                            left: '3%',
                            right: '4%',
                            bottom: '15%',
                            containLabel: true
                        },
                        xAxis: [
                            {
                                type: 'category',
                                data: data.dates,
                                axisPointer: {
                                    type: 'shadow'
                                }
                            }
                        ],
                        yAxis: [
                            {
                                type: 'value',
                                name: '复习数量',
                                min: 0,
                                axisLabel: {
                                    formatter: '{value}'
                                }
                            },
                            {
                                type: 'value',
                                name: '正确率 (%)',
                                min: 0,
                                max: 100,
                                axisLabel: {
                                    formatter: '{value}%'
                                }
                            }
                        ],
                        series: [
                            {
                                name: '复习数量',
                                type: 'bar',
                                data: data.reviewCounts,
                                itemStyle: {
                                    color: '#667eea'
                                },
                                barWidth: '40%'
                            },
                            {
                                name: '正确率',
                                type: 'line',
                                yAxisIndex: 1,
                                data: data.correctRates,
                                itemStyle: {
                                    color: '#28a745'
                                },
                                lineStyle: {
                                    width: 3
                                },
                                smooth: true
                            }
                        ]
                    };
                    
                    // 设置图表选项
                    myChart.setOption(option);
                    
                    // 窗口大小改变时自适应
                    window.addEventListener('resize', function() {
                        myChart.resize();
                    });
                })
                .catch(error => {
                    myChart.hideLoading();
                    console.error('请求失败:', error);
                });
        }
        
        // 页面加载完成后加载图表
        document.addEventListener('DOMContentLoaded', function() {
            selectDeckModal = new bootstrap.Modal(document.getElementById('selectDeckModal'));
            loadWeeklyChart();
        });
    </script>
</body>
</html>
