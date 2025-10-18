const express = require('express');
const multer = require('multer');
const router = express.Router();
const path = require('path');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');

// 配置 multer 用于文件上传
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadDir = 'uploads/audio';
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueName = `${uuidv4()}${path.extname(file.originalname)}`;
    cb(null, uniqueName);
  }
});

// 文件过滤器
const fileFilter = (req, file, cb) => {
  const allowedTypes = ['audio/mpeg', 'audio/wav', 'audio/mp4', 'audio/aac'];
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error('只支持 MP3、WAV、M4A、AAC 格式的音频文件'), false);
  }
};

const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 50 * 1024 * 1024, // 50MB 限制
    files: 1 // 一次只能上传一个文件
  }
});

// 上传音频文件
router.post('/audio', upload.single('audio'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        error: '请选择要上传的音频文件'
      });
    }

    // 获取文件信息
    const fileInfo = {
      originalName: req.file.originalname,
      filename: req.file.filename,
      path: req.file.path,
      size: req.file.size,
      mimetype: req.file.mimetype,
      url: `/uploads/audio/${req.file.filename}`
    };

    // TODO: 这里应该将文件上传到阿里云 OSS
    // 暂时返回本地文件信息
    res.json({
      success: true,
      data: fileInfo,
      message: '音频文件上传成功'
    });

  } catch (error) {
    console.error('音频上传失败:', error);
    
    // 删除已上传的文件
    if (req.file) {
      fs.unlinkSync(req.file.path);
    }

    res.status(500).json({
      error: '音频上传失败',
      message: error.message
    });
  }
});

// 获取上传进度（WebSocket 实现）
router.get('/progress/:uploadId', (req, res) => {
  // TODO: 实现上传进度查询
  res.json({
    success: true,
    data: {
      uploadId: req.params.uploadId,
      progress: 0,
      status: 'uploading'
    }
  });
});

// 删除上传的文件
router.delete('/audio/:filename', (req, res) => {
  try {
    const filename = req.params.filename;
    const filePath = path.join('uploads/audio', filename);
    
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
      res.json({
        success: true,
        message: '文件删除成功'
      });
    } else {
      res.status(404).json({
        error: '文件不存在'
      });
    }

  } catch (error) {
    console.error('删除文件失败:', error);
    res.status(500).json({
      error: '删除文件失败',
      message: error.message
    });
  }
});

// 获取文件信息
router.get('/audio/:filename', (req, res) => {
  try {
    const filename = req.params.filename;
    const filePath = path.join('uploads/audio', filename);
    
    if (fs.existsSync(filePath)) {
      const stats = fs.statSync(filePath);
      res.json({
        success: true,
        data: {
          filename,
          size: stats.size,
          created: stats.birthtime,
          modified: stats.mtime
        }
      });
    } else {
      res.status(404).json({
        error: '文件不存在'
      });
    }

  } catch (error) {
    console.error('获取文件信息失败:', error);
    res.status(500).json({
      error: '获取文件信息失败',
      message: error.message
    });
  }
});

// 错误处理中间件
router.use((error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        error: '文件大小超过限制',
        message: '音频文件大小不能超过 50MB'
      });
    }
    if (error.code === 'LIMIT_FILE_COUNT') {
      return res.status(400).json({
        error: '文件数量超过限制',
        message: '一次只能上传一个文件'
      });
    }
  }
  
  res.status(500).json({
    error: '上传处理失败',
    message: error.message
  });
});

module.exports = router;
