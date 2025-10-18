# 🚀 水上书 - 快速参考

## 📁 核心文件位置

### 服务层
```
mobile_app/lib/services/
├── api_service.dart          # API 服务（后端连接）
└── audio_service.dart        # 音频服务（播放+录制）
```

### 配置
```
mobile_app/lib/config/
└── app_config.dart           # 统一配置中心
```

### 组件
```
mobile_app/lib/widgets/
├── google_ink_map_widget.dart    # Google 地图组件
├── ink_style_components.dart     # UI 组件库
└── ink_painting_background.dart  # 水墨背景
```

---

## 🔧 快速配置

### 1. 后端 API（必须）
**文件**: `mobile_app/lib/config/app_config.dart`
```dart
static const String apiBaseUrl = 'https://your-api.com/api';
```

### 2. Google Maps（必须）

**Android**: `mobile_app/android/app/src/main/AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_KEY"/>
```

**iOS**: `mobile_app/ios/Runner/AppDelegate.swift`
```swift
GMSServices.provideAPIKey("YOUR_KEY")
```

---

## 💻 常用代码片段

### API 调用
```dart
final api = ApiService();

// 获取声景
final list = await api.getSoundscapes(period: '唐代');

// 上传
await api.uploadSoundscape(
  audioPath: path,
  title: '标题',
  period: '唐代',
  location: '扬州',
  emotions: ['宁静'],
);

// 收藏
await api.favoriteSoundscape(id);
```

### 音频播放
```dart
final player = AudioPlayerService();

// 播放
await player.play(url, soundscapeId: id);

// 控制
await player.pause();
await player.resume();
await player.seek(Duration(seconds: 30));

// 监听
player.onPlayingChanged = (playing) {};
player.onPositionChanged = (pos) {};
```

### 地图使用
```dart
GoogleInkMapWidget(
  markers: [
    SoundscapeMarker(
      id: '1',
      title: '声景名',
      period: '唐代',
      emotion: '宁静',
      latitude: 30.27,
      longitude: 120.15,
    ),
  ],
)
```

---

## 🔑 API 端点

```
POST   /api/auth/login
GET    /api/soundscapes
GET    /api/soundscapes/:id
POST   /api/soundscapes
POST   /api/soundscapes/:id/favorite
DELETE /api/soundscapes/:id/favorite
GET    /api/user/favorites
GET    /api/user/profile
GET    /api/user/stats
```

---

## 📦 命令速查

```bash
# 安装依赖
flutter pub get

# 清理构建
flutter clean

# 代码检查
flutter analyze

# 运行应用
flutter run -d <device_id>

# 查看设备
flutter devices

# 构建 APK
flutter build apk --release

# 构建 iOS
flutter build ios --release
```

---

## 🐛 常见问题

**Q: API 请求超时？**  
A: 检查 `app_config.dart` 中的 `apiBaseUrl` 和网络连接。

**Q: 音频无法播放？**  
A: 确保 URL 有效，格式支持（mp3/aac/m4a/wav）。

**Q: 地图不显示？**  
A: 检查 API Key 配置和 Google Cloud Console 设置。

**Q: 构建错误？**  
A: 运行 `flutter clean && flutter pub get`。

---

## 📖 完整文档

- `docs/API_INTEGRATION_GUIDE.md` - 完整集成指南 ⭐
- `INTEGRATION_SUMMARY.md` - 集成总结
- `docs/FEATURES_COMPLETE.md` - 功能清单
- `README.md` - 项目概览

---

**快速开始**: 配置 API → 配置地图 → `flutter run`

**需要帮助**: 查看 `docs/API_INTEGRATION_GUIDE.md`

