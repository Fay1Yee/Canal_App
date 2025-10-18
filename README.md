# 🌊 京杭大运河声景App (Canal Soundscape App)

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue.svg)](https://flutter.dev/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green.svg)](https://github.com/Fay1Yee/Canal_App)
[![AI Generated](https://img.shields.io/badge/AI-29%20Images-purple.svg)](https://github.com/Fay1Yee/Canal_App)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> 一款融合AI艺术、声景保护与社区互动的沉浸式文化遗产App

[在线预览配图](preview_soundscape_images.html) | [录音指南](REAL_AUDIO_RECORDING_GUIDE.md) | [快速开始](FINAL_README.md)

---

## 📱 项目简介

**京杭大运河声景App**是一款创新的移动应用，通过AI生成的水墨画配图、真实的环境音频和完整的社区互动系统，让用户沉浸式体验千年运河的历史与现代魅力。

### ✨ 核心特色

- 🎨 **29张AI生成配图** - 豆包AI绘制的水墨画与现代摄影
- 🗺️ **24个声景地标** - 从北京通州到杭州的完整运河线路
- 🎵 **音频播放系统** - 沉浸式声景体验
- 💬 **社区讨论功能** - 完整的互动系统（点赞、评论、发帖）
- 🏅 **古风成就系统** - 独特的徽章设计
- 📱 **现代简洁UI** - 4px圆角，流畅动画

---

## 🎯 功能亮点

### 1️⃣ 地图探索
- 24个运河声景标记点
- 高德地图瓦片服务
- 水墨画滤镜效果
- 点击查看详情配图

### 2️⃣ 声景发现
- AI水墨画配图展示
- 历史声景 vs 现代声景
- 精选声景横向轮播
- 诗词文化深度融入

### 3️⃣ 社区互动
- 🟢 实时在线人数
- ❤️ 点赞功能
- 💬 评论弹窗
- ✏️ 发布动态

### 4️⃣ 个人资料
- 水墨画文人头像
- 4个古风徽章
- 用户统计信息

---

## 🎨 AI生成资源

### 图片资源（29张，100%成功）

| 类型 | 数量 | 说明 |
|-----|------|------|
| 声景配图 | 24张 | 水墨画风格（历史）+ 现代摄影（现代） |
| 用户头像 | 1张 | 水墨画文人墨客 |
| 成就徽章 | 4张 | 古风传统纹样 |

**AI模型**: 豆包 SeeDream 4.0  
**分辨率**: 2K/1K  
**总大小**: ~33MB

### 音频资源（24个）
- 格式: MP3
- 时长: 60-120秒
- **建议**: 实地录制真实运河声景 🎤

---

## 🛠️ 技术栈

### 移动端
- **框架**: Flutter 3.9.2
- **语言**: Dart 3.0
- **状态管理**: Provider
- **地图**: flutter_map + 高德瓦片
- **音频**: just_audio

### AI生成
- **图片**: 豆包 SeeDream 4.0
- **配置**: Python + OpenAI SDK

### 其他
- **API**: RESTful后端（Node.js）
- **设计风格**: 水墨画 + 现代简约

---

## 📦 安装与运行

### 前置要求
- Flutter SDK 3.9.2+
- Dart 3.0+
- Android Studio / VS Code
- Android设备 / 模拟器

### 快速开始

```bash
# 1. 克隆项目
git clone https://github.com/Fay1Yee/Canal_App.git
cd Canal_App/mobile_app

# 2. 安装依赖
flutter pub get

# 3. 运行应用
flutter run

# 4. 构建Release版本
flutter build apk --release
```

### 配置

应用已包含所有必需资源，开箱即用。

---

## 📂 项目结构

```
Canal_App/
├── mobile_app/                    # Flutter移动应用
│   ├── lib/
│   │   ├── screens/              # 4个主要页面
│   │   │   ├── home_screen.dart  # 发现页
│   │   │   ├── map_screen.dart   # 地图页
│   │   │   └── profile_screen.dart # 我的页
│   │   ├── models/               # 数据模型
│   │   ├── services/             # 音频/API服务
│   │   ├── theme/                # 主题配置
│   │   └── widgets/              # 可复用组件
│   ├── assets/
│   │   ├── images/               # 29张AI配图
│   │   │   ├── soundscapes/     # 24张声景图
│   │   │   ├── avatars/         # 1张头像
│   │   │   └── badges/          # 4张徽章
│   │   └── audio/                # 24个音频文件
│   │       └── soundscapes/
│   └── pubspec.yaml              # 依赖配置
│
├── backend/                       # Node.js后端（可选）
│   ├── src/
│   │   ├── routes/               # API路由
│   │   └── models/               # 数据模型
│   └── package.json
│
├── scripts/                       # Python工具脚本
│   └── test_doubao_api.py        # AI图片生成脚本
│
├── docs/                          # 文档
│
├── README.md                      # 项目说明（本文件）
├── FINAL_README.md                # 完整总结
└── REAL_AUDIO_RECORDING_GUIDE.md  # 录音指南
```

---

## 🎨 截图展示

### 地图探索
24个运河声景标记点，水墨画滤镜效果

### 发现页面
AI水墨画配图，精选声景轮播

### 社区互动
1247人在线，点赞评论功能

### 个人资料
水墨画头像，古风徽章展示

---

## 🎵 关于音频

### 当前状态
- ✅ 播放功能：100%正常
- ✅ 音频文件：24个已配置
- ⏳ **建议实地录制真实运河声景**

### 为什么要实地录制？

1. **最authentic** - 真实的运河水声、钟声、环境音
2. **文化价值** - 符合声景保护理念
3. **独特性** - 不可替代的真实体验
4. **简单** - 手机录音App即可

### 优先录制（推荐）
- 🌟 扬州二十四桥（月夜）
- 🌟 苏州寒山寺（钟声）
- 🌟 杭州拱宸桥（水声）

详见：[录音指南](REAL_AUDIO_RECORDING_GUIDE.md)

---

## 🚀 开发计划

### ✅ 已完成（v1.0）
- [x] AI生成29张配图
- [x] 24个声景地标
- [x] 地图展示功能
- [x] 音频播放系统
- [x] 社区讨论系统
- [x] 个人资料页面
- [x] UI全局优化
- [x] Android Release版本

### 🔄 进行中
- [ ] 实地录制真实声景
- [ ] 后端API连接
- [ ] 用户登录系统

### 📅 未来规划
- [ ] iOS版本发布
- [ ] AR实景导览
- [ ] 多语言支持
- [ ] 声景上传功能
- [ ] 社交分享

---

## 🤝 贡献指南

欢迎贡献！您可以：

1. **录制声景** - 去运河实地录制真实环境音
2. **报告问题** - 提交Issue
3. **提交代码** - Fork + Pull Request
4. **改进文档** - 完善使用说明

### 声景录制贡献

如果您愿意录制真实的运河声景：

1. 查看 [录音指南](REAL_AUDIO_RECORDING_GUIDE.md)
2. 前往24个声景点之一
3. 使用手机录制90秒环境音
4. 提交PR或联系维护者

**您的贡献将被永久标注在App中！**

---

## 📜 许可证

MIT License

---

## 👤 作者

**Fay1Yee**

- GitHub: [@Fay1Yee](https://github.com/Fay1Yee)
- 项目链接: [https://github.com/Fay1Yee/Canal_App](https://github.com/Fay1Yee/Canal_App)

---

## 🙏 致谢

- **豆包AI** - SeeDream 4.0 图片生成
- **高德地图** - 地图瓦片服务
- **Flutter社区** - 开源框架支持
- **京杭大运河** - 千年文化遗产

---

## 📞 联系方式

- 📧 Email: 通过GitHub Issues联系
- 🌐 GitHub: [https://github.com/Fay1Yee/Canal_App](https://github.com/Fay1Yee/Canal_App)

---

## 🌟 Star History

如果这个项目对您有帮助，请给它一个 ⭐️！

---

**Built with ❤️ for 京杭大运河文化遗产保护**

🌊 声景保护 · 文化传承 · 科技创新 🎨
