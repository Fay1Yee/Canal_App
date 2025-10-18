import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ink_style_components.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverScreen extends StatelessWidget {
  const _DiscoverScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('发现声景'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 实现搜索功能
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 推荐声景
            InkStyleComponents.inkCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '今日推荐',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRecommendedItem(
                    title: '唐代扬州夜雨',
                    period: '唐代',
                    location: '扬州',
                    emotion: '宁静',
                  ),
                  const SizedBox(height: 12),
                  _buildRecommendedItem(
                    title: '宋代杭州晨钟',
                    period: '宋代',
                    location: '杭州',
                    emotion: '庄严',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 热门标签
            const Text(
              '热门标签',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                InkStyleComponents.inkTag(text: '唐代'),
                InkStyleComponents.inkTag(text: '宋代'),
                InkStyleComponents.inkTag(text: '宁静'),
                InkStyleComponents.inkTag(text: '怀古'),
                InkStyleComponents.inkTag(text: '扬州'),
                InkStyleComponents.inkTag(text: '杭州'),
              ],
            ),

            const SizedBox(height: 24),

            // 最新上传
            InkStyleComponents.inkCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '最新上传',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRecentItem(
                    title: '明代苏州园林',
                    uploader: '墨客001',
                    time: '2小时前',
                  ),
                  InkStyleComponents.inkDivider(),
                  _buildRecentItem(
                    title: '清代北京胡同',
                    uploader: '声景师',
                    time: '5小时前',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedItem({
    required String title,
    required String period,
    required String location,
    required String emotion,
  }) {
    return InkStyleComponents.inkCard(
      onTap: () {
        // TODO: 播放声景
      },
      child: Row(
        children: [
          InkStyleComponents.inkDot(
            size: 40,
            onTap: () {},
            period: period.substring(0, 1),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$location · $emotion',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.inkLight,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.play_circle_outline,
            color: AppTheme.accentWhite,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItem({
    required String title,
    required String uploader,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.accentWhite,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '$uploader · $time',
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
    );
  }
}
