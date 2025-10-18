# 📱 应用信息（Android + iOS）

## 🔑 关键信息（用于高德地图配置）

### Android 配置

**PackageName（包名）:**
```
com.canal.waterscapes.mobile_app
```

**SHA1 签名（调试版）:**
```
48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71
```

### iOS 配置

**Bundle ID:**
```
com.canal.waterscapes.mobileApp
```

---

## 📋 高德地图配置表单

### 填写信息

**发布版安全码 SHA1:**
```
48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71
```

**调试版安全码 SHA1:** (同上)
```
48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71
```

**PackageName:**
```
com.canal.waterscapes.mobile_app
```

---

## 🚀 配置步骤

### 1. 访问高德开放平台
```
https://lbs.amap.com/
```

### 2. 创建应用
1. 登录账号
2. 进入"控制台" → "应用管理" → "我的应用"
3. 点击"创建新应用"
   - 应用名称：**水上书**
   - 应用类型：**移动应用**

### 3. 添加 Android Key
在应用详情页：
1. 点击"添加 Key"
2. 选择平台：**Android**
3. 填写信息：
   
   | 字段 | 值 |
   |------|-----|
   | **Key 名称** | `WaterScapes Android` |
   | **PackageName** | `com.canal.waterscapes.mobile_app` |
   | **发布版安全码 SHA1** | `48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71` |
   | **调试版安全码 SHA1** | `48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71` |

4. 点击"提交"
5. **复制生成的 Android Key**（类似：`a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`）

### 4. 添加 iOS Key
1. 在同一应用中，再次点击"添加 Key"
2. 选择平台：**iOS**
3. 填写信息：
   - **Key 名称**: `WaterScapes iOS`
   - **Bundle ID**: `com.canal.waterscapes.mobileApp`
4. 点击"提交"
5. **复制生成的 iOS Key**

---

## ⚙️ 配置到项目

### 方式一：使用自动配置脚本（推荐）

```bash
cd /Users/zephyruszhou/Documents/Canal_App
./configure_amap.sh
```

按提示输入：
1. Android API Key
2. iOS API Key

脚本会自动配置所有文件。

### 方式二：手动配置

#### A. 编辑 app_config.dart
```bash
open -e mobile_app/lib/config/app_config.dart
```

修改第 15-16 行：
```dart
static const String amapApiKeyAndroid = '你的Android Key';
static const String amapApiKeyIOS = '你的iOS Key';
```

#### B. 编辑 AndroidManifest.xml
```bash
open -e mobile_app/android/app/src/main/AndroidManifest.xml
```

在 `<application>` 标签内添加：
```xml
<meta-data
    android:name="com.amap.api.v2.apikey"
    android:value="你的Android Key" />
```

#### C. 编辑 Info.plist（iOS）
```bash
open -e mobile_app/ios/Runner/Info.plist
```

在 `<dict>` 标签内添加：
```xml
<key>AMapApiKey</key>
<string>你的iOS Key</string>
```

---

## 🔍 验证配置

### 检查配置文件
```bash
# 1. 检查 app_config.dart
cat mobile_app/lib/config/app_config.dart | grep "amapApiKey"

# 2. 检查 AndroidManifest.xml
cat mobile_app/android/app/src/main/AndroidManifest.xml | grep -A2 "amap"
```

### 运行应用
```bash
cd mobile_app
flutter clean
flutter pub get
flutter run -d 001521567001406
```

---

## 📝 注意事项

### 关于 SHA1
- **调试版 SHA1**: 用于开发和测试
- **发布版 SHA1**: 用于发布到应用商店
- 对于开发阶段，可以只配置调试版 SHA1
- 两者可以相同（如上所示）

### 获取其他 SHA1 的方法

#### 调试版（已获取）
```bash
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android | grep "SHA1:"
```

#### 发布版（需要生成发布密钥）
```bash
# 1. 生成发布密钥（如果还没有）
keytool -genkey -v \
  -keystore ~/waterscapes-release.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias waterscapes

# 2. 查看 SHA1
keytool -list -v \
  -keystore ~/waterscapes-release.jks \
  -alias waterscapes | grep "SHA1:"
```

---

## 🎯 快速复制

### 用于高德平台表单

**PackageName:**
```
com.canal.waterscapes.mobile_app
```

**SHA1:**
```
48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71
```

---

## 📱 应用详情

| 项目 | 值 |
|------|-----|
| **应用名称** | 水上书 (WaterScapes) |
| **Android 包名** | com.canal.waterscapes.mobile_app |
| **iOS Bundle ID** | com.canal.waterscapes.mobileApp |
| **调试版 SHA1** | 48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71 |
| **Keystore 位置** | ~/.android/debug.keystore |
| **Alias** | androiddebugkey |

---

## 🔗 相关链接

- **高德开放平台**: https://lbs.amap.com/
- **控制台**: https://console.amap.com/dev/index
- **文档**: https://lbs.amap.com/api/android-sdk/gettingstarted
- **SHA1 说明**: https://lbs.amap.com/api/android-sdk/guide/create-project/get-key

---

## 🆘 常见问题

### Q: SHA1 格式正确吗？
**A**: 是的！格式为 `XX:XX:XX:...`（20组，用冒号分隔）

### Q: 调试版和发布版 SHA1 需要都填吗？
**A**: 开发阶段只需填调试版即可。发布前再添加发布版 SHA1。

### Q: 如何测试配置是否成功？
**A**: 运行应用后，打开地图页面：
- ✅ 成功：地图正常显示
- ❌ 失败：地图空白或提示 Key 错误

### Q: Key 鉴权失败怎么办？
**A**: 
1. 确认 PackageName 正确
2. 确认 SHA1 正确（冒号分隔）
3. 等待 2-5 分钟让配置生效
4. 重新运行应用

---

## ✅ 配置检查清单

- [ ] 已在高德平台注册账号
- [ ] 已创建应用"水上书"
- [ ] 已添加 Android Key（填入 PackageName 和 SHA1）
- [ ] 已添加 iOS Key
- [ ] 已复制 Android Key 和 iOS Key
- [ ] 已配置 `app_config.dart`
- [ ] 已配置 `AndroidManifest.xml`
- [ ] 已配置 `Info.plist`
- [ ] 已运行 `flutter clean && flutter pub get`
- [ ] 已测试地图显示

---

*生成时间: 2025-10-17 22:45*  
*适用版本: v1.0.0*  
*状态: ✅ 信息已确认*

