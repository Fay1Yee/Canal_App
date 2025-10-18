import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ink_style_components.dart';
import '../widgets/ink_painting_background.dart';
import 'upload_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: InkPaintingBackground(
        child: GeometricGridBackground(
          showGrid: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 用户信息卡片
                InkStyleComponents.inkCard(
                  child: Column(
                    children: [
                      // 头像
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.inkGradient,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: AppTheme.accentWhite,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 用户名
                      const Text(
                        '墨客001',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // 用户等级
                      InkStyleComponents.inkTag(
                        text: '文化遗产贡献者',
                        backgroundColor: AppTheme.accentWhite,
                        textColor: AppTheme.primaryBlack,
                      ),
                      const SizedBox(height: 16),

                      // 统计信息
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('上传', '12'),
                          _buildStatItem('收藏', '28'),
                          _buildStatItem('积分', '1560'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 我的声景
                InkStyleComponents.inkCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '我的声景',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMySoundscapeItem(
                        title: '唐代扬州夜雨',
                        period: '唐代',
                        status: '已发布',
                        uploadTime: '2天前',
                      ),
                      InkStyleComponents.inkDivider(),
                      _buildMySoundscapeItem(
                        title: '宋代杭州晨钟',
                        period: '宋代',
                        status: '审核中',
                        uploadTime: '1周前',
                      ),
                      InkStyleComponents.inkDivider(),
                      _buildMySoundscapeItem(
                        title: '明代苏州园林',
                        period: '明代',
                        status: '已发布',
                        uploadTime: '2周前',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 成就徽章
                InkStyleComponents.inkCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '成就徽章',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildAchievementBadge(
                            icon: Icons.history,
                            title: '历史探索者',
                            description: '上传5个历史声景',
                            isUnlocked: true,
                          ),
                          _buildAchievementBadge(
                            icon: Icons.favorite,
                            title: '声景收藏家',
                            description: '收藏20个声景',
                            isUnlocked: true,
                          ),
                          _buildAchievementBadge(
                            icon: Icons.star,
                            title: '文化传承者',
                            description: '获得1000积分',
                            isUnlocked: true,
                          ),
                          _buildAchievementBadge(
                            icon: Icons.people,
                            title: '社区贡献者',
                            description: '帮助10位用户',
                            isUnlocked: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 功能菜单
                InkStyleComponents.inkCard(
                  child: Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.upload,
                        title: '上传声景',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UploadScreen(),
                            ),
                          );
                        },
                      ),
                      InkStyleComponents.inkDivider(),
                      _buildMenuItem(
                        icon: Icons.favorite,
                        title: '我的收藏',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FavoritesScreen(),
                            ),
                          );
                        },
                      ),
                      InkStyleComponents.inkDivider(),
                      _buildMenuItem(
                        icon: Icons.history,
                        title: '播放历史',
                        onTap: () {},
                      ),
                      InkStyleComponents.inkDivider(),
                      _buildMenuItem(
                        icon: Icons.share,
                        title: '分享应用',
                        onTap: () {},
                      ),
                      InkStyleComponents.inkDivider(),
                      _buildMenuItem(
                        icon: Icons.help,
                        title: '帮助与反馈',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: AppTheme.accentWhite,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.inkLight),
        ),
      ],
    );
  }

  Widget _buildMySoundscapeItem({
    required String title,
    required String period,
    required String status,
    required String uploadTime,
  }) {
    Color statusColor;
    switch (status) {
      case '已发布':
        statusColor = AppTheme.accentWhite;
        break;
      case '审核中':
        statusColor = Colors.orange;
        break;
      case '已拒绝':
        statusColor = Colors.red;
        break;
      default:
        statusColor = AppTheme.inkLight;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          InkStyleComponents.inkDot(
            size: 32,
            onTap: () {},
            period: period.substring(0, 1),
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
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$period · $uploadTime',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.inkLight,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: statusColor, width: 0.5),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          color: statusColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: AppTheme.inkLight, size: 20),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge({
    required IconData icon,
    required String title,
    required String description,
    required bool isUnlocked,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppTheme.secondaryBlack
            : AppTheme.subtleGray.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isUnlocked ? AppTheme.accentWhite : AppTheme.subtleGray,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isUnlocked ? AppTheme.accentWhite : AppTheme.lightGray,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isUnlocked ? AppTheme.accentWhite : AppTheme.lightGray,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 10,
              color: isUnlocked ? AppTheme.inkLight : AppTheme.lightGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.accentWhite, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.inkLight, size: 20),
          ],
        ),
      ),
    );
  }
}
