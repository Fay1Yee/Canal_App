import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ink_style_components.dart';
import '../widgets/ink_painting_background.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _selectedCategory = '全部';
  final List<String> _categories = ['全部', '历史声景', '当代实录', '我的上传'];

  // 模拟收藏数据
  final List<Map<String, dynamic>> _favorites = [
    {
      'title': '唐代扬州夜雨',
      'period': '唐代',
      'location': '扬州',
      'duration': '3:24',
      'favoriteTime': '昨天',
      'isHistorical': true,
    },
    {
      'title': '宋代杭州晨钟',
      'period': '宋代',
      'location': '杭州',
      'duration': '4:12',
      'favoriteTime': '2天前',
      'isHistorical': true,
    },
    {
      'title': '现代上海外滩',
      'period': '现代',
      'location': '上海',
      'duration': '5:30',
      'favoriteTime': '1周前',
      'isHistorical': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('我的收藏'),
        actions: [
          IconButton(icon: const Icon(Icons.sort), onPressed: _showSortOptions),
        ],
      ),
      body: InkPaintingBackground(
        child: Column(
          children: [
            // 分类筛选
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkStyleComponents.inkTag(
                        text: category,
                        backgroundColor: isSelected
                            ? AppTheme.accentWhite
                            : AppTheme.secondaryBlack,
                        textColor: isSelected
                            ? AppTheme.primaryBlack
                            : AppTheme.accentWhite,
                        onTap: () =>
                            setState(() => _selectedCategory = category),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 统计信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: AppTheme.inkLight,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '共 ${_favorites.length} 个收藏',
                    style: const TextStyle(
                      color: AppTheme.inkLight,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 收藏列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  final favorite = _favorites[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildFavoriteItem(favorite),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(Map<String, dynamic> favorite) {
    return InkStyleComponents.inkCard(
      child: Row(
        children: [
          // 墨点标记
          InkStyleComponents.inkDot(
            size: 50,
            onTap: () => _playSound(favorite),
            period: favorite['period'].substring(0, 1),
          ),
          const SizedBox(width: 16),

          // 信息区域
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  favorite['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ParameterLabel(
                      parameter: 'Period',
                      value: favorite['period'],
                      showLine: false,
                    ),
                    const SizedBox(width: 16),
                    ParameterLabel(
                      parameter: 'Duration',
                      value: favorite['duration'],
                      showLine: false,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '收藏于 ${favorite['favoriteTime']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.inkLight,
                  ),
                ),
              ],
            ),
          ),

          // 操作按钮
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.play_circle_outline, size: 28),
                color: AppTheme.accentWhite,
                onPressed: () => _playSound(favorite),
              ),
              IconButton(
                icon: const Icon(Icons.favorite, size: 20),
                color: Colors.red,
                onPressed: () => _removeFavorite(favorite),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSortOptions() {
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
            const Text(
              '排序方式',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            _buildSortOption('收藏时间', Icons.access_time),
            _buildSortOption('播放次数', Icons.play_circle_outline),
            _buildSortOption('声景时期', Icons.history),
            _buildSortOption('声景时长', Icons.timer),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String text, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        // TODO: 实现排序
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.accentWhite, size: 20),
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

  void _playSound(Map<String, dynamic> soundscape) {
    // TODO: 实现播放功能
    print('播放: ${soundscape['title']}');
  }

  void _removeFavorite(Map<String, dynamic> favorite) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBlack,
        title: const Text('取消收藏'),
        content: Text('确定要取消收藏《${favorite['title']}》吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          InkStyleComponents.inkButton(
            text: '确定',
            onPressed: () {
              setState(() {
                _favorites.remove(favorite);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
