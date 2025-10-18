import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import '../widgets/ink_style_components.dart';
import '../widgets/ink_painting_background.dart';
import '../services/audio_service.dart';
import '../services/api_service.dart';

class PlayerScreen extends StatefulWidget {
  final Map<String, dynamic> soundscape;

  const PlayerScreen({super.key, required this.soundscape});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  double _totalDuration = 204.0; // 3:24 in seconds
  bool _isFavorite = false;

  late AnimationController _rotationController;
  final AudioPlayerService _audioPlayer = AudioPlayerService();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _initializeAudio();
  }

  void _initializeAudio() {
    // 监听播放状态
    _audioPlayer.onPlayingChanged = (playing) {
      if (mounted) {
        setState(() {
          _isPlaying = playing;
          if (playing) {
            _rotationController.repeat();
          } else {
            _rotationController.stop();
          }
        });
      }
    };

    // 监听播放位置
    _audioPlayer.onPositionChanged = (position) {
      if (mounted) {
        setState(() {
          _currentPosition = position.inSeconds.toDouble();
        });
      }
    };

    // 监听总时长
    _audioPlayer.onDurationChanged = (duration) {
      if (mounted && duration != null) {
        setState(() {
          _totalDuration = duration.inSeconds.toDouble();
        });
      }
    };

    // 监听播放完成
    _audioPlayer.onCompleted = () {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentPosition = 0.0;
        });
      }
    };

    // 如果有音频 URL，开始播放
    final audioUrl = widget.soundscape['audioUrl'];
    if (audioUrl != null) {
      _audioPlayer.play(audioUrl, soundscapeId: widget.soundscape['id']);

      // 记录播放
      if (widget.soundscape['id'] != null) {
        _apiService.recordPlayback(widget.soundscape['id']);
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    // 不要在这里 dispose AudioPlayerService，它是单例
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: Stack(
        children: [
          // 背景配图（模糊效果）
          Positioned.fill(
            child: widget.soundscape['imageUrl'] != null
                ? Image.asset(
                    widget.soundscape['imageUrl'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: AppTheme.primaryBlack);
                    },
                  )
                : Container(color: AppTheme.primaryBlack),
          ),
          // 渐变遮罩
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryBlack.withValues(alpha: 0.7),
                    AppTheme.primaryBlack.withValues(alpha: 0.95),
                    AppTheme.primaryBlack,
                  ],
                ),
              ),
            ),
          ),
          // 内容
          SafeArea(
            child: Column(
              children: [
                // 顶部栏
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryBlack.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down, size: 28),
                          color: AppTheme.accentWhite,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryBlack.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.more_vert),
                          color: AppTheme.accentWhite,
                          onPressed: _showMoreOptions,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 主配图（圆形）
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: widget.soundscape['imageUrl'] != null
                        ? Image.asset(
                            widget.soundscape['imageUrl'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.subtleGray,
                                child: const Icon(
                                  Icons.landscape,
                                  size: 80,
                                  color: AppTheme.lightGray,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: AppTheme.subtleGray,
                            child: const Icon(
                              Icons.landscape,
                              size: 80,
                              color: AppTheme.lightGray,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 40),

                // 声景信息
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        widget.soundscape['title'] ?? '唐代扬州夜雨',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                          color: AppTheme.accentWhite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // 诗词
                      if (widget.soundscape['poem'] != null)
                        Text(
                          widget.soundscape['poem'],
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.lightGray.withValues(alpha: 0.9),
                            fontStyle: FontStyle.italic,
                            height: 1.6,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.inkLight.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.inkLight.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.soundscape['period'] ?? '唐代',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.inkLight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.inkLight.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.inkLight.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: AppTheme.inkLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.soundscape['location'] ?? '扬州',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.inkLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 进度条
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: AppTheme.accentWhite,
                          inactiveTrackColor: AppTheme.subtleGray,
                          thumbColor: AppTheme.accentWhite,
                          overlayColor: AppTheme.accentWhite.withValues(
                            alpha: 0.2,
                          ),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          trackHeight: 2,
                        ),
                        child: Slider(
                          value: _currentPosition,
                          min: 0,
                          max: _totalDuration,
                          onChanged: (value) {
                            setState(() => _currentPosition = value);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_currentPosition),
                            style: const TextStyle(
                              color: AppTheme.inkLight,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _formatDuration(_totalDuration),
                            style: const TextStyle(
                              color: AppTheme.inkLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 控制按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 收藏按钮
                      _buildControlButton(
                        icon: _isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        onPressed: () =>
                            setState(() => _isFavorite = !_isFavorite),
                        size: 28,
                      ),

                      // 上一曲
                      _buildControlButton(
                        icon: Icons.skip_previous,
                        onPressed: () {},
                        size: 32,
                      ),

                      // 播放/暂停
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.inkGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.inkBlack.withValues(alpha: 0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 36,
                          ),
                          color: AppTheme.accentWhite,
                          onPressed: _togglePlay,
                        ),
                      ),

                      // 下一曲
                      _buildControlButton(
                        icon: Icons.skip_next,
                        onPressed: () {},
                        size: 32,
                      ),

                      // 分享按钮
                      _buildControlButton(
                        icon: Icons.share,
                        onPressed: _shareSound,
                        size: 28,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 诗词卡片
                if (widget.soundscape['poem'] != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: InkStyleComponents.inkCard(
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.format_quote,
                                color: AppTheme.inkLight,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '收尾诗',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.inkLight,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          PoemTextWidget(
                            poem:
                                widget.soundscape['poem'] ??
                                '夜雨扬州巷，墨香染诗篇。\n古韵今犹在，声景忆当年。',
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInkDotVisualization() {
    return SizedBox(
      width: 200,
      height: 200,
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // 背景圆环
              CustomPaint(
                size: const Size(200, 200),
                painter: WaveCirclePainter(
                  progress: _currentPosition / _totalDuration,
                  isPlaying: _isPlaying,
                  animationValue: _rotationController.value,
                ),
              ),

              // 中央墨点
              InkStyleComponents.inkDot(
                size: 120,
                onTap: _togglePlay,
                isActive: _isPlaying,
                period: widget.soundscape['period']?.substring(0, 1) ?? '唐',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required double size,
  }) {
    return IconButton(
      icon: Icon(icon, size: size),
      color: AppTheme.accentWhite,
      onPressed: onPressed,
    );
  }

  void _togglePlay() async {
    if (_audioPlayer.isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  String _formatDuration(double seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(1, '0');
    final secs = (seconds % 60).toInt().toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.secondaryBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption('查看详情', Icons.info_outline, () {}),
            _buildOption('添加到播放列表', Icons.playlist_add, () {}),
            _buildOption('下载到本地', Icons.download, () {}),
            _buildOption('举报', Icons.report_outlined, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.accentWhite, size: 24),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  void _shareSound() {
    // TODO: 实现分享功能
    print('分享声景');
  }
}

/// 波纹圆环画家
class WaveCirclePainter extends CustomPainter {
  final double progress;
  final bool isPlaying;
  final double animationValue;

  WaveCirclePainter({
    required this.progress,
    required this.isPlaying,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 绘制进度圆环
    final progressPaint = Paint()
      ..color = AppTheme.accentWhite
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // 如果正在播放，绘制动画波纹
    if (isPlaying) {
      for (int i = 0; i < 3; i++) {
        final waveRadius = radius - 20 + (animationValue + i * 0.33) % 1.0 * 30;
        final waveOpacity = 1.0 - (animationValue + i * 0.33) % 1.0;

        final wavePaint = Paint()
          ..color = AppTheme.accentWhite.withValues(alpha: waveOpacity * 0.3)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

        canvas.drawCircle(center, waveRadius, wavePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant WaveCirclePainter oldDelegate) {
    return progress != oldDelegate.progress ||
        isPlaying != oldDelegate.isPlaying ||
        animationValue != oldDelegate.animationValue;
  }
}
