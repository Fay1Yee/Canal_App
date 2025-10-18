const express = require('express');
const router = express.Router();
const User = require('../models/User');
const { body, validationResult } = require('express-validator');

// 获取用户信息
router.get('/profile', async (req, res) => {
  try {
    const user = await User.findById(req.user?.id).select('-password');
    
    if (!user) {
      return res.status(404).json({
        error: '用户不存在'
      });
    }

    res.json({
      success: true,
      data: user
    });

  } catch (error) {
    console.error('获取用户信息失败:', error);
    res.status(500).json({
      error: '获取用户信息失败',
      message: error.message
    });
  }
});

// 更新用户信息
router.put('/profile', [
  body('username').optional().isLength({ min: 2, max: 20 }).withMessage('用户名长度必须在2-20个字符之间'),
  body('email').optional().isEmail().withMessage('邮箱格式不正确'),
  body('avatar').optional().isURL().withMessage('头像URL格式不正确'),
  body('bio').optional().isLength({ max: 200 }).withMessage('个人简介长度不能超过200个字符')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: '参数验证失败',
        details: errors.array()
      });
    }

    const user = await User.findByIdAndUpdate(
      req.user.id,
      req.body,
      { new: true, runValidators: true }
    ).select('-password');

    res.json({
      success: true,
      data: user,
      message: '用户信息更新成功'
    });

  } catch (error) {
    console.error('更新用户信息失败:', error);
    res.status(500).json({
      error: '更新用户信息失败',
      message: error.message
    });
  }
});

// 获取用户统计信息
router.get('/stats', async (req, res) => {
  try {
    const userId = req.user.id;
    
    // 获取用户声景统计
    const soundscapeStats = await Soundscape.aggregate([
      { $match: { userId: mongoose.Types.ObjectId(userId) } },
      {
        $group: {
          _id: '$status',
          count: { $sum: 1 }
        }
      }
    ]);

    // 获取用户成就
    const achievements = await User.findById(userId).select('achievements');

    // 计算积分
    const totalScore = await Soundscape.aggregate([
      { $match: { userId: mongoose.Types.ObjectId(userId), status: 'approved' } },
      {
        $group: {
          _id: null,
          totalScore: { $sum: '$qualityScore' }
        }
      }
    ]);

    res.json({
      success: true,
      data: {
        soundscapes: soundscapeStats,
        achievements: achievements?.achievements || [],
        totalScore: totalScore[0]?.totalScore || 0
      }
    });

  } catch (error) {
    console.error('获取用户统计失败:', error);
    res.status(500).json({
      error: '获取用户统计失败',
      message: error.message
    });
  }
});

// 获取用户的声景列表
router.get('/soundscapes', async (req, res) => {
  try {
    const { page = 1, limit = 20, status } = req.query;
    
    let query = { userId: req.user.id };
    if (status) {
      query.status = status;
    }

    const soundscapes = await Soundscape.find(query)
      .sort({ createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(parseInt(limit));

    const total = await Soundscape.countDocuments(query);

    res.json({
      success: true,
      data: {
        soundscapes,
        pagination: {
          current: parseInt(page),
          total: Math.ceil(total / limit),
          count: soundscapes.length,
          totalCount: total
        }
      }
    });

  } catch (error) {
    console.error('获取用户声景列表失败:', error);
    res.status(500).json({
      error: '获取用户声景列表失败',
      message: error.message
    });
  }
});

// 获取用户收藏列表
router.get('/favorites', async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    
    const user = await User.findById(req.user.id).populate({
      path: 'favorites',
      options: {
        sort: { createdAt: -1 },
        skip: (page - 1) * limit,
        limit: parseInt(limit)
      }
    });

    if (!user) {
      return res.status(404).json({
        error: '用户不存在'
      });
    }

    res.json({
      success: true,
      data: {
        favorites: user.favorites,
        pagination: {
          current: parseInt(page),
          total: Math.ceil(user.favorites.length / limit),
          count: user.favorites.length,
          totalCount: user.favorites.length
        }
      }
    });

  } catch (error) {
    console.error('获取收藏列表失败:', error);
    res.status(500).json({
      error: '获取收藏列表失败',
      message: error.message
    });
  }
});

// 添加收藏
router.post('/favorites/:soundscapeId', async (req, res) => {
  try {
    const { soundscapeId } = req.params;
    
    // 检查声景是否存在
    const soundscape = await Soundscape.findById(soundscapeId);
    if (!soundscape) {
      return res.status(404).json({
        error: '声景不存在'
      });
    }

    // 添加到收藏
    await User.findByIdAndUpdate(
      req.user.id,
      { $addToSet: { favorites: soundscapeId } }
    );

    res.json({
      success: true,
      message: '收藏成功'
    });

  } catch (error) {
    console.error('添加收藏失败:', error);
    res.status(500).json({
      error: '添加收藏失败',
      message: error.message
    });
  }
});

// 取消收藏
router.delete('/favorites/:soundscapeId', async (req, res) => {
  try {
    const { soundscapeId } = req.params;
    
    await User.findByIdAndUpdate(
      req.user.id,
      { $pull: { favorites: soundscapeId } }
    );

    res.json({
      success: true,
      message: '取消收藏成功'
    });

  } catch (error) {
    console.error('取消收藏失败:', error);
    res.status(500).json({
      error: '取消收藏失败',
      message: error.message
    });
  }
});

module.exports = router;
