<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI智能制卡 - Memory Assistant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 50px 0;
        }
        .upload-container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        .upload-area {
            border: 3px dashed #667eea;
            border-radius: 15px;
            padding: 60px 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            background: #f8f9fa;
        }
        .upload-area:hover {
            border-color: #764ba2;
            background: #e9ecef;
        }
        .upload-icon {
            font-size: 4rem;
            color: #667eea;
            margin-bottom: 20px;
        }
        .file-input {
            display: none;
        }
        .submit-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 40px;
            font-weight: bold;
        }
        .feature-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="upload-container">
            <!-- 标题 -->
            <div class="text-center mb-4">
                <h2 class="fw-bold">🤖 AI智能制卡</h2>
                <p class="text-muted">上传文档，让AI帮你自动生成学习卡片</p>
            </div>

            <!-- 消息提示 -->
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

            <!-- 上传表单 -->
            <form action="${pageContext.request.contextPath}/deck/ai/preview" method="post" 
                  enctype="multipart/form-data" id="uploadForm">
                
                <!-- 文件上传区域 -->
                <div class="upload-area" id="uploadArea" onclick="document.getElementById('fileInput').click()">
                    <i class="bi bi-cloud-upload upload-icon"></i>
                    <h5>点击选择文件</h5>
                    <p class="text-muted mb-0">支持 PDF、Word (.docx) 格式</p>
                    <p class="text-muted small">文件大小不超过 10MB</p>
                </div>
                
                <input type="file" 
                       class="file-input" 
                       id="fileInput" 
                       name="file" 
                       accept=".pdf,.docx"
                       required
                       onchange="handleFileSelect(this)">

                <!-- 文件信息显示 -->
                <div id="fileInfo" class="mt-3" style="display: none;">
                    <div class="alert alert-info">
                        <i class="bi bi-file-earmark-text"></i>
                        已选择: <strong id="fileName"></strong>
                        (<span id="fileSize"></span>)
                    </div>
                </div>

                <!-- 卡组名称（可选） -->
                <div class="mb-3 mt-4">
                    <label for="deckName" class="form-label">卡组名称（可选）</label>
                    <input type="text" 
                           class="form-control" 
                           id="deckName" 
                           name="deckName" 
                           placeholder="留空则自动使用文件名">
                </div>

                <!-- 提交按钮 -->
                <button type="submit" class="btn btn-primary submit-btn w-100 mt-3" id="submitBtn">
                    <i class="bi bi-magic"></i> 开始AI分析
                </button>
            </form>

            <!-- 功能说明 -->
            <div class="mt-4">
                <h6 class="fw-bold mb-3">✨ 功能特点</h6>
                <div class="feature-item">
                    <i class="bi bi-check-circle text-success"></i>
                    自动提取文档关键知识点
                </div>
                <div class="feature-item">
                    <i class="bi bi-check-circle text-success"></i>
                    智能生成问答对，节省时间
                </div>
                <div class="feature-item">
                    <i class="bi bi-check-circle text-success"></i>
                    可预览并选择需要的卡片
                </div>
            </div>

            <!-- 返回按钮 -->
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/decks" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> 返回卡组列表
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function handleFileSelect(input) {
            const file = input.files[0];
            if (file) {
                // 显示文件信息
                document.getElementById('fileName').textContent = file.name;
                document.getElementById('fileSize').textContent = formatFileSize(file.size);
                document.getElementById('fileInfo').style.display = 'block';
                
                // 自动填充卡组名称
                if (!document.getElementById('deckName').value) {
                    const nameWithoutExt = file.name.substring(0, file.name.lastIndexOf('.'));
                    document.getElementById('deckName').value = nameWithoutExt;
                }
            }
        }

        function formatFileSize(bytes) {
            if (bytes < 1024) return bytes + ' B';
            if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(2) + ' KB';
            return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
        }

        // 表单提交时显示加载提示
        document.getElementById('uploadForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>AI正在分析中，请稍候...';
        });
    </script>
</body>
</html>
