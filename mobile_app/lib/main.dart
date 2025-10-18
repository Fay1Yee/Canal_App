import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化服务
  await _initializeServices();

  runApp(const WaterScapesApp());
}

/// 初始化所有服务
Future<void> _initializeServices() async {
  try {
    // 初始化 API 服务
    await ApiService().init();

    // 初始化音频播放服务
    await AudioPlayerService().init();

    // 初始化录音服务
    await AudioRecorderService().init();

    print('所有服务初始化完成');
  } catch (e) {
    print('服务初始化失败: $e');
  }
}

class WaterScapesApp extends StatelessWidget {
  const WaterScapesApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 设置系统UI样式
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryBlack,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: '水上书',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
