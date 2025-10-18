# 🚀 开始使用 - 高德地图配置

## ✅ 当前状态

- ✅ 所有代码错误已修复
- ✅ 应用已成功构建
- ✅ 宣纸风格主题已应用
- ⚠️ **需要配置高德地图 API Key**

---

## 📍 快速配置（3 步完成）

### 方式一：自动配置脚本 🤖

```bash
# 在项目根目录运行
cd /Users/zephyruszhou/Documents/Canal_App
./configure_amap.sh
```

脚本会提示你输入：
1. Android API Key
2. iOS API Key

然后自动配置所有文件。

---

### 方式二：手动配置 ✏️

#### 第 1 步：获取 API Key

**访问高德开放平台:**
```
https://lbs.amap.com/
```

**注册并创建应用:**
1. 登录/注册账号
2. 进入"控制台" → "应用管理" → "我的应用"
3. 点击"创建新应用"
   - 应用名称：水上书
   - 应用类型：移动应用

**添加 Android Key:**
1. 在应用中点击"添加 Key"
2. 选择平台：Android
3. 填写：
   - Key 名称：WaterScapes Android
   - PackageName：`com.canal.waterscapes.mobile_app`
   - SHA1：需要获取（见下方）
4. 提交并复制生成的 Key

**获取 SHA1 指纹:**
```bash
cd /Users/zephyruszhou/Documents/Canal_App/mobile_app/android
./gradlew signingReport | grep "SHA1:"
```

**添加 iOS Key:**
1. 同样在应用中点击"添加 Key"
2. 选择平台：iOS
3. 填写：
   - Key 名称：WaterScapes iOS
   - Bundle ID：`com.canal.waterscapes.mobileApp`
4. 提交并复制生成的 Key

---

#### 第 2 步：配置项目

**A. 编辑 app_config.dart**

```bash
open -e /Users/zephyruszhou/Documents/Canal_App/mobile_app/lib/config/app_config.dart
```

修改第 15-16 行：
```dart
static const String amapApiKeyAndroid = '你的Android Key';
static const String amapApiKeyIOS = '你的iOS Key';
```

**B. 编辑 AndroidManifest.xml**

```bash
open -e /Users/zephyruszhou/Documents/Canal_App/mobile_app/android/app/src/main/AndroidManifest.xml
```

在 `<application>` 标签内添加：
```xml
<application>
    <!-- 高德地图 API Key -->
    <meta-data
        android:name="com.amap.api.v2.apikey"
        android:value="你的Android Key" />
    
    <!-- 其他配置... -->
</application>
```

**C. 编辑 Info.plist（iOS）**

```bash
open -e /Users/zephyruszhou/Documents/Canal_App/mobile_app/ios/Runner/Info.plist
```

在 `<dict>` 标签内添加：
```xml
<key>AMapApiKey</key>
<string>你的iOS Key</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>水上书需要访问您的位置来显示附近的声景</string>
```

---

#### 第 3 步：运行应用

```bash
cd /Users/zephyruszhou/Documents/Canal_App/mobile_app
flutter clean
flutter pub get
flutter run -d 001521567001406
```

---

## 🎯 验证配置

### ✅ 配置成功的标志：

1. **应用启动无报错**
2. **地图页面显示高德地图**
3. **可以拖动、缩放地图**
4. **可以看到声景标记点**

### ❌ 如果地图显示空白：

**检查清单:**
```bash
# 1. 检查 app_config.dart
cat mobile_app/lib/config/app_config.dart | grep "amapApiKey"

# 2. 检查 AndroidManifest.xml
cat mobile_app/android/app/src/main/AndroidManifest.xml | grep -A2 "amap"

# 3. 查看应用日志
flutter logs
```

**常见问题:**
- Key 未填写或填写错误 → 重新检查并填写正确的 Key
- SHA1 不匹配 → 重新获取 SHA1 并在高德平台更新
- Key 未生效 → 等待 2-5 分钟后重试

---

## 📚 相关文档

| 文档 | 说明 |
|------|------|
| [AMAP_KEY_SETUP.md](./AMAP_KEY_SETUP.md) | 详细的高德地图配置指南 |
| [ERROR_FIXES.md](./ERROR_FIXES.md) | 已修复的错误说明 |
| [FIX_STATUS.md](./FIX_STATUS.md) | 修复状态报告 |
| [QUICK_COMMANDS.md](./QUICK_COMMANDS.md) | 常用命令速查 |
| [CONFIGURATION_GUIDE.md](./CONFIGURATION_GUIDE.md) | 完整配置指南 |

---

## 🆘 需要帮助？

### 选项 1：查看详细文档
```bash
cat AMAP_KEY_SETUP.md
```

### 选项 2：使用配置脚本
```bash
./configure_amap.sh
```

### 选项 3：查看快速命令
```bash
cat QUICK_COMMANDS.md
```

---

## 🎨 当前应用功能

### ✅ 已完成
- [x] 宣纸底色主题
- [x] 水墨风格UI组件
- [x] 音频播放服务
- [x] 音频录制服务
- [x] API 通信服务
- [x] 用户界面页面
- [x] 地图组件（AMap）

### ⏳ 待配置
- [ ] 高德地图 API Key ⬅️ **当前步骤**
- [ ] 后端 API 连接
- [ ] 实时数据同步

### 🔮 未来优化
- [ ] 自定义地图样式（水墨风格）
- [ ] 离线缓存
- [ ] 性能优化

---

## 💡 提示

> **如果你还没有高德账号：**
> 
> 1. 注册很快：访问 https://lbs.amap.com/
> 2. 个人开发者免费
> 3. 配额充足（日配额 30 万次）
> 4. 配置简单（约 5-10 分钟）

> **如果已有 API Key：**
> 
> 直接运行配置脚本最快：
> ```bash
> ./configure_amap.sh
> ```

---

## 🎉 配置完成后

运行以下命令启动应用：

```bash
cd mobile_app
flutter run -d 001521567001406
```

然后：
- 打开地图页面
- 查看声景标记
- 点击标记播放音频
- 尝试上传新声景

---

**准备好了吗？让我们开始配置！** 🚀

选择一个方式开始：
1. 运行 `./configure_amap.sh` （推荐）
2. 按照上面的手动配置步骤
3. 查看 `AMAP_KEY_SETUP.md` 获取更多帮助

---

*最后更新: 2025-10-17*  
*当前版本: v1.0.0*  
*状态: 🟡 等待配置高德地图*






