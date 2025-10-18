import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/canal_soundscape_data.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: IndexedStack(
        index: _currentIndex,
        children: const [MapScreen(), _DiscoverScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryBlack,
        border: Border(top: BorderSide(color: AppTheme.subtleGray, width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.map_outlined,
                activeIcon: Icons.map,
                label: '地图',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.explore_outlined,
                activeIcon: Icons.explore,
                label: '发现',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: '我的',
                index: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppTheme.accentWhite : AppTheme.lightGray,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.accentWhite : AppTheme.lightGray,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 发现页面
class _DiscoverScreen extends StatelessWidget {
  const _DiscoverScreen();

  @override
  Widget build(BuildContext context) {
    final soundscapes = CanalSoundscapeDataset.soundscapes;
    final historicalScapes = soundscapes.where((s) => s.isHistorical).toList();
    final modernScapes = soundscapes.where((s) => !s.isHistorical).toList();

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.secondaryBlack,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                '发现声景',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.0,
                  color: AppTheme.accentWhite,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: AppTheme.accentWhite),
                onPressed: () {
                  // TODO: 实现搜索功能
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // 精选声景横向滚动
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Color(0xFFFFD700), size: 20),
                      SizedBox(width: 8),
                      Text(
                        '精选声景',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: AppTheme.accentWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final soundscape = soundscapes[index * 4];
                      return _buildFeaturedCard(context, soundscape);
                    },
                  ),
                ),
              ],
            ),
          ),

          // 历史声景
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.history_edu,
                        color: AppTheme.inkLight,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '历史声景',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: AppTheme.accentWhite,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '共${historicalScapes.length}个',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.lightGray,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 历史声景列表
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildSoundscapeItem(context, historicalScapes[index]);
              }, childCount: historicalScapes.length),
            ),
          ),

          // 现代声景
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.location_city,
                        color: AppTheme.inkLight,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '现代声景',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          color: AppTheme.accentWhite,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '共${modernScapes.length}个',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.lightGray,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 现代声景列表
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildSoundscapeItem(context, modernScapes[index]);
              }, childCount: modernScapes.length),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建精选声景卡片
  Widget _buildFeaturedCard(
    BuildContext context,
    CanalSoundscapeData soundscape,
  ) {
    return GestureDetector(
      onTap: () => _navigateToPlayer(context, soundscape),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppTheme.secondaryBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.subtleGray, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 配图
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: Image.asset(
                  soundscape.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.subtleGray,
                      child: const Center(
                        child: Icon(
                          Icons.landscape,
                          size: 48,
                          color: AppTheme.lightGray,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // 信息
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    soundscape.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accentWhite,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.inkLight.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          soundscape.period,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.inkLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: AppTheme.lightGray,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          soundscape.location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.lightGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建声景列表项
  Widget _buildSoundscapeItem(
    BuildContext context,
    CanalSoundscapeData soundscape,
  ) {
    return GestureDetector(
      onTap: () => _navigateToPlayer(context, soundscape),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.secondaryBlack,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.subtleGray, width: 0.5),
        ),
        child: Row(
          children: [
            // 缩略图
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(8),
              ),
              child: Image.asset(
                soundscape.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: AppTheme.subtleGray,
                    child: const Icon(
                      Icons.landscape,
                      size: 32,
                      color: AppTheme.lightGray,
                    ),
                  );
                },
              ),
            ),
            // 信息
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      soundscape.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.accentWhite,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      soundscape.poem,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.lightGray.withValues(alpha: 0.9),
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.inkLight.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            soundscape.period,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.inkLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getEmotionColor(
                              soundscape.emotion,
                            ).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            soundscape.emotion,
                            style: TextStyle(
                              fontSize: 10,
                              color: _getEmotionColor(soundscape.emotion),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // 播放按钮
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.play_circle_outline,
                size: 32,
                color: AppTheme.accentWhite.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 根据情感获取颜色
  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case '繁忙':
        return Colors.orange;
      case '热闹':
        return Colors.red;
      case '宁静':
        return Colors.blue;
      case '悠扬':
        return Colors.purple;
      case '激昂':
        return Colors.amber;
      case '凄美':
        return Colors.cyan;
      case '祥和':
        return Colors.green;
      case '活力':
        return Colors.lime;
      case '欢快':
        return Colors.pink;
      case '繁华':
        return Colors.deepOrange;
      default:
        return AppTheme.inkLight;
    }
  }

  /// 导航到播放页面
  void _navigateToPlayer(BuildContext context, CanalSoundscapeData soundscape) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerScreen(soundscape: soundscape.toJson()),
      ),
    );
  }
}
