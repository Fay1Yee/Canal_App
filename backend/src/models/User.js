const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  // 基础信息
  username: {
    type: String,
    required: [true, '用户名不能为空'],
    unique: true,
    trim: true,
    minlength: [2, '用户名长度不能少于2个字符'],
    maxlength: [20, '用户名长度不能超过20个字符']
  },
  
  email: {
    type: String,
    required: [true, '邮箱不能为空'],
    unique: true,
    lowercase: true,
    trim: true,
    match: [/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/, '邮箱格式不正确']
  },
  
  password: {
    type: String,
    required: [true, '密码不能为空'],
    minlength: [6, '密码长度不能少于6个字符'],
    select: false // 默认查询时不返回密码
  },
  
  // 个人信息
  avatar: {
    type: String,
    default: null
  },
  
  bio: {
    type: String,
    maxlength: [200, '个人简介长度不能超过200个字符'],
    default: ''
  },
  
  // 社交登录信息
  socialAuth: {
    wechat: {
      openid: String,
      unionid: String
    },
    alipay: {
      userid: String
    },
    google: {
      id: String,
      email: String
    }
  },
  
  // 用户等级和积分
  level: {
    type: Number,
    default: 1,
    min: 1,
    max: 100
  },
  
  score: {
    type: Number,
    default: 0,
    min: 0
  },
  
  // 成就系统
  achievements: [{
    id: {
      type: String,
      required: true
    },
    name: {
      type: String,
      required: true
    },
    description: String,
    icon: String,
    unlockedAt: {
      type: Date,
      default: Date.now
    },
    points: {
      type: Number,
      default: 0
    }
  }],
  
  // 收藏的声景
  favorites: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Soundscape'
  }],
  
  // 用户偏好
  preferences: {
    language: {
      type: String,
      enum: ['zh-CN', 'en-US'],
      default: 'zh-CN'
    },
    theme: {
      type: String,
      enum: ['dark', 'light'],
      default: 'dark'
    },
    notifications: {
      email: {
        type: Boolean,
        default: true
      },
      push: {
        type: Boolean,
        default: true
      },
      soundscape: {
        type: Boolean,
        default: true
      }
    }
  },
  
  // 设备信息
  devices: [{
    deviceId: {
      type: String,
      required: true
    },
    deviceName: String,
    lastSeen: {
      type: Date,
      default: Date.now
    },
    isActive: {
      type: Boolean,
      default: true
    }
  }],
  
  // 统计信息
  stats: {
    soundscapesUploaded: {
      type: Number,
      default: 0
    },
    soundscapesApproved: {
      type: Number,
      default: 0
    },
    totalPlayTime: {
      type: Number,
      default: 0
    },
    totalLikes: {
      type: Number,
      default: 0
    },
    totalShares: {
      type: Number,
      default: 0
    }
  },
  
  // 账户状态
  status: {
    type: String,
    enum: ['active', 'suspended', 'banned'],
    default: 'active'
  },
  
  // 最后登录时间
  lastLoginAt: {
    type: Date,
    default: Date.now
  },
  
  // 邮箱验证
  emailVerified: {
    type: Boolean,
    default: false
  },
  
  emailVerificationToken: String,
  emailVerificationExpires: Date,
  
  // 密码重置
  passwordResetToken: String,
  passwordResetExpires: Date
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 索引
userSchema.index({ email: 1 });
userSchema.index({ username: 1 });
userSchema.index({ 'socialAuth.wechat.openid': 1 });
userSchema.index({ 'socialAuth.alipay.userid': 1 });
userSchema.index({ score: -1 });
userSchema.index({ createdAt: -1 });

// 虚拟字段
userSchema.virtual('isActive').get(function() {
  return this.status === 'active';
});

userSchema.virtual('isSuspended').get(function() {
  return this.status === 'suspended';
});

userSchema.virtual('isBanned').get(function() {
  return this.status === 'banned';
});

// 密码加密中间件
userSchema.pre('save', async function(next) {
  // 只有密码被修改时才加密
  if (!this.isModified('password')) return next();
  
  try {
    // 生成盐值
    const salt = await bcrypt.genSalt(12);
    // 加密密码
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

// 实例方法
userSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

userSchema.methods.updateLastLogin = function() {
  this.lastLoginAt = new Date();
  return this.save();
};

userSchema.methods.addAchievement = function(achievement) {
  // 检查是否已有此成就
  const existingAchievement = this.achievements.find(
    a => a.id === achievement.id
  );
  
  if (!existingAchievement) {
    this.achievements.push({
      ...achievement,
      unlockedAt: new Date()
    });
    
    // 更新积分
    this.score += achievement.points || 0;
    
    return this.save();
  }
  
  return Promise.resolve(this);
};

userSchema.methods.addFavorite = function(soundscapeId) {
  if (!this.favorites.includes(soundscapeId)) {
    this.favorites.push(soundscapeId);
    return this.save();
  }
  return Promise.resolve(this);
};

userSchema.methods.removeFavorite = function(soundscapeId) {
  this.favorites = this.favorites.filter(
    id => id.toString() !== soundscapeId.toString()
  );
  return this.save();
};

userSchema.methods.updateStats = function(statType, increment = 1) {
  if (this.stats[statType] !== undefined) {
    this.stats[statType] += increment;
    return this.save();
  }
  return Promise.resolve(this);
};

// 静态方法
userSchema.statics.findByEmail = function(email) {
  return this.findOne({ email: email.toLowerCase() });
};

userSchema.statics.findByUsername = function(username) {
  return this.findOne({ username: { $regex: new RegExp(username, 'i') } });
};

userSchema.statics.findBySocialAuth = function(provider, socialId) {
  const query = {};
  query[`socialAuth.${provider}.${provider === 'wechat' ? 'openid' : 'userid'}`] = socialId;
  return this.findOne(query);
};

userSchema.statics.getLeaderboard = function(limit = 10) {
  return this.find({ status: 'active' })
    .sort({ score: -1 })
    .limit(limit)
    .select('username avatar score level achievements stats');
};

// 成就定义
userSchema.statics.ACHIEVEMENTS = {
  FIRST_UPLOAD: {
    id: 'first_upload',
    name: '初次上传',
    description: '上传第一个声景',
    icon: 'upload',
    points: 10
  },
  HISTORICAL_EXPLORER: {
    id: 'historical_explorer',
    name: '历史探索者',
    description: '上传5个历史声景',
    icon: 'history',
    points: 50
  },
  CULTURAL_GUARDIAN: {
    id: 'cultural_guardian',
    name: '文化守护者',
    description: '获得1000积分',
    icon: 'star',
    points: 100
  },
  COMMUNITY_CONTRIBUTOR: {
    id: 'community_contributor',
    name: '社区贡献者',
    description: '帮助10位用户',
    icon: 'people',
    points: 200
  },
  SOUNDSCAPE_COLLECTOR: {
    id: 'soundscape_collector',
    name: '声景收藏家',
    description: '收藏20个声景',
    icon: 'favorite',
    points: 30
  }
};

module.exports = mongoose.model('User', userSchema);
