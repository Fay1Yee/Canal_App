# 🗺️ 高德地图 API Key 配置指南

## 📋 前置要求
- 高德开放平台账号
- Android 应用包名: `com.canal.waterscapes.mobile_app`
- iOS Bundle ID: `com.canal.waterscapes.mobileApp`

---

## 🎯 获取 API Key 步骤

### 1️⃣ 注册高德开放平台账号

访问: https://lbs.amap.com/

1. 点击右上角"注册/登录"
2. 使用手机号或邮箱注册
3. 完成实名认证（个人/企业）

---

### 2️⃣ 创建应用

1. 登录后进入"控制台"
2. 点击"应用管理" -> "我的应用"
3. 点击"创建新应用"
4. 填写应用信息:
   - **应用名称**: 水上书 (WaterScapes)
   - **应用类型**: 移动应用
   - **应用简介**: 水墨风格的声景地图应用

---

### 3️⃣ 添加 Android Key

#### 获取 Android SHA1
```bash
cd /Users/zephyruszhou/Documents/Canal_App/mobile_app/android
./gradlew signingReport
```

查找输出中的 SHA1 值:
```
Variant: debug
Config: debug
Store: ~/.android/debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX  ⬅️ 复制这个
SHA-256: XX:XX:XX...
```

#### 在高德平台添加 Key
1. 在应用详情页，点击"添加 Key"
2. 选择平台: **Android**
3. 填写信息:
   - **Key 名称**: WaterScapes Android
   - **PackageName**: `com.canal.waterscapes.mobile_app`
   - **SHA1**: (粘贴上面复制的值)
4. 点击"提交"
5. **复制生成的 Key** (格式: xxxxxxxxxxxxxxxxxxxxxxxxxxxx)

---

### 4️⃣ 添加 iOS Key

1. 在应用详情页，点击"添加 Key"
2. 选择平台: **iOS**
3. 填写信息:
   - **Key 名称**: WaterScapes iOS
   - **Bundle ID**: `com.canal.waterscapes.mobileApp`
4. 点击"提交"
5. **复制生成的 Key**

---

## ⚙️ 配置到项目

### 方式一: 使用配置脚本（推荐）

我会为你创建一个配置脚本，只需运行:

```bash
cd /Users/zephyruszhou/Documents/Canal_App
./configure_amap.sh
```

然后按提示输入 Android 和 iOS 的 API Key。

### 方式二: 手动配置

编辑配置文件:
```bash
nano mobile_app/lib/config/app_config.dart
```

找到这两行并替换:
```dart
// 第 15 行
static const String amapApiKeyAndroid = 'YOUR_ANDROID_KEY_HERE';

// 第 16 行
static const String amapApiKeyIOS = 'YOUR_IOS_KEY_HERE';
```

保存后退出 (Ctrl+O, Enter, Ctrl+X)

---

## 🔧 Android 配置

### 1. 编辑 AndroidManifest.xml

```bash
nano mobile_app/android/app/src/main/AndroidManifest.xml
```

在 `<application>` 标签内添加:
```xml
<application>
    <!-- 高德地图 API Key -->
    <meta-data
        android:name="com.amap.api.v2.apikey"
        android:value="你的Android Key" />
    
    <!-- 其他配置... -->
</application>
```

### 2. 检查权限

确保 AndroidManifest.xml 包含以下权限:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

---

## 🍎 iOS 配置

### 1. 编辑 Info.plist

```bash
nano mobile_app/ios/Runner/Info.plist
```

在 `<dict>` 标签内添加:
```xml
<key>AMapApiKey</key>
<string>你的iOS Key</string>

<!-- 位置权限描述 -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>水上书需要访问您的位置来显示附近的声景</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>水上书需要访问您的位置来记录声景</string>
```

---

## ✅ 验证配置

### 1. 检查配置文件
```bash
cat mobile_app/lib/config/app_config.dart | grep "amapApiKey"
```

应该看到你的 API Keys (不是 'YOUR_XXX_KEY_HERE')

### 2. 重新构建应用
```bash
cd mobile_app
flutter clean
flutter pub get
flutter run -d 001521567001406
```

### 3. 测试地图功能
- 打开应用
- 进入地图页面
- 应该能看到高德地图加载
- 可以缩放、平移地图
- 可以看到标记点

---

## 🐛 常见问题

### 问题 1: 地图显示空白
**原因**: API Key 未配置或配置错误

**解决**:
```bash
# 检查 AndroidManifest.xml
cat mobile_app/android/app/src/main/AndroidManifest.xml | grep "amap"

# 应该看到: android:value="你的实际Key"
```

### 问题 2: SHA1 不匹配
**错误**: "Key 鉴权失败"

**解决**:
1. 重新获取 SHA1: `cd mobile_app/android && ./gradlew signingReport`
2. 在高德平台更新 SHA1
3. 等待 2-5 分钟生效
4. 重新运行应用

### 问题 3: iOS 地图不显示
**原因**: Info.plist 未配置

**解决**:
```bash
# 检查 Info.plist
cat mobile_app/ios/Runner/Info.plist | grep -A1 "AMapApiKey"
```

---

## 📞 需要帮助？

如果遇到问题:
1. 查看高德控制台的"服务统计"，确认 Key 是否有请求记录
2. 查看 Flutter 日志: `flutter logs`
3. 检查高德开放平台的文档: https://lbs.amap.com/api/android-sdk/gettingstarted

---

## 🎉 配置完成检查清单

- [ ] 已注册高德开放平台账号
- [ ] 已创建应用
- [ ] 已获取 Android Key 并配置
- [ ] 已获取 iOS Key 并配置
- [ ] 已在 app_config.dart 中设置 Keys
- [ ] 已在 AndroidManifest.xml 中添加 Key
- [ ] 已在 Info.plist 中添加 Key
- [ ] 已测试地图显示正常

---

*最后更新: 2025-10-17*






