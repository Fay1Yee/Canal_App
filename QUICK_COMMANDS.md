# ⚡ 快速命令参考

## 📱 Flutter 运行命令

### 运行应用到连接的设备
```bash
cd mobile_app && flutter run -d 001521567001406
```

### 热重载 (应用运行时)
```bash
按 'r' 键
```

### 热重启 (应用运行时)
```bash
按 'R' 键
```

### 清理并重新构建
```bash
cd mobile_app
flutter clean
flutter pub get
flutter run -d 001521567001406
```

---

## 🔍 代码检查

### 分析所有代码
```bash
cd mobile_app && flutter analyze
```

### 只检查错误（忽略警告）
```bash
cd mobile_app && flutter analyze 2>&1 | grep "error •"
```

### 检查特定文件
```bash
cd mobile_app && flutter analyze lib/widgets/amap_ink_map_widget.dart
```

---

## 📦 依赖管理

### 获取依赖
```bash
cd mobile_app && flutter pub get
```

### 升级依赖
```bash
cd mobile_app && flutter pub upgrade
```

### 查看过时的包
```bash
cd mobile_app && flutter pub outdated
```

---

## 🛠️ 故障排除

### 检查 Flutter 环境
```bash
flutter doctor -v
```

### 查看连接的设备
```bash
flutter devices
```

### 查看应用日志
```bash
flutter logs
```

### 清理构建缓存
```bash
cd mobile_app
flutter clean
rm -rf build/
flutter pub get
```

---

## 🗺️ 高德地图配置

### 1. 获取 Android SHA1
```bash
cd mobile_app/android
./gradlew signingReport
```

### 2. 编辑配置
```bash
nano lib/config/app_config.dart
```

### 3. 设置 API Keys
```dart
static const String amapApiKeyAndroid = '你的Android Key';
static const String amapApiKeyIOS = '你的iOS Key';
```

---

## 📝 Git 操作

### 查看状态
```bash
git status
```

### 提交更改
```bash
git add .
git commit -m "修复界面错误"
```

### 查看最近的修改
```bash
git log --oneline -5
```

---

## 🔧 常用文件路径

```
配置文件:
  mobile_app/lib/config/app_config.dart

主题文件:
  mobile_app/lib/theme/app_theme.dart

服务文件:
  mobile_app/lib/services/api_service.dart
  mobile_app/lib/services/audio_service.dart

地图组件:
  mobile_app/lib/widgets/amap_ink_map_widget.dart
  mobile_app/lib/widgets/ink_style_components.dart

主屏幕:
  mobile_app/lib/screens/home_screen.dart
  mobile_app/lib/screens/map_screen.dart
```

---

## 🚨 紧急修复

### 应用崩溃时
```bash
# 1. 停止应用
按 'q' 键

# 2. 清理构建
cd mobile_app && flutter clean

# 3. 重新获取依赖
flutter pub get

# 4. 重新运行
flutter run -d 001521567001406
```

### 依赖冲突时
```bash
cd mobile_app
rm pubspec.lock
flutter pub get
```

### Gradle 构建失败时
```bash
cd mobile_app/android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run -d 001521567001406
```

---

## 📖 查看文档

```bash
# 错误修复文档
cat ERROR_FIXES.md

# 修复状态报告
cat FIX_STATUS.md

# 配置指南
cat CONFIGURATION_GUIDE.md

# API 集成指南
cat docs/API_INTEGRATION_GUIDE.md
```

---

## 💡 提示

- 使用 `flutter run` 后，应用会自动支持热重载
- 修改 Dart 代码后按 `r` 即可立即看到效果
- 修改配置文件后需要按 `R` 进行热重启
- 添加新依赖后需要停止应用并重新运行

---

*快速参考 - 2025-10-17*






