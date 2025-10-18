# ⚡ 快速配置指南 - 高德地图

## 🎯 你需要的信息（直接复制使用）

### Android 配置

**📦 PackageName:**
```
com.canal.waterscapes.mobile_app
```

**🔐 SHA1:**
```
48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71
```

### iOS 配置

**🍎 Bundle ID:**
```
com.canal.waterscapes.mobileApp
```

---

## 🚀 三步完成配置

### 第 1 步：访问高德平台（2分钟）

1. **打开浏览器，访问：**
   ```
   https://lbs.amap.com/
   ```

2. **登录或注册账号**
   - 个人开发者免费
   - 使用手机号注册即可

3. **进入控制台**
   - 点击右上角"控制台"
   - 选择"应用管理" → "我的应用"

---

### 第 2 步：创建应用并获取 Key（3分钟）

#### A. 创建应用
点击 "创建新应用"，填写：
```
应用名称: 水上书
应用类型: 移动应用
```

#### B. 添加 Android Key

在应用详情页，点击 "添加 Key"：

**平台**: 选择 `Android`

**填写表单**（直接复制下面的内容）:

| 字段 | 填写内容 |
|------|---------|
| Key 名称 | `WaterScapes Android` |
| PackageName | `com.canal.waterscapes.mobile_app` |
| 发布版安全码 SHA1 | `48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71` |
| 调试版安全码 SHA1 | `48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71` |

点击"提交"后，**复制生成的 Android Key**！

#### C. 添加 iOS Key

再次点击 "添加 Key"：

**平台**: 选择 `iOS`

**填写表单**:
```
Key 名称: WaterScapes iOS
Bundle ID: com.canal.waterscapes.mobileApp
```

点击"提交"后，**复制生成的 iOS Key**！

---

### 第 3 步：配置到项目（1分钟）

#### 方式一：自动配置（推荐）⚡

打开终端，运行：
```bash
cd /Users/zephyruszhou/Documents/Canal_App
./configure_amap.sh
```

按提示输入：
1. Android API Key（刚才复制的）
2. iOS API Key（刚才复制的）

**完成！** 🎉

#### 方式二：手动配置 ✏️

如果自动配置失败，手动操作：

1. **编辑配置文件**
   ```bash
   open -e mobile_app/lib/config/app_config.dart
   ```
   
   修改第 15-16 行：
   ```dart
   static const String amapApiKeyAndroid = '粘贴你的Android Key';
   static const String amapApiKeyIOS = '粘贴你的iOS Key';
   ```

2. **编辑 Android 清单**
   ```bash
   open -e mobile_app/android/app/src/main/AndroidManifest.xml
   ```
   
   在 `<application>` 标签内添加：
   ```xml
   <meta-data
       android:name="com.amap.api.v2.apikey"
       android:value="粘贴你的Android Key" />
   ```

3. **重新运行应用**
   ```bash
   cd mobile_app
   flutter clean
   flutter pub get
   flutter run -d 001521567001406
   ```

---

## ✅ 验证配置

运行应用后，打开地图页面：

### ✅ 成功标志：
- 地图正常显示
- 可以拖动、缩放地图
- 可以看到标记点

### ❌ 如果失败：
- 地图显示空白
- 提示 "Key 鉴权失败"

**解决方法**:
1. 确认 PackageName 和 SHA1 填写正确
2. 等待 2-5 分钟（配置需要时间生效）
3. 重新运行应用

---

## 📋 快速参考

### 应用信息
```
应用名称: 水上书 (WaterScapes)
Android 包名: com.canal.waterscapes.mobile_app
iOS Bundle ID: com.canal.waterscapes.mobileApp
SHA1: 48:B2:59:7E:2C:4F:74:EF:8D:64:76:25:F6:F5:4F:E8:14:9E:65:71
```

### 常用命令
```bash
# 查看详细信息
cat ANDROID_INFO.md

# 运行配置脚本
./configure_amap.sh

# 重新运行应用
cd mobile_app && flutter clean && flutter pub get && flutter run -d 001521567001406
```

### 相关文档
- `ANDROID_INFO.md` - 完整的 Android 信息
- `AMAP_KEY_SETUP.md` - 详细配置指南
- `START_HERE.md` - 快速开始指南

---

## 💡 提示

> ⏰ **总时间**: 约 5-10 分钟  
> 🎯 **难度**: 简单  
> 🔑 **关键**: 正确填写 PackageName 和 SHA1

> 💰 **费用**: 完全免费  
> 📊 **配额**: 30万次/天（个人开发者）  
> 🚀 **生效时间**: 2-5 分钟

---

## 🆘 遇到问题？

### 问题 1: 找不到 SHA1
**解决**: 查看 `ANDROID_INFO.md` 文件，已经为你获取好了！

### 问题 2: Key 鉴权失败
**解决**: 
```bash
# 1. 确认 PackageName
cat mobile_app/android/app/build.gradle.kts | grep "applicationId"

# 2. 确认 SHA1
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep "SHA1:"

# 3. 检查配置
cat mobile_app/lib/config/app_config.dart | grep "amapApiKey"
```

### 问题 3: 配置脚本运行失败
**解决**: 使用手动配置方式，按照上面的步骤操作。

---

## 🎉 配置完成后

运行应用：
```bash
cd mobile_app
flutter run -d 001521567001406
```

打开地图页面，应该能看到：
- ✅ 高德地图正常显示
- ✅ 地图上的声景标记
- ✅ 可以点击标记查看详情

---

**准备好了吗？开始配置吧！** 🚀

*最后更新: 2025-10-17*

