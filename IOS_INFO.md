# 🍎 iOS 应用信息

## 🔑 关键信息（用于高德地图配置）

### Bundle ID
```
com.canal.waterscapes.mobileApp
```

---

## 📋 高德地图 iOS Key 配置

### 填写信息

访问高德开放平台后，添加 iOS Key 时填写：

| 字段 | 值 |
|------|-----|
| **Key 名称** | `WaterScapes iOS` |
| **Bundle ID** | `com.canal.waterscapes.mobileApp` |

---

## 🚀 配置步骤

### 1. 在高德平台添加 iOS Key

1. 登录 [高德开放平台](https://lbs.amap.com/)
2. 进入"控制台" → "应用管理" → "我的应用"
3. 选择应用"水上书"
4. 点击"添加 Key"
5. 选择平台：**iOS**
6. 填写信息：
   - **Key 名称**: `WaterScapes iOS`
   - **Bundle ID**: `com.canal.waterscapes.mobileApp`
7. 点击"提交"
8. **复制生成的 iOS API Key**

---

### 2. 配置到项目

#### 方式一：使用自动配置脚本（推荐）

```bash
cd /Users/zephyruszhou/Documents/Canal_App
./configure_amap.sh
```

按提示输入：
1. Android API Key
2. iOS API Key（刚才复制的）

#### 方式二：手动配置

**A. 编辑 app_config.dart**

```bash
open -e mobile_app/lib/config/app_config.dart
```

修改第 16 行：
```dart
static const String amapApiKeyIOS = '你的iOS Key';
```

**B. 编辑 Info.plist**

```bash
open -e mobile_app/ios/Runner/Info.plist
```

在 `<dict>` 标签内添加（如果还没有）：
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

## 🔍 验证 Bundle ID

### 方法1：查看 Info.plist
```bash
grep -A1 "CFBundleIdentifier" mobile_app/ios/Runner/Info.plist
```

### 方法2：查看 Xcode 项目文件
```bash
grep "PRODUCT_BUNDLE_IDENTIFIER" mobile_app/ios/Runner.xcodeproj/project.pbxproj | head -1
```

输出应该是：
```
PRODUCT_BUNDLE_IDENTIFIER = com.canal.waterscapes.mobileApp;
```

---

## 📱 iOS 应用详情

| 项目 | 值 |
|------|-----|
| **应用名称** | 水上书 (WaterScapes) |
| **Bundle ID** | com.canal.waterscapes.mobileApp |
| **显示名称** | mobile_app |
| **最低iOS版本** | iOS 12.0+ |
| **开发团队** | (需要在 Xcode 中配置) |

---

## 🛠️ Xcode 配置（可选）

如果需要在 Xcode 中修改 Bundle ID：

1. 打开 Xcode 项目：
   ```bash
   open mobile_app/ios/Runner.xcworkspace
   ```

2. 选择 Runner 项目
3. 选择 Runner target
4. 在 General 标签页中，找到 Bundle Identifier
5. 确认值为：`com.canal.waterscapes.mobileApp`

---

## 📝 注意事项

### 关于 Bundle ID
- **格式**: 反向域名格式（com.公司.应用名）
- **唯一性**: 每个应用的 Bundle ID 必须唯一
- **大小写敏感**: `mobileApp` 和 `mobileapp` 是不同的
- **不可更改**: 一旦应用发布，Bundle ID 不能更改

### 关于高德地图 iOS Key
- **免费额度**: 30万次/天
- **有效期**: 永久有效
- **限制**: 仅限指定 Bundle ID 的应用使用
- **生效时间**: 配置后立即生效

---

## ✅ 配置检查清单

- [ ] 已确认 Bundle ID: `com.canal.waterscapes.mobileApp`
- [ ] 已在高德平台添加 iOS Key
- [ ] 已复制 iOS API Key
- [ ] 已配置 `app_config.dart`
- [ ] 已配置 `Info.plist`
- [ ] 已添加位置权限描述
- [ ] 已在 iOS 模拟器或真机上测试

---

## 🎯 快速复制

### 用于高德平台表单

**Bundle ID:**
```
com.canal.waterscapes.mobileApp
```

**Key 名称:**
```
WaterScapes iOS
```

---

## 🔗 相关文件位置

```
iOS 项目根目录:
  mobile_app/ios/

Info.plist:
  mobile_app/ios/Runner/Info.plist

Xcode 项目:
  mobile_app/ios/Runner.xcworkspace
  mobile_app/ios/Runner.xcodeproj/

配置文件:
  mobile_app/lib/config/app_config.dart
```

---

## 🆘 常见问题

### Q: Bundle ID 可以随意更改吗？
**A**: 
- 开发阶段可以更改
- 发布后不能更改（否则会被视为新应用）
- 更改后需要重新在高德平台注册

### Q: iOS 需要 SHA1 吗？
**A**: 不需要！iOS 只需要 Bundle ID。

### Q: 如何在真机上测试？
**A**: 
1. 用 USB 连接 iPhone
2. 在 Xcode 中选择你的设备
3. 点击运行（或使用 `flutter run -d <device-id>`）
4. 首次运行需要在 iPhone 设置中信任开发者证书

### Q: 提示 Key 鉴权失败怎么办？
**A**: 
1. 确认 Bundle ID 完全正确（大小写敏感）
2. 确认 API Key 已正确配置
3. 检查 Info.plist 中的 Key 是否正确
4. 重新构建应用

---

## 🎉 配置完成后

运行应用（iOS 模拟器）：
```bash
cd mobile_app
flutter run -d iPhone
```

运行应用（iOS 真机）：
```bash
cd mobile_app
flutter devices  # 查看设备ID
flutter run -d <your-iphone-device-id>
```

---

## 🔄 完整配置流程

### Android + iOS 双平台配置

1. **获取信息** ✅
   - Android PackageName: `com.canal.waterscapes.mobile_app`
   - Android SHA1: `48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71`
   - iOS Bundle ID: `com.canal.waterscapes.mobileApp`

2. **在高德平台配置** ⏳
   - 添加 Android Key（使用 PackageName + SHA1）
   - 添加 iOS Key（使用 Bundle ID）

3. **配置到项目** ⏳
   - 运行 `./configure_amap.sh`
   - 或手动编辑配置文件

4. **测试** ⏳
   - Android: `flutter run -d <android-device-id>`
   - iOS: `flutter run -d <ios-device-id>`

---

*生成时间: 2025-10-17 22:50*  
*适用版本: v1.0.0*  
*状态: ✅ 信息已确认*






