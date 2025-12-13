<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>复习模式 - Memory Assistant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Noto+Sans+SC:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Inter', 'Noto Sans SC', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #4e73df 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .review-container {
            max-width: 900px;
            width: 100%;
        }
        
        /* 进度条 */
        .progress-wrapper {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 20px 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        
        .progress-info {
            color: white;
            text-align: center;
            margin-bottom: 15px;
        }
        
        .progress-info h4 {
            font-weight: 600;
            font-size: 1.3rem;
            margin: 0;
        }
        
        .progress {
            height: 12px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.3);
            overflow: hidden;
        }
        
        .progress-bar {
            background: linear-gradient(90deg, #28a745, #20c997);
            transition: width 0.6s ease;
        }
        
        /* 卡片容器 - 纸质质感 */
        .card-wrapper {
            perspective: 1500px;
            min-height: 500px;
        }
        
        .flashcard {
            background: #ffffff;
            border-radius: 25px;
            padding: 60px;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.3),
                0 0 0 1px rgba(255, 255, 255, 0.1);
            min-height: 500px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: relative;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .flashcard::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                repeating-linear-gradient(
                    0deg,
                    rgba(0, 0, 0, 0.03) 0px,
                    rgba(0, 0, 0, 0.03) 1px,
                    transparent 1px,
                    transparent 30px
                );
            border-radius: 25px;
            pointer-events: none;
        }
        
        /* 问题样式 */
        .question {
            font-size: 2rem;
            font-weight: 600;
            color: #2e59d9;
            margin-bottom: 40px;
            line-height: 1.5;
            position: relative;
            z-index: 1;
        }
        
        .question::before {
            content: '\f128';
            font-family: 'bootstrap-icons';
            display: block;
            font-size: 3rem;
            color: #4e73df;
            opacity: 0.3;
            margin-bottom: 20px;
        }
        
        /* 答案样式 */
        .answer {
            font-size: 1.3rem;
            color: #5a5c69;
            line-height: 1.9;
            display: none;
            border-top: 3px solid #e3e6f0;
            padding-top: 40px;
            margin-top: 30px;
            position: relative;
            z-index: 1;
        }
        
        .answer::before {
            content: '\f272';
            font-family: 'bootstrap-icons';
            display: block;
            font-size: 2.5rem;
            color: #28a745;
            opacity: 0.3;
            margin-bottom: 15px;
        }
        
        /* 查看答案按钮 */
        .btn-show-answer {
            font-size: 1.2rem;
            padding: 18px 50px;
            border-radius: 15px;
            background: linear-gradient(135deg, #4e73df 0%, #764ba2 100%);
            border: none;
            box-shadow: 0 8px 20px rgba(78, 115, 223, 0.4);
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            z-index: 1;
        }
        
        .btn-show-answer:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(78, 115, 223, 0.5);
            background: linear-gradient(135deg, #5a7ee6 0%, #8257ad 100%);
        }
        
        /* 反馈按钮组 */
        .feedback-buttons {
            display: none;
            margin-top: 40px;
            gap: 15px;
            position: relative;
            z-index: 1;
        }
        
        .btn-feedback {
            font-size: 1.1rem;
            padding: 18px 35px;
            border-radius: 15px;
            min-width: 140px;
            font-weight: 600;
            border: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        
        .btn-feedback:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
        }
        
        .btn-feedback.btn-danger {
            background: linear-gradient(135deg, #e74a3b, #dc3545);
        }
        
        .btn-feedback.btn-warning {
            background: linear-gradient(135deg, #f6c23e, #ffc107);
            color: #fff;
        }
        
        .btn-feedback.btn-success {
            background: linear-gradient(135deg, #1cc88a, #28a745);
        }
        
        /* 返回按钮 */
        .btn-back {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border: 2px solid rgba(255, 255, 255, 0.4);
            color: white;
            padding: 12px 30px;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-back:hover {
            background: rgba(255, 255, 255, 0.3);
            border-color: rgba(255, 255, 255, 0.6);
            color: white;
            transform: translateY(-2px);
        }
        
        /* 动画效果 */
        @keyframes cardFlip {
            0% {
                transform: rotateY(0deg);
            }
            50% {
                transform: rotateY(90deg);
            }
            100% {
                transform: rotateY(0deg);
            }
        }
        
        .card-flip-animation {
            animation: cardFlip 0.6s ease;
        }
    </style>
</head>
<body>
    <div class="review-container">
        <!-- 进度信息 -->
        <div class="progress-wrapper">
            <div class="progress-info">
                <h4>
                    <i class="bi bi-journal-text me-2"></i>
                    复习进度: <span id="currentIndex">${currentIndex}</span> / <span id="totalCount">${totalCount}</span>
                </h4>
            </div>
            <div class="progress">
                <div class="progress-bar" role="progressbar" 
                     style="width: ${(currentIndex * 100.0 / totalCount)}%" 
                     aria-valuenow="${currentIndex}" 
                     aria-valuemin="0" 
                     aria-valuemax="${totalCount}">
                </div>
            </div>
        </div>

        <!-- 卡片容器 -->
        <div class="card-wrapper">
            <div class="flashcard" id="flashcard">
                <!-- 问题（正面） -->
                <div class="question" id="question">
                    ${card.question}
                </div>

                <!-- 查看答案按钮 -->
                <button class="btn btn-primary btn-show-answer" id="showAnswerBtn" onclick="showAnswer()">
                    <i class="bi bi-eye me-2"></i>查看答案
                </button>

                <!-- 答案（背面） -->
                <div class="answer" id="answer">
                    ${card.answer}
                </div>

                <!-- 反馈按钮组 -->
                <div class="feedback-buttons d-flex" id="feedbackButtons">
                    <button class="btn btn-danger btn-feedback" onclick="submitFeedback('FORGOT')">
                        <i class="bi bi-x-circle me-2"></i>忘了
                    </button>
                    <button class="btn btn-warning btn-feedback" onclick="submitFeedback('BLURRY')">
                        <i class="bi bi-question-circle me-2"></i>模糊
                    </button>
                    <button class="btn btn-success btn-feedback" onclick="submitFeedback('REMEMBER')">
                        <i class="bi bi-check-circle me-2"></i>记得
                    </button>
                </div>
            </div>
        </div>

        <!-- 返回按钮 -->
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-back">
                <i class="bi bi-arrow-left me-2"></i>返回仪表盘
            </a>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let currentCardId = ${card.id};
        let totalCount = ${totalCount};
        let currentIndex = ${currentIndex};

        // 显示答案
        function showAnswer() {
            $('#answer').fadeIn(500);
            $('#showAnswerBtn').fadeOut(300);
            $('#feedbackButtons').fadeIn(500);
        }

        // 提交复习反馈
        function submitFeedback(feedback) {
            // 禁用按钮防止重复点击
            $('#feedbackButtons button').prop('disabled', true);

            $.ajax({
                url: '${pageContext.request.contextPath}/api/cards/' + currentCardId + '/review',
                type: 'POST',
                data: { feedback: feedback },
                success: function(response) {
                    if (response.success) {
                        if (response.remainingCount > 0 && response.nextCard) {
                            // 还有卡片，加载下一张
                            loadNextCard(response.nextCard);
                        } else {
                            // 复习完成
                            showCompletionMessage();
                        }
                    } else {
                        alert('提交失败: ' + response.message);
                        $('#feedbackButtons button').prop('disabled', false);
                    }
                },
                error: function() {
                    alert('网络错误，请重试');
                    $('#feedbackButtons button').prop('disabled', false);
                }
            });
        }

        // 加载下一张卡片
        function loadNextCard(card) {
            // 添加翻转动画
            $('#flashcard').addClass('card-flip-animation');
            
            // 淡出当前卡片
            $('#flashcard').fadeOut(300, function() {
                // 移除动画类
                $(this).removeClass('card-flip-animation');
                
                // 更新卡片内容
                currentCardId = card.id;
                currentIndex++;
                
                // 更新进度
                $('#currentIndex').text(currentIndex);
                let progressPercent = (currentIndex * 100.0 / totalCount);
                $('.progress-bar').css('width', progressPercent + '%');
                
                $('#question').text(card.question);
                $('#answer').text(card.answer).hide();
                $('#showAnswerBtn').show();
                $('#feedbackButtons').hide();
                $('#feedbackButtons button').prop('disabled', false);

                // 淡入新卡片
                $('#flashcard').fadeIn(500);
            });
        }

        // 显示完成消息
        function showCompletionMessage() {
            $('#flashcard').fadeOut(300, function() {
                $(this).html(`
                    <div style="text-align: center; padding: 40px;">
                        <i class="bi bi-trophy" style="font-size: 100px; color: #f6c23e; margin-bottom: 20px;"></i>
                        <h2 style="color: #28a745; margin-top: 20px; font-weight: 700;">恭喜完成今日复习！</h2>
                        <p style="color: #858796; margin-top: 20px; font-size: 1.1rem;">坚持就是胜利，明天继续加油！</p>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-modern mt-4" style="padding: 15px 40px; font-size: 1.1rem;">
                            <i class="bi bi-house me-2"></i>返回仪表盘
                        </a>
                    </div>
                `).fadeIn(500);
            });
        }
    </script>
</body>
</html>
