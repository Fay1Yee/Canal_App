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
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        children: const [
          MapScreen(),
          _DiscoverScreen(),
          _CommunityScreen(),
          ProfileScreen(),
        ],
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
                icon: Icons.forum_outlined,
                activeIcon: Icons.forum,
                label: '社区',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: '我的',
                index: 3,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                fontSize: 12,
                color: isActive ? AppTheme.accentWhite : AppTheme.lightGray,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
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
      appBar: AppBar(
        title: const Text('发现声景'),
        backgroundColor: AppTheme.secondaryBlack,
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
            // 精选声景横向滚动
            const Text(
              '精选声景',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
                color: AppTheme.accentWhite,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  final soundscape = soundscapes[index * 3];
                  return _buildFeaturedCard(context, soundscape);
                },
              ),
            ),

            const SizedBox(height: 32),

            // 历史声景
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '历史声景',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.5,
                    color: AppTheme.accentWhite,
                  ),
                ),
                Text(
                  '共${historicalScapes.length}个',
                  style: TextStyle(fontSize: 14, color: AppTheme.lightGray),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...historicalScapes
                .take(5)
                .map((soundscape) => _buildSoundscapeItem(context, soundscape)),

            const SizedBox(height: 32),

            // 现代声景
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '现代声景',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.5,
                    color: AppTheme.accentWhite,
                  ),
                ),
                Text(
                  '共${modernScapes.length}个',
                  style: TextStyle(fontSize: 14, color: AppTheme.lightGray),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...modernScapes.map(
              (soundscape) => _buildSoundscapeItem(context, soundscape),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(
    BuildContext context,
    CanalSoundscapeData soundscape,
  ) {
    return GestureDetector(
      onTap: () => _navigateToPlayer(context, soundscape),
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppTheme.secondaryBlack,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片
            SizedBox(
              height: 140,
              width: double.infinity,
              child: Image.asset(
                soundscape.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.subtleGray,
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 48,
                        color: AppTheme.lightGray,
                      ),
                    ),
                  );
                },
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
                  Text(
                    '${soundscape.period} · ${soundscape.location}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.lightGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.subtleGray,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          soundscape.emotion,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.accentWhite,
                          ),
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

  Widget _buildSoundscapeItem(
    BuildContext context,
    CanalSoundscapeData soundscape,
  ) {
    return GestureDetector(
      onTap: () => _navigateToPlayer(context, soundscape),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.secondaryBlack,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppTheme.subtleGray, width: 0.5),
        ),
        child: Row(
          children: [
            // 缩略图
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                soundscape.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: AppTheme.subtleGray,
                    child: const Icon(
                      Icons.image,
                      size: 30,
                      color: AppTheme.lightGray,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            // 信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    soundscape.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accentWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${soundscape.period} · ${soundscape.location}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.lightGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    soundscape.poem,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.inkLight,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 播放按钮
            const Icon(
              Icons.play_circle_outline,
              color: AppTheme.accentWhite,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPlayer(BuildContext context, CanalSoundscapeData soundscape) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerScreen(soundscape: soundscape.toMap()),
      ),
    );
  }
}

/// 社区页面
class _CommunityScreen extends StatelessWidget {
  const _CommunityScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('社区讨论'),
        backgroundColor: AppTheme.secondaryBlack,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // TODO: 发布动态
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 在线人数
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.secondaryBlack,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.subtleGray, width: 0.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '1247人在线',
                    style: TextStyle(fontSize: 14, color: AppTheme.accentWhite),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 热门讨论
            const Text(
              '热门讨论',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
                color: AppTheme.accentWhite,
              ),
            ),
            const SizedBox(height: 16),
            _buildDiscussionItem(
              avatar: '文',
              username: '文人墨客',
              time: '2小时前',
              content: '扬州二十四桥的夜景真是美不胜收，月色如水，箫声悠扬...',
              likes: 156,
              comments: 42,
            ),
            _buildDiscussionItem(
              avatar: '声',
              username: '声景爱好者',
              time: '5小时前',
              content: '刚去了杭州拱宸桥，千年运河的终点，感受到了历史的厚重...',
              likes: 98,
              comments: 23,
            ),
            _buildDiscussionItem(
              avatar: '运',
              username: '运河守护者',
              time: '1天前',
              content: '京杭大运河是中国古代劳动人民创造的伟大工程，值得我们好好保护...',
              likes: 234,
              comments: 67,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscussionItem({
    required String avatar,
    required String username,
    required String time,
    required String content,
    required int likes,
    required int comments,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryBlack,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppTheme.subtleGray, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.subtleGray,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    avatar,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppTheme.accentWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.accentWhite,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.lightGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 内容
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.accentWhite,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          // 互动按钮
          Row(
            children: [
              _buildActionButton(Icons.favorite_border, likes.toString()),
              const SizedBox(width: 24),
              _buildActionButton(
                Icons.chat_bubble_outline,
                comments.toString(),
              ),
              const SizedBox(width: 24),
              _buildActionButton(Icons.share_outlined, '分享'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppTheme.lightGray),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.lightGray),
        ),
      ],
    );
  }
}
