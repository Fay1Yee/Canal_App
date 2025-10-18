# 🔧 水上书 - 配置指南

## ⚠️ 重要提示

**不要在终端直接输入 Dart 代码！** 

❌ 错误做法：
```bash
static const String apiBaseUrl = 'https://your-api.com/api';
```

✅ 正确做法：**编辑文件**

---

## 📝 配置步骤

### 1. 配置后端 API 地址

**文件位置**: `mobile_app/lib/config/app_config.dart`

**如何修改**:
1. 打开文件 `mobile_app/lib/config/app_config.dart`
2. 找到第 9 行
3. 修改 `apiBaseUrl` 的值

```dart
// 本地开发
static const String apiBaseUrl = 'http://localhost:3000/api';

// 或者生产环境
static const String apiBaseUrl = 'https://your-backend-api.com/api';
```

**常用配置**:
- 本地后端: `http://localhost:3000/api`
- 本地网络: `http://192.168.1.x:3000/api`
- 生产环境: `https://api.waterscapes.app/api`

---

### 2. 配置高德地图 API Key（推荐，中国本地化更好）

#### 步骤 1: 获取 API Key

1. 访问 [高德开放平台](https://lbs.amap.com/)
2. 注册并登录账号
3. 进入「控制台」→「应用管理」→「我的应用」
4. 点击「创建新应用」
5. 添加 Key:
   - **Android Key**: 选择「Android 平台」，填写 SHA1 和包名
   - **iOS Key**: 选择「iOS 平台」，填写 Bundle ID

**获取 Android SHA1**:
```bash
cd mobile_app/android
./gradlew signingReport
# 在输出中找到 SHA1 值
```

**包名**: `com.canal.waterscapes.mobile_app`

#### 步骤 2: 配置 Android

**文件**: `mobile_app/android/app/src/main/AndroidManifest.xml`

在 `<application>` 标签内添加：

```xml
<application>
    <!-- 其他配置... -->
    
    <!-- 高德地图 API Key -->
    <meta-data
        android:name="com.amap.api.v2.apikey"
        android:value="YOUR_AMAP_ANDROID_KEY"/>
</application>
```

在 `<manifest>` 标签内添加权限（如果还没有）：

```xml
<manifest>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    
    <application>
        ...
    </application>
</manifest>
```

#### 步骤 3: 配置 iOS

**文件**: `mobile_app/ios/Runner/Info.plist`

在 `<dict>` 标签内添加：

```xml
<dict>
    <!-- 高德地图 API Key -->
    <key>AMapApiKey</key>
    <string>YOUR_AMAP_IOS_KEY</string>
    
    <!-- 位置权限描述 -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>需要访问您的位置以显示附近的声景</string>
    
    <key>NSLocationAlwaysUsageDescription</key>
    <string>需要访问您的位置以提供更好的服务</string>
    
    <!-- 其他配置... -->
</dict>
```

#### 步骤 4: 更新配置文件

**文件**: `mobile_app/lib/config/app_config.dart`

修改第 19 和 24 行：

```dart
static const String amapApiKeyAndroid = 'YOUR_AMAP_ANDROID_KEY';
static const String amapApiKeyIOS = 'YOUR_AMAP_IOS_KEY';
```

---

### 3. 配置权限

#### Android 权限

**文件**: `mobile_app/android/app/src/main/AndroidManifest.xml`

在 `<manifest>` 标签内添加：

```xml
<manifest>
    <!-- 网络权限 -->
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <!-- 位置权限 -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    
    <!-- 录音权限 -->
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
    
    <!-- 存储权限 -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    
    <application>
        ...
    </application>
</manifest>
```

#### iOS 权限

**文件**: `mobile_app/ios/Runner/Info.plist`

在 `<dict>` 标签内添加：

```xml
<dict>
    <!-- 位置权限 -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>需要访问您的位置以显示附近的声景</string>
    
    <!-- 麦克风权限 -->
    <key>NSMicrophoneUsageDescription</key>
    <string>需要访问麦克风以录制声景</string>
    
    <!-- 相册权限 -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>需要访问相册以选择图片</string>
    
    <!-- 其他配置... -->
</dict>
```

---

## 🚀 运行应用

### 查看可用设备
```bash
cd mobile_app
flutter devices
```

### 运行到设备
```bash
# 运行到指定设备
flutter run -d <device_id>

# 运行到 Android
flutter run -d 001521567001406

# 运行到 iOS 模拟器
flutter run -d <ios_simulator_id>
```

### 热重载
应用运行后：
- 按 `r` - 热重载
- 按 `R` - 热重启
- 按 `q` - 退出

---

## 🐛 常见问题

### Q1: 终端提示 "command not found: static"

**原因**: 在终端直接输入了 Dart 代码

**解决**: 使用代码编辑器打开文件并修改，不要在终端输入代码

---

### Q2: 布局溢出错误 "RenderFlex overflowed"

**已修复**: 在 `ink_style_components.dart` 中使用 `Flexible` 包裹文本

**如果仍有问题**: 运行热重载 (按 `r`)

---

### Q3: API 连接失败

**检查清单**:
- [ ] `app_config.dart` 中的 API 地址是否正确
- [ ] 后端服务是否启动
- [ ] 网络权限是否配置
- [ ] 设备/模拟器能否访问该地址

**Android 本地测试**:
```dart
// 使用 10.0.2.2 代替 localhost
static const String apiBaseUrl = 'http://10.0.2.2:3000/api';
```

---

### Q4: 地图不显示

**检查清单**:
- [ ] Google Maps API Key 是否配置
- [ ] API 是否在 Google Cloud Console 中启用
- [ ] API Key 是否有使用限制
- [ ] 网络连接是否正常

---

### Q5: 音频无法播放

**检查清单**:
- [ ] 音频 URL 是否有效
- [ ] 音频格式是否支持 (mp3/aac/m4a/wav)
- [ ] 网络权限是否配置
- [ ] 设备音量是否开启

---

## 📋 配置检查清单

部署前请确保完成：

### 必须配置 ✅
- [ ] 后端 API 地址 (`app_config.dart` 第 9 行)
- [ ] Google Maps Android Key (`AndroidManifest.xml`)
- [ ] Google Maps iOS Key (`AppDelegate.swift`)
- [ ] Android 权限 (`AndroidManifest.xml`)
- [ ] iOS 权限 (`Info.plist`)

### 可选配置
- [ ] API 超时时间 (`app_config.dart` 第 12 行)
- [ ] 音频质量设置 (`app_config.dart` 第 39-43 行)
- [ ] 缓存策略 (`app_config.dart` 第 51-55 行)
- [ ] 地图默认位置 (`app_config.dart` 第 26-30 行)

---

## 📚 相关文档

- **API 集成指南**: `docs/API_INTEGRATION_GUIDE.md`
- **集成总结**: `INTEGRATION_SUMMARY.md`
- **快速参考**: `QUICK_REFERENCE.md`
- **功能清单**: `docs/FEATURES_COMPLETE.md`

---

## 💡 开发技巧

### 1. 修改配置后
```bash
# 热重载
按 r

# 如果不生效，热重启
按 R

# 或完全重新构建
flutter run
```

### 2. 检查代码
```bash
cd mobile_app
flutter analyze
```

### 3. 清理构建
```bash
flutter clean
flutter pub get
```

### 4. 查看日志
```bash
flutter logs
```

---

## 🎯 快速开始流程

1. **安装依赖**
   ```bash
   cd mobile_app
   flutter pub get
   ```

2. **配置 API** (编辑文件，不是在终端输入！)
   - 打开 `app_config.dart`
   - 修改 `apiBaseUrl`

3. **配置地图** (如需使用地图功能)
   - 获取 Google Maps API Key
   - 配置 `AndroidManifest.xml`
   - 配置 `AppDelegate.swift`

4. **运行应用**
   ```bash
   flutter run -d <device_id>
   ```

5. **测试功能**
   - 浏览声景列表
   - 播放音频
   - 查看地图
   - 测试收藏功能

---

**记住: 所有配置都是通过编辑文件完成的，不要在终端执行 Dart 代码！** ✨

如有问题，请查看 `docs/API_INTEGRATION_GUIDE.md` 获取更详细的帮助。

