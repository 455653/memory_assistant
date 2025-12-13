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
                        <c:choose>
                            <c:when test="${dueCount > 0}">
                                <button type="button" class="btn btn-primary mt-3" onclick="openReviewModal()">
                                    开始复习 🚀
                                </button>
                            </c:when>
                            <c:when test="${not empty decks}">
                                <button type="button" class="btn btn-outline-primary mt-3" onclick="openReviewModal()">
                                    选择卡组复习 📚
                                </button>
                            </c:when>
                            <c:otherwise>
                                <p class="text-success mt-3 mb-0">✅ 今天已完成所有复习！</p>
                            </c:otherwise>
                        </c:choose>
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

        <!-- 近7天学习统计图表 -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white">
                <h5 class="mb-0">📈 近 7 天学习情况</h5>
            </div>
            <div class="card-body">
                <div id="weeklyChart" style="width: 100%; height: 350px;"></div>
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
