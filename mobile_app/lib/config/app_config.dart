/// 应用配置类
class AppConfig {
  // ==================== API 配置 ====================

  /// 后端 API 基础 URL
  /// TODO: 部署后端后修改为实际地址
  /// 本地开发时使用: http://localhost:3000/api
  /// 生产环境示例: https://your-backend-api.com/api
  static const String apiBaseUrl = 'http://localhost:3000/api';

  /// API 超时时间（秒）
  static const int apiTimeout = 30;

  // ==================== 地图配置 ====================

  /// 高德地图 API Key (Android)
  /// 获取地址: https://lbs.amap.com/
  /// TODO: 在高德开放平台创建应用并替换
  static const String amapApiKeyAndroid = 'b91e51b452f235132635f0e82f1e8f64';

  /// 高德地图 API Key (iOS)
  /// 获取地址: https://lbs.amap.com/
  /// TODO: 在高德开放平台创建应用并替换
  static const String amapApiKeyIOS = '5a7e06462583f09065452d323df3b4c4';

  /// 默认地图中心（杭州）
  static const double defaultLatitude = 30.2741;
  static const double defaultLongitude = 120.1551;

  /// 默认地图缩放级别
  static const double defaultZoom = 12.0;

  // ==================== 音频配置 ====================

  /// 支持的音频格式
  static const List<String> supportedAudioFormats = [
    'mp3',
    'aac',
    'm4a',
    'wav',
  ];

  /// 最大音频文件大小（MB）
  static const int maxAudioSizeMB = 50;

  /// 音频质量设置
  static const Map<int, String> audioQualitySettings = {
    0: '低质量 (64kbps)',
    1: '中质量 (128kbps)',
    2: '高质量 (256kbps)',
  };

  // ==================== 上传配置 ====================

  /// 最大上传重试次数
  static const int maxUploadRetries = 3;

  /// 上传超时时间（秒）
  static const int uploadTimeout = 120;

  // ==================== 缓存配置 ====================

  /// 缓存过期时间（天）
  static const int cacheExpiryDays = 7;

  /// 最大缓存大小（MB）
  static const int maxCacheSizeMB = 500;

  // ==================== 历史时期 ====================

  static const List<String> historicalPeriods = [
    '先秦',
    '秦汉',
    '魏晋',
    '隋唐',
    '宋元',
    '明代',
    '清代',
    '民国',
    '当代',
    '其他',
  ];

  // ==================== 情绪标签 ====================

  static const List<String> emotionTags = [
    '宁静',
    '欢快',
    '忧伤',
    '庄重',
    '神秘',
    '怀古',
    '激昂',
    '悠远',
  ];

  // ==================== 分类 ====================

  static const List<String> categories = ['全部', '历史声景', '当代实录', '我的创作'];

  // ==================== 排序选项 ====================

  static const Map<String, String> sortOptions = {
    'time': '按时间',
    'plays': '按播放量',
    'period': '按时期',
    'duration': '按时长',
  };

  // ==================== 语言选项 ====================

  static const List<String> languages = ['简体中文', '繁体中文', 'English'];

  // ==================== 用户协议 ====================

  static const String userAgreementUrl =
      'https://waterscapes.app/user-agreement';
  static const String privacyPolicyUrl =
      'https://waterscapes.app/privacy-policy';
  static const String helpUrl = 'https://waterscapes.app/help';

  // ==================== 应用信息 ====================

  static const String appName = '水上书';
  static const String appVersion = 'v2.0.0';
  static const String appDescription = '声景文化传承平台';
  static const String developerTeam = 'Canal App';

  // ==================== 社交分享 ====================

  static const String shareText = '我在《水上书》发现了一段美妙的历史声景，快来听听吧！';
  static const String shareUrl = 'https://waterscapes.app/share';
}
