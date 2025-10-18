# 水上书 (Water Scapes) - 声景文化传承平台

> 融合 Nothing OS 极简美学与水墨风格的文化声景汇聚中心

## 📖 项目简介

水上书是一个创新的文化声景平台，作为《行舟墨仪》设备的在线延伸和数据汇聚中心。平台融合了 Nothing OS 的极简设计理念与中国传统水墨美学，为用户提供沉浸式的历史文化声景体验。

### 🎯 核心价值

- **文化传承**: 汇聚历史声景，传承中华文化
- **技术创新**: 结合 AI 与传统文化，创造全新体验
- **社区共建**: 用户参与，共同构建声景数据库
- **美学融合**: Nothing OS 极简风格 + 水墨艺术

## 🏗️ 技术架构

### 前端技术栈
- **框架**: Flutter (跨平台移动应用)
- **设计系统**: Nothing OS 极简美学 + 水墨风格
- **地图服务**: Mapbox (支持中国地图定制)
- **状态管理**: Provider/Riverpod
- **网络请求**: Dio

### 后端技术栈
- **运行时**: Node.js
- **框架**: Express.js
- **数据库**: MongoDB (灵活存储声景数据)
- **云存储**: 阿里云 OSS (音频文件存储)
- **认证**: JWT + 微信/支付宝登录

### 部署架构
- **前端**: Flutter 构建 iOS/Android 应用
- **后端**: 阿里云 ECS + MongoDB + OSS
- **CDN**: 阿里云 CDN 加速音频文件分发

## 🚀 快速开始

### 环境要求
- Flutter SDK >= 3.0.0
- Node.js >= 18.0.0
- MongoDB >= 5.0.0

### 前端开发

```bash
# 进入移动应用目录
cd mobile_app

# 安装依赖
flutter pub get

# 运行应用
flutter run
```

### 后端开发

```bash
# 进入后端目录
cd backend

# 安装依赖
npm install

# 复制配置文件
cp config.example.js config.js

# 启动开发服务器
npm run dev
```

## 📱 功能特性

### 核心功能

#### 1. 地图可视化
- **历史声景**: 水墨风格墨点标记，展示不同历史时期的声景
- **当代实录**: 简洁音频符号，显示用户上传的现代环境音
- **交互体验**: 点击播放、缩放拖拽、筛选搜索

#### 2. 声景管理
- **上传录制**: 支持多种音频格式上传
- **内容审核**: AI 驱动的智能内容审核系统
- **标签分类**: 时期、地点、情绪、标签多维分类

#### 3. 用户系统
- **社交登录**: 微信、支付宝一键登录
- **成就系统**: 积分徽章，激励用户贡献
- **个人中心**: 我的声景、收藏、统计信息

#### 4. 激励机制
- **积分系统**: 基于贡献质量的积分奖励
- **成就徽章**: "文化遗产贡献者"等虚拟奖励
- **社区互动**: 点赞、分享、评论功能

### 设计特色

#### Nothing OS 极简美学
- **纯黑背景**: 深邃的黑色主题 (#000000, #0A0A0A)
- **极简交互**: 减少视觉干扰，专注内容
- **流畅动画**: 细腻的过渡效果 (60fps)
- **现代字体**: 简洁清晰的文字排版
- **几何网格**: 精确的网格系统与对角辅助线

#### 水墨风格元素
- **墨点标记**: 动态水墨效果的地图标记
- **多层晕染**: 4-5层径向渐变模拟真实墨迹扩散
- **渐变色彩**: 从墨黑到淡灰的层次渐变
- **纸质质感**: 模拟宣纸的纹理效果
- **古典配色**: 传统中国色彩搭配
- **诗词排版**: 1.8倍行高的优雅文字呈现

#### 数据可视化
- **圆形图表**: Nothing OS 风格的圆环进度显示
- **参数标注**: 技术图纸般的精确标注系统
- **信息层次**: 清晰的数据呈现与视觉引导
- **动态效果**: 流畅的数据动画反馈

## 🗂️ 项目结构

```
canal_app/
├── mobile_app/                 # Flutter 移动应用
│   ├── lib/
│   │   ├── screens/           # 页面组件
│   │   │   ├── home_screen.dart
│   │   │   ├── map_screen.dart
│   │   │   └── profile_screen.dart
│   │   ├── widgets/           # 可复用组件
│   │   │   ├── ink_style_components.dart
│   │   │   └── ink_painting_background.dart  # 🆕 水墨背景组件
│   │   ├── theme/             # 主题配置
│   │   │   └── app_theme.dart
│   │   ├── services/          # API 服务
│   │   ├── models/            # 数据模型
│   │   └── utils/             # 工具类
│   └── assets/                # 资源文件
├── backend/                   # Node.js 后端
│   ├── src/
│   │   ├── controllers/       # 控制器
│   │   ├── models/           # 数据模型
│   │   │   ├── Soundscape.js
│   │   │   └── User.js
│   │   ├── routes/           # 路由
│   │   │   ├── soundscapeRoutes.js
│   │   │   ├── userRoutes.js
│   │   │   └── uploadRoutes.js
│   │   ├── middleware/       # 中间件
│   │   ├── services/         # 业务逻辑
│   │   └── config/           # 配置文件
│   ├── package.json
│   └── config.example.js
└── docs/                     # 项目文档
```

## 🎨 设计系统

### 色彩规范

```dart
// Nothing OS 极简色彩
primaryBlack: #000000
secondaryBlack: #1A1A1A
accentWhite: #FFFFFF
subtleGray: #2A2A2A
lightGray: #404040

// 水墨风格色彩
inkBlack: #1B1B1B
inkGray: #4A4A4A
inkLight: #8A8A8A
paperWhite: #F8F8F8
paperCream: #F5F5F0
```

### 组件库

- **InkDot**: 水墨风格地图标记
- **InkCard**: 水墨风格卡片容器
- **InkButton**: 水墨风格按钮
- **InkTextField**: 水墨风格输入框
- **InkTag**: 水墨风格标签

## 🔧 API 接口

### 声景相关
- `GET /api/soundscapes` - 获取声景列表
- `GET /api/soundscapes/:id` - 获取声景详情
- `POST /api/soundscapes` - 创建新声景
- `PUT /api/soundscapes/:id` - 更新声景
- `DELETE /api/soundscapes/:id` - 删除声景

### 用户相关
- `GET /api/users/profile` - 获取用户信息
- `PUT /api/users/profile` - 更新用户信息
- `GET /api/users/stats` - 获取用户统计
- `GET /api/users/soundscapes` - 获取用户声景

### 文件上传
- `POST /api/upload/audio` - 上传音频文件
- `GET /api/upload/progress/:id` - 获取上传进度
- `DELETE /api/upload/audio/:filename` - 删除文件

## 🚀 部署指南

### 前端部署
```bash
# 构建 Android APK
flutter build apk --release

# 构建 iOS IPA
flutter build ios --release
```

### 后端部署
```bash
# 安装 PM2
npm install -g pm2

# 启动应用
pm2 start src/app.js --name waterscapes-api

# 设置开机自启
pm2 startup
pm2 save
```

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 联系我们

- 项目主页: [GitHub Repository]
- 问题反馈: [GitHub Issues]
- 邮箱: contact@waterscapes.app

---

**水上书** - 让文化在声音中传承，让历史在墨香中重现 ✨
