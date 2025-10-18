import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

/// API 服务类 - 统一管理后端接口调用
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _authToken;

  /// 初始化 API 服务
  Future<void> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: Duration(seconds: AppConfig.apiTimeout),
        receiveTimeout: Duration(seconds: AppConfig.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 自动添加认证 token
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          print('API 请求错误: ${error.message}');
          return handler.next(error);
        },
      ),
    );

    // 加载保存的 token
    await _loadToken();
  }

  /// 加载保存的 token
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
  }

  /// 保存 token
  Future<void> _saveToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// 清除 token
  Future<void> clearToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // ==================== 用户相关 API ====================

  /// 用户登录
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.data['token'] != null) {
        await _saveToken(response.data['token']);
      }

      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取用户信息
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _dio.get('/user/profile');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 更新用户信息
  Future<Map<String, dynamic>> updateUserProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put('/user/profile', data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== 声景相关 API ====================

  /// 获取声景列表
  Future<List<Map<String, dynamic>>> getSoundscapes({
    String? period,
    String? emotion,
    String? keyword,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/soundscapes',
        queryParameters: {
          if (period != null) 'period': period,
          if (emotion != null) 'emotion': emotion,
          if (keyword != null) 'keyword': keyword,
          'page': page,
          'limit': limit,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取声景详情
  Future<Map<String, dynamic>> getSoundscapeDetail(String id) async {
    try {
      final response = await _dio.get('/soundscapes/$id');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 上传声景
  Future<Map<String, dynamic>> uploadSoundscape({
    required String audioPath,
    required String title,
    required String period,
    required String location,
    required List<String> emotions,
    String? poem,
    double? latitude,
    double? longitude,
  }) async {
    try {
      // 创建 FormData
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(audioPath),
        'title': title,
        'period': period,
        'location': location,
        'emotions': emotions.join(','),
        if (poem != null) 'poem': poem,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      });

      final response = await _dio.post('/soundscapes', data: formData);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 收藏声景
  Future<void> favoriteSoundscape(String id) async {
    try {
      await _dio.post('/soundscapes/$id/favorite');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 取消收藏
  Future<void> unfavoriteSoundscape(String id) async {
    try {
      await _dio.delete('/soundscapes/$id/favorite');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取收藏列表
  Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final response = await _dio.get('/user/favorites');
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取我的声景
  Future<List<Map<String, dynamic>>> getMySoundscapes() async {
    try {
      final response = await _dio.get('/user/soundscapes');
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 播放记录
  Future<void> recordPlayback(String id) async {
    try {
      await _dio.post('/soundscapes/$id/play');
    } catch (e) {
      // 播放记录失败不影响用户体验
      print('记录播放失败: $e');
    }
  }

  // ==================== 统计相关 API ====================

  /// 获取用户统计
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await _dio.get('/user/stats');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取推荐声景
  Future<List<Map<String, dynamic>>> getRecommendations() async {
    try {
      final response = await _dio.get('/soundscapes/recommended');
      return List<Map<String, dynamic>>.from(response.data ?? []);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== 错误处理 ====================

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('网络连接超时，请检查网络设置');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data['message'] ?? '请求失败';
          return Exception('错误 $statusCode: $message');
        case DioExceptionType.cancel:
          return Exception('请求已取消');
        default:
          return Exception('网络错误: ${error.message}');
      }
    }
    return Exception('未知错误: $error');
  }
}
