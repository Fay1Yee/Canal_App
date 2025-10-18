import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ink_style_components.dart';
import '../widgets/ink_painting_background.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedPeriod = '全部';
  String _selectedEmotion = '全部';

  final List<String> _periods = [
    '全部',
    '先秦',
    '秦汉',
    '魏晋',
    '隋唐',
    '宋',
    '元',
    '明',
    '清',
    '近现代',
  ];
  final List<String> _emotions = [
    '全部',
    '宁静',
    '怀古',
    '庄严',
    '雅致',
    '繁华',
    '忧伤',
    '欢快',
  ];

  // 模拟搜索结果
  final List<Map<String, String>> _searchResults = [
    {'title': '唐代扬州夜雨', 'period': '唐代', 'location': '扬州', 'emotion': '宁静'},
    {'title': '宋代杭州晨钟', 'period': '宋代', 'location': '杭州', 'emotion': '庄严'},
    {'title': '明代苏州园林', 'period': '明代', 'location': '苏州', 'emotion': '雅致'},
    {'title': '清代北京胡同', 'period': '清代', 'location': '北京', 'emotion': '怀古'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(title: const Text('搜索声景')),
      body: InkPaintingBackground(
        child: Column(
          children: [
            // 搜索栏
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryBlack,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppTheme.subtleGray),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: AppTheme.accentWhite),
                        decoration: const InputDecoration(
                          hintText: '搜索声景、地点、时期...',
                          hintStyle: TextStyle(color: AppTheme.lightGray),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppTheme.inkLight,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (value) => _performSearch(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkStyleComponents.inkButton(
                    text: '搜索',
                    onPressed: _performSearch,
                    icon: Icons.search,
                  ),
                ],
              ),
            ),

            // 筛选条件
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 时期筛选
                  const Text(
                    '历史时期',
                    style: TextStyle(
                      color: AppTheme.accentWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _periods.length,
                      itemBuilder: (context, index) {
                        final period = _periods[index];
                        final isSelected = period == _selectedPeriod;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkStyleComponents.inkTag(
                            text: period,
                            backgroundColor: isSelected
                                ? AppTheme.accentWhite
                                : AppTheme.secondaryBlack,
                            textColor: isSelected
                                ? AppTheme.primaryBlack
                                : AppTheme.accentWhite,
                            onTap: () =>
                                setState(() => _selectedPeriod = period),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 情绪筛选
                  const Text(
                    '情绪标签',
                    style: TextStyle(
                      color: AppTheme.accentWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _emotions.length,
                      itemBuilder: (context, index) {
                        final emotion = _emotions[index];
                        final isSelected = emotion == _selectedEmotion;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkStyleComponents.inkTag(
                            text: emotion,
                            backgroundColor: isSelected
                                ? AppTheme.accentWhite
                                : AppTheme.secondaryBlack,
                            textColor: isSelected
                                ? AppTheme.primaryBlack
                                : AppTheme.accentWhite,
                            onTap: () =>
                                setState(() => _selectedEmotion = emotion),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            InkStyleComponents.inkDivider(),
            const SizedBox(height: 16),

            // 搜索结果
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkStyleComponents.inkCard(
                      onTap: () => _showSoundscapeDetail(result),
                      child: Row(
                        children: [
                          InkStyleComponents.inkDot(
                            size: 50,
                            onTap: () {},
                            period: result['period']!.substring(0, 1),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result['title']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    ParameterLabel(
                                      parameter: 'Period',
                                      value: result['period']!,
                                      showLine: false,
                                    ),
                                    const SizedBox(width: 16),
                                    ParameterLabel(
                                      parameter: 'Location',
                                      value: result['location']!,
                                      showLine: false,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppTheme.inkLight,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch() {
    // TODO: 实现搜索逻辑
    print('搜索: ${_searchController.text}');
    print('时期: $_selectedPeriod');
    print('情绪: $_selectedEmotion');
  }

  void _showSoundscapeDetail(Map<String, String> soundscape) {
    // TODO: 显示声景详情
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBlack,
        title: Text(soundscape['title']!),
        content: Text('${soundscape['period']} · ${soundscape['location']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
