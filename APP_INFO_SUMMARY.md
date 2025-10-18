# 📱 应用信息总览

## 🎯 完整应用信息（Android + iOS）

### 应用基本信息

| 项目 | 值 |
|------|-----|
| **应用名称** | 水上书 (WaterScapes) |
| **应用类型** | 移动应用 (Flutter) |
| **版本** | v1.0.0 |
| **开发状态** | 开发中 |

---

## 📦 Android 配置信息

### PackageName（包名）
```
com.canal.waterscapes.mobile_app
```

### SHA1 签名（调试版）
```
48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71
```

### 获取方式
```bash
# 查看 PackageName
grep "applicationId" mobile_app/android/app/build.gradle.kts

# 查看 SHA1
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android | grep "SHA1:"
```

---

## 🍎 iOS 配置信息

### Bundle ID
```
com.canal.waterscapes.mobileApp
```

### 获取方式
```bash
# 查看 Bundle ID
grep "PRODUCT_BUNDLE_IDENTIFIER" \
  mobile_app/ios/Runner.xcodeproj/project.pbxproj | head -1
```

---

## 🗺️ 高德地图配置表单

### Android Key 配置

访问 https://lbs.amap.com/ 添加 Android Key 时填写：

| 字段 | 填写内容 |
|------|---------|
| **Key 名称** | `WaterScapes Android` |
| **PackageName** | `com.canal.waterscapes.mobile_app` |
| **发布版安全码 SHA1** | `48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71` |
| **调试版安全码 SHA1** | `48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71` |

### iOS Key 配置

添加 iOS Key 时填写：

| 字段 | 填写内容 |
|------|---------|
| **Key 名称** | `WaterScapes iOS` |
| **Bundle ID** | `com.canal.waterscapes.mobileApp` |

---

## 📝 快速复制区域

### 用于高德平台 - Android

**PackageName:**
```
com.canal.waterscapes.mobile_app
```

**SHA1:**
```
48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71
```

### 用于高德平台 - iOS

**Bundle ID:**
```
com.canal.waterscapes.mobileApp
```

---

## ⚙️ 配置到项目

### 自动配置（推荐）

```bash
cd /Users/zephyruszhou/Documents/Canal_App
./configure_amap.sh
```

按提示输入：
1. Android API Key（从高德平台获取）
2. iOS API Key（从高德平台获取）

### 手动配置

#### 1. 编辑 app_config.dart
```bash
open -e mobile_app/lib/config/app_config.dart
```

修改：
```dart
static const String amapApiKeyAndroid = '你的Android Key';
static const String amapApiKeyIOS = '你的iOS Key';
```

#### 2. 编辑 AndroidManifest.xml
```bash
open -e mobile_app/android/app/src/main/AndroidManifest.xml
```

在 `<application>` 内添加：
```xml
<meta-data
    android:name="com.amap.api.v2.apikey"
    android:value="你的Android Key" />
```

#### 3. 编辑 Info.plist
```bash
open -e mobile_app/ios/Runner/Info.plist
```

在 `<dict>` 内添加：
```xml
<key>AMapApiKey</key>
<string>你的iOS Key</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>水上书需要访问您的位置来显示附近的声景</string>
```

---

## 🔍 验证配置

### 检查配置文件
```bash
# 查看配置的 API Keys
cat mobile_app/lib/config/app_config.dart | grep "amapApiKey"

# 查看 Android 配置
cat mobile_app/android/app/src/main/AndroidManifest.xml | grep -A2 "amap"

# 查看 iOS 配置
cat mobile_app/ios/Runner/Info.plist | grep -A1 "AMapApiKey"
```

### 运行应用
```bash
cd mobile_app

# Android
flutter run -d 001521567001406

# iOS 模拟器
flutter run -d iPhone

# iOS 真机（先查看设备ID）
flutter devices
flutter run -d <your-iphone-id>
```

---

## 📊 配置状态检查清单

### Android
- [ ] ✅ PackageName 已确认: `com.canal.waterscapes.mobile_app`
- [ ] ✅ SHA1 已获取: `48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71`
- [ ] ⏳ 已在高德平台添加 Android Key
- [ ] ⏳ 已复制 Android API Key
- [ ] ⏳ 已配置到 app_config.dart
- [ ] ⏳ 已配置到 AndroidManifest.xml
- [ ] ⏳ 已在 Android 设备上测试

### iOS
- [ ] ✅ Bundle ID 已确认: `com.canal.waterscapes.mobileApp`
- [ ] ⏳ 已在高德平台添加 iOS Key
- [ ] ⏳ 已复制 iOS API Key
- [ ] ⏳ 已配置到 app_config.dart
- [ ] ⏳ 已配置到 Info.plist
- [ ] ⏳ 已在 iOS 设备上测试

---

## 📖 相关文档

| 文档 | 说明 |
|------|------|
| `ANDROID_INFO.md` | Android 完整信息和配置指南 |
| `IOS_INFO.md` | iOS 完整信息和配置指南 |
| `QUICK_SETUP.md` | 快速配置指南（5-10分钟） |
| `AMAP_KEY_SETUP.md` | 高德地图详细配置步骤 |
| `configure_amap.sh` | 自动配置脚本 |

---

## 🔗 快速链接

### 高德开放平台
- **登录/注册**: https://lbs.amap.com/
- **控制台**: https://console.amap.com/
- **文档中心**: https://lbs.amap.com/api/

### 项目文档
- **快速开始**: `START_HERE.md`
- **项目状态**: `PROJECT_STATUS.md`
- **常用命令**: `QUICK_COMMANDS.md`
- **错误修复**: `ERROR_FIXES.md`

---

## 🎯 下一步行动

1. **访问高德开放平台** 🌐
   ```
   https://lbs.amap.com/
   ```

2. **创建应用并获取 Keys** 🔑
   - 添加 Android Key（需要 PackageName + SHA1）
   - 添加 iOS Key（需要 Bundle ID）

3. **运行配置脚本** ⚡
   ```bash
   ./configure_amap.sh
   ```

4. **测试应用** 🧪
   ```bash
   cd mobile_app && flutter run
   ```

---

## 💡 重要提示

### PackageName vs Bundle ID
- **Android PackageName**: `com.canal.waterscapes.mobile_app`
  - 使用 **下划线** `_`
  - 格式: `com.company.app_name`

- **iOS Bundle ID**: `com.canal.waterscapes.mobileApp`
  - 使用 **驼峰命名** `mobileApp`
  - 格式: `com.company.appName`

### 两者的区别
- Android 和 iOS 的包名**不完全相同**
- Android: `mobile_app`（下划线）
- iOS: `mobileApp`（驼峰）
- 这是**正常的**，不是错误！

---

## ✅ 准备完成！

现在你拥有了配置高德地图所需的所有信息：

✅ Android PackageName: `com.canal.waterscapes.mobile_app`  
✅ Android SHA1: `48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71`  
✅ iOS Bundle ID: `com.canal.waterscapes.mobileApp`  
✅ 配置文档完整  
✅ 自动配置脚本就绪  

只需：
1. 去高德平台获取 API Keys（约 5-10 分钟）
2. 运行 `./configure_amap.sh`（约 1 分钟）
3. 测试应用！

---

*最后更新: 2025-10-17 22:55*  
*文档版本: v1.0.0*  
*状态: ✅ 完整*






