# API 集成指南

## 📡 后端 API 连接

### 1. 配置后端地址

编辑 `mobile_app/lib/config/app_config.dart`：

```dart
/// 后端 API 基础 URL
static const String apiBaseUrl = 'https://your-backend-api.com/api';
```

### 2. API 服务使用示例

#### 获取声景列表

```dart
import 'package:mobile_app/services/api_service.dart';

final apiService = ApiService();

// 获取所有声景
final soundscapes = await apiService.getSoundscapes();

// 带筛选条件
final tangSoundscapes = await apiService.getSoundscapes(
  period: '唐代',
  emotion: '宁静',
  page: 1,
  limit: 20,
);
```

#### 上传声景

```dart
final result = await apiService.uploadSoundscape(
  audioPath: '/path/to/audio.mp3',
  title: '唐代扬州夜雨',
  period: '唐代',
  location: '扬州',
  emotions: ['宁静', '怀古'],
  poem: '夜雨扬州巷，墨香染诗篇',
  latitude: 32.3939,
  longitude: 119.4212,
);
```

#### 收藏管理

```dart
// 收藏声景
await apiService.favoriteSoundscape('soundscape_id');

// 取消收藏
await apiService.unfavoriteSoundscape('soundscape_id');

// 获取收藏列表
final favorites = await apiService.getFavorites();
```

---

## 🎵 音频播放集成

### 1. 初始化音频服务

音频服务在 `main.dart` 中自动初始化：

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeServices();
  runApp(const WaterScapesApp());
}
```

### 2. 播放音频

```dart
import 'package:mobile_app/services/audio_service.dart';

final audioPlayer = AudioPlayerService();

// 播放网络音频
await audioPlayer.play(
  'https://your-cdn.com/audio/soundscape_123.mp3',
  soundscapeId: 'soundscape_123',
);

// 播放本地文件
await audioPlayer.playLocal('/path/to/local/audio.mp3');

// 暂停/恢复
await audioPlayer.pause();
await audioPlayer.resume();

// 跳转位置
await audioPlayer.seek(Duration(seconds: 30));

// 设置音量
await audioPlayer.setVolume(0.8);
```

### 3. 监听播放状态

```dart
audioPlayer.onPlayingChanged = (playing) {
  print('播放状态: $playing');
};

audioPlayer.onPositionChanged = (position) {
  print('当前位置: ${position.inSeconds}秒');
};

audioPlayer.onDurationChanged = (duration) {
  print('总时长: ${duration?.inSeconds}秒');
};

audioPlayer.onCompleted = () {
  print('播放完成');
};
```

---

## 🗺️ Google Maps 集成

### 1. 获取 Google Maps API Key

1. 访问 [Google Cloud Console](https://console.cloud.google.com/)
2. 创建新项目或选择现有项目
3. 启用 "Maps SDK for Android" 和 "Maps SDK for iOS"
4. 创建 API Key（分别为 Android 和 iOS 创建）
5. 设置 API Key 限制（建议）

### 2. 配置 Android

编辑 `mobile_app/android/app/src/main/AndroidManifest.xml`：

```xml
<application>
    ...
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_ANDROID_API_KEY"/>
</application>
```

### 3. 配置 iOS

编辑 `mobile_app/ios/Runner/AppDelegate.swift`：

```swift
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_IOS_API_KEY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### 4. 更新配置文件

编辑 `mobile_app/lib/config/app_config.dart`：

```dart
static const String googleMapsApiKeyAndroid = 'YOUR_ANDROID_API_KEY';
static const String googleMapsApiKeyIOS = 'YOUR_IOS_API_KEY';
```

### 5. 使用地图组件

```dart
import 'package:mobile_app/widgets/google_ink_map_widget.dart';

GoogleInkMapWidget(
  onMapCreated: (controller) {
    print('地图创建完成');
  },
  onMapClick: (latLng) {
    print('点击位置: ${latLng.latitude}, ${latLng.longitude}');
  },
  markers: [
    SoundscapeMarker(
      id: '1',
      title: '唐代扬州夜雨',
      period: '唐代',
      emotion: '宁静',
      latitude: 32.3939,
      longitude: 119.4212,
    ),
  ],
)
```

---

## 🔐 用户认证

### 1. 登录

```dart
try {
  final result = await apiService.login('username', 'password');
  print('登录成功: ${result['user']}');
  // Token 自动保存
} catch (e) {
  print('登录失败: $e');
}
```

### 2. 获取用户信息

```dart
final profile = await apiService.getUserProfile();
print('用户名: ${profile['username']}');
print('积分: ${profile['points']}');
```

### 3. 退出登录

```dart
await apiService.clearToken();
```

---

## 📂 文件管理

### 1. 选择音频文件

```dart
import 'package:image_picker/image_picker.dart';

// 从相册选择
final picker = ImagePicker();
// TODO: 使用 file_picker 替代 image_picker 选择音频文件
```

### 2. 获取临时目录

```dart
import 'package:path_provider/path_provider.dart';

final tempDir = await getTemporaryDirectory();
final audioPath = '${tempDir.path}/recording.aac';
```

---

## ⚙️ 权限管理

### 1. 请求权限

```dart
import 'package:permission_handler/permission_handler.dart';

// 请求麦克风权限（录音）
final micStatus = await Permission.microphone.request();
if (micStatus.isGranted) {
  print('麦克风权限已授予');
}

// 请求存储权限
final storageStatus = await Permission.storage.request();
if (storageStatus.isGranted) {
  print('存储权限已授予');
}

// 请求位置权限
final locationStatus = await Permission.location.request();
if (locationStatus.isGranted) {
  print('位置权限已授予');
}
```

### 2. 检查权限状态

```dart
final status = await Permission.microphone.status;
if (status.isDenied) {
  // 权限被拒绝
} else if (status.isPermanentlyDenied) {
  // 权限被永久拒绝，需要引导用户到设置页面
  await openAppSettings();
}
```

---

## 📊 数据同步

### 1. 获取统计数据

```dart
final stats = await apiService.getUserStats();
print('上传数: ${stats['uploadCount']}');
print('收藏数: ${stats['favoriteCount']}');
print('播放数: ${stats['playCount']}');
```

### 2. 获取推荐

```dart
final recommendations = await apiService.getRecommendations();
for (var soundscape in recommendations) {
  print('推荐: ${soundscape['title']}');
}
```

---

## 🔄 本地缓存

### 1. 保存数据

```dart
import 'package:shared_preferences/shared_preferences.dart';

final prefs = await SharedPreferences.getInstance();

// 保存字符串
await prefs.setString('username', '张三');

// 保存布尔值
await prefs.setBool('autoPlay', true);

// 保存整数
await prefs.setInt('audioQuality', 2);
```

### 2. 读取数据

```dart
final username = prefs.getString('username') ?? '游客';
final autoPlay = prefs.getBool('autoPlay') ?? false;
final audioQuality = prefs.getInt('audioQuality') ?? 1;
```

---

## 🚨 错误处理

### 1. 网络错误处理

```dart
try {
  final soundscapes = await apiService.getSoundscapes();
} catch (e) {
  if (e.toString().contains('网络连接超时')) {
    // 显示网络超时提示
  } else if (e.toString().contains('错误 401')) {
    // Token 过期，需要重新登录
  } else {
    // 其他错误
  }
}
```

### 2. 音频播放错误

```dart
try {
  await audioPlayer.play(audioUrl);
} catch (e) {
  print('播放失败: $e');
  // 显示错误提示
}
```

---

## 🧪 测试建议

### 1. API 测试

使用模拟数据进行前端开发：

```dart
// 创建模拟数据
final mockSoundscapes = [
  {
    'id': '1',
    'title': '唐代扬州夜雨',
    'period': '唐代',
    'location': '扬州',
    'emotion': '宁静',
    'audioUrl': 'https://example.com/audio/1.mp3',
  },
];
```

### 2. 音频测试

使用在线音频文件进行测试：

```dart
// 测试用音频 URL
const testAudioUrl = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
await audioPlayer.play(testAudioUrl);
```

---

## 📝 配置清单

完成以下配置后即可正常使用：

- [ ] 配置后端 API 地址 (`app_config.dart`)
- [ ] 配置 Google Maps Android API Key
- [ ] 配置 Google Maps iOS API Key
- [ ] 添加必要的 Android 权限 (`AndroidManifest.xml`)
- [ ] 添加必要的 iOS 权限 (`Info.plist`)
- [ ] 初始化所有服务 (`main.dart`)
- [ ] 测试 API 连接
- [ ] 测试音频播放
- [ ] 测试地图显示

---

## 🆘 常见问题

### Q: API 请求超时怎么办？

A: 检查网络连接和后端服务器状态，可以在 `app_config.dart` 中增加超时时间。

### Q: 音频无法播放？

A: 检查音频 URL 是否有效，确保音频格式受支持（mp3, aac, m4a, wav）。

### Q: 地图不显示？

A: 确保 API Key 配置正确，并且在 Google Cloud Console 中启用了相应的 API。

### Q: 如何切换到生产环境？

A: 修改 `app_config.dart` 中的 `apiBaseUrl` 为生产环境地址。

---

**完成所有配置后，应用即可实现完整的功能！** ✨

