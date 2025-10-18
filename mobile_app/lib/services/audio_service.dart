import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

/// 音频播放服务 - 管理声景音频的播放
class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  late AudioPlayer _player;
  String? _currentSoundscapeId;

  // 播放状态回调
  Function(bool)? onPlayingChanged;
  Function(Duration)? onPositionChanged;
  Function(Duration?)? onDurationChanged;
  Function()? onCompleted;

  /// 初始化音频播放器
  Future<void> init() async {
    _player = AudioPlayer();

    // 配置音频会话
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    // 监听播放状态
    _player.playingStream.listen((playing) {
      onPlayingChanged?.call(playing);
    });

    // 监听播放位置
    _player.positionStream.listen((position) {
      onPositionChanged?.call(position);
    });

    // 监听总时长
    _player.durationStream.listen((duration) {
      onDurationChanged?.call(duration);
    });

    // 监听播放完成
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        onCompleted?.call();
      }
    });
  }

  /// 播放声景
  Future<void> play(String url, {String? soundscapeId}) async {
    try {
      _currentSoundscapeId = soundscapeId;

      // 如果是同一个音频且已暂停，继续播放
      if (_player.playerState.processingState != ProcessingState.idle &&
          _player.audioSource?.toString().contains(url) == true) {
        await _player.play();
        return;
      }

      // 加载新音频
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      print('播放错误: $e');
      throw Exception('无法播放音频: $e');
    }
  }

  /// 播放本地文件
  Future<void> playLocal(String filePath, {String? soundscapeId}) async {
    try {
      _currentSoundscapeId = soundscapeId;
      await _player.setFilePath(filePath);
      await _player.play();
    } catch (e) {
      print('播放本地文件错误: $e');
      throw Exception('无法播放本地文件: $e');
    }
  }

  /// 暂停播放
  Future<void> pause() async {
    await _player.pause();
  }

  /// 恢复播放
  Future<void> resume() async {
    await _player.play();
  }

  /// 停止播放
  Future<void> stop() async {
    await _player.stop();
    _currentSoundscapeId = null;
  }

  /// 跳转到指定位置
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// 设置音量 (0.0 - 1.0)
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  /// 设置播放速度 (0.5 - 2.0)
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed.clamp(0.5, 2.0));
  }

  /// 获取当前播放状态
  bool get isPlaying => _player.playing;

  /// 获取当前位置
  Duration get currentPosition => _player.position;

  /// 获取总时长
  Duration? get duration => _player.duration;

  /// 获取当前播放的声景 ID
  String? get currentSoundscapeId => _currentSoundscapeId;

  /// 释放资源
  Future<void> dispose() async {
    await _player.dispose();
  }
}

/// 音频录制服务 - 管理声景的录制
class AudioRecorderService {
  static final AudioRecorderService _instance =
      AudioRecorderService._internal();
  factory AudioRecorderService() => _instance;
  AudioRecorderService._internal();

  bool _isRecording = false;
  String? _recordingPath;

  // 录制状态回调
  Function(bool)? onRecordingChanged;
  Function(Duration)? onDurationChanged;

  /// 初始化录音器
  Future<void> init() async {
    // TODO: 集成录音库 (如 record 或 flutter_sound)
    print('录音器初始化');
  }

  /// 开始录音
  Future<String> startRecording() async {
    // TODO: 实现实际的录音功能
    _isRecording = true;
    onRecordingChanged?.call(true);

    // 模拟录音路径
    _recordingPath =
        '/tmp/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
    print('开始录音: $_recordingPath');

    return _recordingPath!;
  }

  /// 停止录音
  Future<String?> stopRecording() async {
    // TODO: 实现实际的录音功能
    _isRecording = false;
    onRecordingChanged?.call(false);

    print('停止录音: $_recordingPath');
    return _recordingPath;
  }

  /// 取消录音
  Future<void> cancelRecording() async {
    // TODO: 实现实际的录音功能
    _isRecording = false;
    _recordingPath = null;
    onRecordingChanged?.call(false);

    print('取消录音');
  }

  /// 是否正在录音
  bool get isRecording => _isRecording;

  /// 获取录音文件路径
  String? get recordingPath => _recordingPath;
}
