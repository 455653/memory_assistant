<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>复习模式 - Memory Assistant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
        }
        .review-container {
            max-width: 800px;
            margin: 0 auto;
        }
        .card-wrapper {
            perspective: 1000px;
            min-height: 400px;
        }
        .flashcard {
            background: white;
            border-radius: 20px;
            padding: 50px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            min-height: 400px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }
        .question {
            font-size: 24px;
            font-weight: 500;
            color: #333;
            margin-bottom: 30px;
        }
        .answer {
            font-size: 18px;
            color: #666;
            line-height: 1.8;
            display: none;
            border-top: 2px solid #e0e0e0;
            padding-top: 30px;
            margin-top: 20px;
        }
        .feedback-buttons {
            display: none;
            margin-top: 30px;
        }
        .btn-feedback {
            font-size: 18px;
            padding: 12px 30px;
            margin: 5px;
            border-radius: 10px;
            min-width: 120px;
        }
        .progress-info {
            color: white;
            text-align: center;
            margin-bottom: 20px;
            font-size: 18px;
        }
        .btn-show-answer {
            font-size: 18px;
            padding: 15px 40px;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="review-container">
        <!-- 进度信息 -->
        <div class="progress-info">
            <h4>📖 复习进度: <span id="currentIndex">${currentIndex}</span> / <span id="totalCount">${totalCount}</span></h4>
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
                    查看答案 👁️
                </button>

                <!-- 答案（背面） -->
                <div class="answer" id="answer">
                    ${card.answer}
                </div>

                <!-- 反馈按钮组 -->
                <div class="feedback-buttons" id="feedbackButtons">
                    <button class="btn btn-danger btn-feedback" onclick="submitFeedback('FORGOT')">
                        ❌ 忘了
                    </button>
                    <button class="btn btn-warning btn-feedback" onclick="submitFeedback('BLURRY')">
                        🟡 模糊
                    </button>
                    <button class="btn btn-success btn-feedback" onclick="submitFeedback('REMEMBER')">
                        ✅ 记得
                    </button>
                </div>
            </div>
        </div>

        <!-- 返回按钮 -->
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-light">
                返回仪表盘
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
            // 淡出当前卡片
            $('#flashcard').fadeOut(300, function() {
                // 更新卡片内容
                currentCardId = card.id;
                currentIndex++;
                
                $('#currentIndex').text(currentIndex);
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
                    <div style="text-align: center;">
                        <h1 style="font-size: 60px;">🎉</h1>
                        <h3 style="color: #28a745; margin-top: 20px;">恭喜完成今日复习！</h3>
                        <p style="color: #666; margin-top: 20px;">坚持就是胜利，明天继续加油！</p>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-lg mt-4">
                            返回仪表盘
                        </a>
                    </div>
                `).fadeIn(500);
            });
        }
    </script>
</body>
</html>
