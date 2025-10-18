import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import '../widgets/ink_style_components.dart';
import '../widgets/ink_painting_background.dart';
import '../widgets/osm_ink_map_widget.dart';
import '../models/canal_soundscape_data.dart';
import 'search_screen.dart';
import 'upload_screen.dart';
import 'player_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('水上书'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UploadScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 京杭大运河水墨地图
          OsmInkMapWidget(
            markers: CanalSoundscapeDataset.soundscapes.map((soundscape) {
              return SoundscapeMarker(
                id: soundscape.id,
                title: soundscape.title,
                period: soundscape.period,
                position: LatLng(soundscape.latitude, soundscape.longitude),
                onTap: () => _showCanalSoundscapeDetail(soundscape),
              );
            }).toList(),
            onMapClick: (latLng) {
              // 点击地图显示附近的声景信息
              _showNearBySoundscapes(latLng);
            },
          ),

          // 底部控制面板
          _buildBottomPanel(),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.secondaryBlack,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(color: AppTheme.subtleGray, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 拖拽指示器
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // 统计信息
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('历史声景', '12', Icons.history),
                    _buildStatItem('当代实录', '8', Icons.mic),
                    _buildStatItem('我的收藏', '5', Icons.favorite),
                  ],
                ),

                const SizedBox(height: 16),

                // 快速操作按钮
                Row(
                  children: [
                    Expanded(
                      child: InkStyleComponents.inkButton(
                        text: '上传声景',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UploadScreen(),
                            ),
                          );
                        },
                        icon: Icons.upload,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkStyleComponents.inkButton(
                        text: '开始探索',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          );
                        },
                        isPrimary: false,
                        icon: Icons.explore,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return CircularDataWidget(
      label: label,
      value: value,
      progress: 0.75,
      size: 80,
    );
  }

  // 显示附近声景信息
  void _showNearBySoundscapes(LatLng latLng) {
    // 查找附近5公里内的声景
    final nearbySoundscapes = CanalSoundscapeDataset.soundscapes.where((s) {
      final distance = _calculateDistance(
        latLng.latitude,
        latLng.longitude,
        s.latitude,
        s.longitude,
      );
      return distance < 50; // 50公里范围内
    }).toList();

    if (nearbySoundscapes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('此处暂无声景'), backgroundColor: AppTheme.inkDark),
      );
      return;
    }

    // 显示第一个声景的详情
    _showCanalSoundscapeDetail(nearbySoundscapes.first);
  }

  // 计算两点距离（简化版）
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return ((lat1 - lat2).abs() + (lon1 - lon2).abs()) * 111; // 粗略估算，单位km
  }

  // 显示京杭大运河声景详情（新版）
  void _showCanalSoundscapeDetail(CanalSoundscapeData soundscape) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: AppTheme.paperWhite,
          body: InkPaintingBackground(
            child: CustomScrollView(
              slivers: [
                // 水墨画头图
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: AppTheme.inkDark.withValues(alpha: 0.9),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 水墨画背景
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppTheme.inkDark,
                                AppTheme.inkGray.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.landscape,
                              size: 120,
                              color: AppTheme.paperWhite.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                        // 渐变遮罩
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 100,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppTheme.inkDark.withValues(alpha: 0.9),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // 标题信息
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                soundscape.title,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.paperWhite,
                                  letterSpacing: 2.0,
                                  shadows: [
                                    Shadow(
                                      color: AppTheme.inkBlack.withValues(
                                        alpha: 0.8,
                                      ),
                                      offset: const Offset(2, 2),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  InkStyleComponents.inkTag(
                                    text: soundscape.period,
                                  ),
                                  const SizedBox(width: 8),
                                  InkStyleComponents.inkTag(
                                    text: soundscape.location,
                                  ),
                                  const SizedBox(width: 8),
                                  InkStyleComponents.inkTag(
                                    text: soundscape.emotion,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 内容区域
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // 描述
                      InkStyleComponents.inkCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.auto_stories,
                                  color: AppTheme.inkDark,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '声景描述',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.inkDark,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              soundscape.description,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppTheme.inkGray,
                                height: 1.8,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 诗词
                      InkStyleComponents.inkCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.format_quote,
                                  color: AppTheme.accentRed,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '诗词',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.inkDark,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '— ${soundscape.poemAuthor}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.inkLight,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppTheme.paperCream.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.inkFaint,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                soundscape.poem,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppTheme.inkBlack,
                                  height: 2.0,
                                  letterSpacing: 4.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 播放按钮
                      InkStyleComponents.inkButton(
                        text: '播放声景',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerScreen(
                                soundscape: {
                                  'title': soundscape.title,
                                  'period': soundscape.period,
                                  'location': soundscape.location,
                                  'emotion': soundscape.emotion,
                                  'poem': soundscape.poem,
                                  'poemAuthor': soundscape.poemAuthor,
                                  'description': soundscape.description,
                                  'audioUrl': soundscape.audioUrl,
                                  'imageUrl': soundscape.imageUrl,
                                },
                              ),
                            ),
                          );
                        },
                        icon: Icons.play_circle_outline,
                      ),

                      const SizedBox(height: 20),

                      // 位置信息
                      InkStyleComponents.inkCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppTheme.inkDark,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '地理位置',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.inkDark,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '经度: ${soundscape.longitude.toStringAsFixed(4)}°',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.inkGray,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '纬度: ${soundscape.latitude.toStringAsFixed(4)}°',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppTheme.inkGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  soundscape.isHistorical
                                      ? Icons.history
                                      : Icons.schedule,
                                  color: soundscape.isHistorical
                                      ? AppTheme.accentGold
                                      : AppTheme.accentRed,
                                  size: 48,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
