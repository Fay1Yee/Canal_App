const mongoose = require('mongoose');

const soundscapeSchema = new mongoose.Schema({
  // 基础信息
  title: {
    type: String,
    required: [true, '声景标题不能为空'],
    trim: true,
    maxlength: [100, '标题长度不能超过100个字符']
  },
  
  // 设备信息
  deviceId: {
    type: String,
    required: [true, '设备ID不能为空'],
    index: true
  },
  
  // 音频文件信息
  audioFile: {
    url: {
      type: String,
      required: [true, '音频文件URL不能为空']
    },
    duration: {
      type: Number,
      required: [true, '音频时长不能为空'],
      min: [1, '音频时长必须大于0秒']
    },
    format: {
      type: String,
      enum: ['mp3', 'wav', 'm4a', 'aac'],
      default: 'mp3'
    },
    size: {
      type: Number,
      required: [true, '文件大小不能为空']
    }
  },
  
  // 元数据
  metadata: {
    period: {
      type: String,
      required: [true, '历史时期不能为空'],
      enum: ['先秦', '秦汉', '魏晋', '隋唐', '五代十国', '宋', '元', '明', '清', '近现代', '当代']
    },
    location: {
      name: {
        type: String,
        required: [true, '地点名称不能为空'],
        trim: true
      },
      coordinates: {
        type: {
          type: String,
          enum: ['Point'],
          default: 'Point'
        },
        coordinates: {
          type: [Number],
          required: [true, '坐标信息不能为空'],
          validate: {
            validator: function(coords) {
              return coords.length === 2 && 
                     coords[0] >= -180 && coords[0] <= 180 &&
                     coords[1] >= -90 && coords[1] <= 90;
            },
            message: '坐标格式不正确'
          }
        }
      },
      province: String,
      city: String,
      district: String
    },
    emotion: [{
      type: String,
      trim: true,
      maxlength: [20, '情绪标签长度不能超过20个字符']
    }],
    poem: {
      type: String,
      trim: true,
      maxlength: [500, '收尾诗长度不能超过500个字符']
    },
    tags: [{
      type: String,
      trim: true,
      maxlength: [30, '标签长度不能超过30个字符']
    }]
  },
  
  // 用户信息
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, '用户ID不能为空']
  },
  
  // 状态管理
  status: {
    type: String,
    enum: ['pending', 'approved', 'rejected'],
    default: 'pending'
  },
  
  // 审核信息
  review: {
    reviewedAt: Date,
    reviewedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    reviewComment: String,
    rejectionReason: String
  },
  
  // 统计信息
  stats: {
    playCount: {
      type: Number,
      default: 0
    },
    likeCount: {
      type: Number,
      default: 0
    },
    shareCount: {
      type: Number,
      default: 0
    },
    downloadCount: {
      type: Number,
      default: 0
    }
  },
  
  // 质量评分
  qualityScore: {
    type: Number,
    min: 0,
    max: 10,
    default: 0
  },
  
  // 是否为历史声景
  isHistorical: {
    type: Boolean,
    default: true
  },
  
  // 是否为官方推荐
  isFeatured: {
    type: Boolean,
    default: false
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 地理索引
soundscapeSchema.index({ 'metadata.location.coordinates': '2dsphere' });

// 文本搜索索引
soundscapeSchema.index({
  title: 'text',
  'metadata.location.name': 'text',
  'metadata.emotion': 'text',
  'metadata.tags': 'text'
});

// 复合索引
soundscapeSchema.index({ status: 1, createdAt: -1 });
soundscapeSchema.index({ userId: 1, createdAt: -1 });
soundscapeSchema.index({ 'metadata.period': 1, status: 1 });

// 虚拟字段
soundscapeSchema.virtual('isApproved').get(function() {
  return this.status === 'approved';
});

soundscapeSchema.virtual('isPending').get(function() {
  return this.status === 'pending';
});

soundscapeSchema.virtual('isRejected').get(function() {
  return this.status === 'rejected';
});

// 实例方法
soundscapeSchema.methods.incrementPlayCount = function() {
  this.stats.playCount += 1;
  return this.save();
};

soundscapeSchema.methods.incrementLikeCount = function() {
  this.stats.likeCount += 1;
  return this.save();
};

soundscapeSchema.methods.incrementShareCount = function() {
  this.stats.shareCount += 1;
  return this.save();
};

// 静态方法
soundscapeSchema.statics.findNearby = function(coordinates, maxDistance = 10000) {
  return this.find({
    'metadata.location.coordinates': {
      $near: {
        $geometry: {
          type: 'Point',
          coordinates: coordinates
        },
        $maxDistance: maxDistance
      }
    },
    status: 'approved'
  });
};

soundscapeSchema.statics.findByPeriod = function(period) {
  return this.find({
    'metadata.period': period,
    status: 'approved'
  }).sort({ createdAt: -1 });
};

soundscapeSchema.statics.findByEmotion = function(emotion) {
  return this.find({
    'metadata.emotion': { $in: [emotion] },
    status: 'approved'
  }).sort({ createdAt: -1 });
};

soundscapeSchema.statics.search = function(query) {
  return this.find({
    $text: { $search: query },
    status: 'approved'
  }).sort({ score: { $meta: 'textScore' } });
};

module.exports = mongoose.model('Soundscape', soundscapeSchema);
