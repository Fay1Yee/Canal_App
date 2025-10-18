module.exports = {
  // 数据库配置
  mongodb: {
    uri: process.env.MONGODB_URI || 'mongodb://localhost:27017/waterscapes',
    options: {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  },

  // 服务器配置
  server: {
    port: process.env.PORT || 3000,
    host: process.env.HOST || '0.0.0.0',
    env: process.env.NODE_ENV || 'development'
  },

  // JWT 配置
  jwt: {
    secret: process.env.JWT_SECRET || 'your_jwt_secret_key_here',
    expiresIn: process.env.JWT_EXPIRE || '7d'
  },

  // 阿里云 OSS 配置
  aliyunOSS: {
    region: process.env.ALIYUN_OSS_REGION || 'oss-cn-hangzhou',
    accessKeyId: process.env.ALIYUN_OSS_ACCESS_KEY_ID,
    accessKeySecret: process.env.ALIYUN_OSS_ACCESS_KEY_SECRET,
    bucket: process.env.ALIYUN_OSS_BUCKET || 'waterscapes-audio'
  },

  // 微信登录配置
  wechat: {
    appId: process.env.WECHAT_APP_ID,
    appSecret: process.env.WECHAT_APP_SECRET
  },

  // 支付宝登录配置
  alipay: {
    appId: process.env.ALIPAY_APP_ID,
    privateKey: process.env.ALIPAY_PRIVATE_KEY,
    publicKey: process.env.ALIPAY_PUBLIC_KEY
  },

  // 邮件配置
  email: {
    host: process.env.SMTP_HOST || 'smtp.gmail.com',
    port: process.env.SMTP_PORT || 587,
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS
  },

  // 内容审核配置
  contentModeration: {
    apiKey: process.env.CONTENT_MODERATION_API_KEY,
    apiUrl: process.env.CONTENT_MODERATION_API_URL
  },

  // 地图服务配置
  mapbox: {
    accessToken: process.env.MAPBOX_ACCESS_TOKEN
  },

  // 文件上传配置
  upload: {
    maxFileSize: 50 * 1024 * 1024, // 50MB
    allowedAudioTypes: ['audio/mpeg', 'audio/wav', 'audio/mp4', 'audio/aac'],
    uploadPath: 'uploads/audio'
  },

  // 缓存配置
  redis: {
    host: process.env.REDIS_HOST || 'localhost',
    port: process.env.REDIS_PORT || 6379,
    password: process.env.REDIS_PASSWORD
  }
};
