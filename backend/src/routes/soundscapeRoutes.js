const express = require('express');
const router = express.Router();
const Soundscape = require('../models/Soundscape');
const { body, validationResult, query } = require('express-validator');

// 获取声景列表
router.get('/', [
  query('page').optional().isInt({ min: 1 }).withMessage('页码必须是正整数'),
  query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('每页数量必须在1-100之间'),
  query('period').optional().isString().withMessage('时期参数必须是字符串'),
  query('emotion').optional().isString().withMessage('情绪参数必须是字符串'),
  query('location').optional().isString().withMessage('地点参数必须是字符串'),
  query('search').optional().isString().withMessage('搜索参数必须是字符串'),
  query('isHistorical').optional().isBoolean().withMessage('历史声景参数必须是布尔值'),
  query('coordinates').optional().isString().withMessage('坐标参数格式错误'),
  query('maxDistance').optional().isInt({ min: 100, max: 50000 }).withMessage('距离参数必须在100-50000米之间')
], async (req, res) => {
  try {
    // 验证输入
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: '参数验证失败',
        details: errors.array()
      });
    }

    const {
      page = 1,
      limit = 20,
      period,
      emotion,
      location,
      search,
      isHistorical,
      coordinates,
      maxDistance = 10000
    } = req.query;

    // 构建查询条件
    let query = { status: 'approved' };

    if (period) {
      query['metadata.period'] = period;
    }

    if (emotion) {
      query['metadata.emotion'] = { $in: [emotion] };
    }

    if (location) {
      query['metadata.location.name'] = { $regex: location, $options: 'i' };
    }

    if (search) {
      query.$text = { $search: search };
    }

    if (isHistorical !== undefined) {
      query.isHistorical = isHistorical === 'true';
    }

    // 地理查询
    if (coordinates) {
      const [lng, lat] = coordinates.split(',').map(Number);
      if (!isNaN(lng) && !isNaN(lat)) {
        query['metadata.location.coordinates'] = {
          $near: {
            $geometry: {
              type: 'Point',
              coordinates: [lng, lat]
            },
            $maxDistance: parseInt(maxDistance)
          }
        };
      }
    }

    // 执行查询
    const soundscapes = await Soundscape.find(query)
      .populate('userId', 'username avatar')
      .sort(coordinates ? {} : { createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(parseInt(limit))
      .lean();

    // 获取总数
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
    console.error('获取声景列表失败:', error);
    res.status(500).json({
      error: '获取声景列表失败',
      message: error.message
    });
  }
});

// 获取单个声景详情
router.get('/:id', async (req, res) => {
  try {
    const soundscape = await Soundscape.findById(req.params.id)
      .populate('userId', 'username avatar')
      .populate('review.reviewedBy', 'username');

    if (!soundscape) {
      return res.status(404).json({
        error: '声景不存在'
      });
    }

    // 增加播放次数
    await soundscape.incrementPlayCount();

    res.json({
      success: true,
      data: soundscape
    });

  } catch (error) {
    console.error('获取声景详情失败:', error);
    res.status(500).json({
      error: '获取声景详情失败',
      message: error.message
    });
  }
});

// 创建新声景
router.post('/', [
  body('title').notEmpty().withMessage('标题不能为空').isLength({ max: 100 }).withMessage('标题长度不能超过100个字符'),
  body('deviceId').notEmpty().withMessage('设备ID不能为空'),
  body('audioFile.url').notEmpty().withMessage('音频文件URL不能为空'),
  body('audioFile.duration').isNumeric().withMessage('音频时长必须是数字').isFloat({ min: 1 }).withMessage('音频时长必须大于0'),
  body('audioFile.format').isIn(['mp3', 'wav', 'm4a', 'aac']).withMessage('音频格式不支持'),
  body('audioFile.size').isNumeric().withMessage('文件大小必须是数字').isFloat({ min: 1 }).withMessage('文件大小必须大于0'),
  body('metadata.period').notEmpty().withMessage('历史时期不能为空'),
  body('metadata.location.name').notEmpty().withMessage('地点名称不能为空'),
  body('metadata.location.coordinates').isArray({ min: 2, max: 2 }).withMessage('坐标必须是包含2个数字的数组'),
  body('metadata.location.coordinates.*').isFloat({ min: -180, max: 180 }).withMessage('坐标值必须在-180到180之间'),
  body('metadata.emotion').optional().isArray().withMessage('情绪标签必须是数组'),
  body('metadata.emotion.*').isString().withMessage('情绪标签必须是字符串'),
  body('metadata.poem').optional().isLength({ max: 500 }).withMessage('收尾诗长度不能超过500个字符'),
  body('metadata.tags').optional().isArray().withMessage('标签必须是数组'),
  body('metadata.tags.*').isString().withMessage('标签必须是字符串'),
  body('isHistorical').optional().isBoolean().withMessage('历史声景参数必须是布尔值')
], async (req, res) => {
  try {
    // 验证输入
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: '参数验证失败',
        details: errors.array()
      });
    }

    // 创建声景
    const soundscape = new Soundscape({
      ...req.body,
      userId: req.user?.id || 'anonymous', // 临时处理，实际应该从认证中间件获取
      status: 'pending'
    });

    await soundscape.save();

    res.status(201).json({
      success: true,
      data: soundscape,
      message: '声景创建成功，等待审核'
    });

  } catch (error) {
    console.error('创建声景失败:', error);
    res.status(500).json({
      error: '创建声景失败',
      message: error.message
    });
  }
});

// 更新声景
router.put('/:id', async (req, res) => {
  try {
    const soundscape = await Soundscape.findById(req.params.id);

    if (!soundscape) {
      return res.status(404).json({
        error: '声景不存在'
      });
    }

    // 检查权限（只有创建者可以修改）
    if (soundscape.userId.toString() !== req.user?.id) {
      return res.status(403).json({
        error: '无权限修改此声景'
      });
    }

    // 只允许修改待审核状态的声景
    if (soundscape.status !== 'pending') {
      return res.status(400).json({
        error: '只有待审核状态的声景可以修改'
      });
    }

    const updatedSoundscape = await Soundscape.findByIdAndUpdate(
      req.params.id,
      { ...req.body, status: 'pending' }, // 修改后重新进入待审核状态
      { new: true, runValidators: true }
    );

    res.json({
      success: true,
      data: updatedSoundscape,
      message: '声景更新成功'
    });

  } catch (error) {
    console.error('更新声景失败:', error);
    res.status(500).json({
      error: '更新声景失败',
      message: error.message
    });
  }
});

// 删除声景
router.delete('/:id', async (req, res) => {
  try {
    const soundscape = await Soundscape.findById(req.params.id);

    if (!soundscape) {
      return res.status(404).json({
        error: '声景不存在'
      });
    }

    // 检查权限
    if (soundscape.userId.toString() !== req.user?.id) {
      return res.status(403).json({
        error: '无权限删除此声景'
      });
    }

    await Soundscape.findByIdAndDelete(req.params.id);

    res.json({
      success: true,
      message: '声景删除成功'
    });

  } catch (error) {
    console.error('删除声景失败:', error);
    res.status(500).json({
      error: '删除声景失败',
      message: error.message
    });
  }
});

// 点赞声景
router.post('/:id/like', async (req, res) => {
  try {
    const soundscape = await Soundscape.findById(req.params.id);

    if (!soundscape) {
      return res.status(404).json({
        error: '声景不存在'
      });
    }

    await soundscape.incrementLikeCount();

    res.json({
      success: true,
      data: { likeCount: soundscape.stats.likeCount },
      message: '点赞成功'
    });

  } catch (error) {
    console.error('点赞失败:', error);
    res.status(500).json({
      error: '点赞失败',
      message: error.message
    });
  }
});

// 分享声景
router.post('/:id/share', async (req, res) => {
  try {
    const soundscape = await Soundscape.findById(req.params.id);

    if (!soundscape) {
      return res.status(404).json({
        error: '声景不存在'
      });
    }

    await soundscape.incrementShareCount();

    res.json({
      success: true,
      data: { shareCount: soundscape.stats.shareCount },
      message: '分享成功'
    });

  } catch (error) {
    console.error('分享失败:', error);
    res.status(500).json({
      error: '分享失败',
      message: error.message
    });
  }
});

module.exports = router;
