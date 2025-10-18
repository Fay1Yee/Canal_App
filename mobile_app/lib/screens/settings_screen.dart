import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ink_style_components.dart';
import '../widgets/ink_painting_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoPlayNext = true;
  bool _showPoem = true;
  bool _showGrid = true;
  bool _pushNotifications = true;
  double _audioQuality = 2.0; // 0: 低, 1: 中, 2: 高
  String _selectedLanguage = '简体中文';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(title: const Text('设置')),
      body: InkPaintingBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 播放设置
              InkStyleComponents.inkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          color: AppTheme.accentWhite,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '播放设置',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSwitchItem(
                      '自动播放下一个',
                      _autoPlayNext,
                      (value) => setState(() => _autoPlayNext = value),
                    ),
                    InkStyleComponents.inkDivider(),
                    _buildSliderItem(
                      '音频质量',
                      _audioQuality,
                      (value) => setState(() => _audioQuality = value),
                      ['低', '中', '高'],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 显示设置
              InkStyleComponents.inkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          color: AppTheme.accentWhite,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '显示设置',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSwitchItem(
                      '显示诗词',
                      _showPoem,
                      (value) => setState(() => _showPoem = value),
                    ),
                    InkStyleComponents.inkDivider(),
                    _buildSwitchItem(
                      '显示网格',
                      _showGrid,
                      (value) => setState(() => _showGrid = value),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 通知设置
              InkStyleComponents.inkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.notifications_outlined,
                          color: AppTheme.accentWhite,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '通知设置',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSwitchItem(
                      '推送通知',
                      _pushNotifications,
                      (value) => setState(() => _pushNotifications = value),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 语言设置
              InkStyleComponents.inkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: AppTheme.accentWhite,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '语言',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: _showLanguageOptions,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedLanguage,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppTheme.inkLight,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 关于
              InkStyleComponents.inkCard(
                child: Column(
                  children: [
                    _buildMenuItem(
                      '关于水上书',
                      Icons.info_outline,
                      () => _showAbout(),
                    ),
                    InkStyleComponents.inkDivider(),
                    _buildMenuItem('用户协议', Icons.description_outlined, () {}),
                    InkStyleComponents.inkDivider(),
                    _buildMenuItem('隐私政策', Icons.privacy_tip_outlined, () {}),
                    InkStyleComponents.inkDivider(),
                    _buildMenuItem(
                      '清除缓存',
                      Icons.cleaning_services_outlined,
                      () => _clearCache(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 退出登录
              Center(
                child: InkStyleComponents.inkButton(
                  text: '退出登录',
                  onPressed: _logout,
                  isPrimary: false,
                  icon: Icons.logout,
                ),
              ),

              const SizedBox(height: 16),

              // 版本信息
              Center(
                child: Text(
                  '水上书 v2.0.0',
                  style: const TextStyle(
                    color: AppTheme.inkLight,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchItem(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppTheme.lightGray,
            inactiveThumbColor: AppTheme.lightGray,
            inactiveTrackColor: AppTheme.subtleGray,
            thumbColor: WidgetStateProperty.all(AppTheme.accentWhite),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderItem(
    String title,
    double value,
    Function(double) onChanged,
    List<String> labels,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text(
                labels[value.toInt()],
                style: const TextStyle(fontSize: 14, color: AppTheme.inkLight),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppTheme.accentWhite,
              inactiveTrackColor: AppTheme.subtleGray,
              thumbColor: AppTheme.accentWhite,
              overlayColor: AppTheme.accentWhite.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: (labels.length - 1).toDouble(),
              divisions: labels.length - 1,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
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
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.inkLight),
          ],
        ),
      ),
    );
  }

  void _showLanguageOptions() {
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
              '选择语言',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            _buildLanguageOption('简体中文'),
            _buildLanguageOption('繁体中文'),
            _buildLanguageOption('English'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final isSelected = language == _selectedLanguage;
    return InkWell(
      onTap: () {
        setState(() => _selectedLanguage = language);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                language,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isSelected ? AppTheme.accentWhite : AppTheme.inkLight,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: AppTheme.accentWhite),
          ],
        ),
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBlack,
        title: const Text('关于水上书'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('水上书 - 声景文化传承平台'),
            SizedBox(height: 12),
            Text(
              '融合 Nothing OS 极简美学与传统水墨艺术，\n为您提供沉浸式的历史文化声景体验。',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.inkLight,
                height: 1.5,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '版本: v2.0.0\n开发团队: Canal App',
              style: TextStyle(fontSize: 12, color: AppTheme.inkLight),
            ),
          ],
        ),
        actions: [
          InkStyleComponents.inkButton(
            text: '关闭',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBlack,
        title: const Text('清除缓存'),
        content: const Text('确定要清除所有缓存数据吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          InkStyleComponents.inkButton(
            text: '确定',
            onPressed: () {
              // TODO: 实现清除缓存
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('缓存已清除'),
                  backgroundColor: AppTheme.secondaryBlack,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.secondaryBlack,
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          InkStyleComponents.inkButton(
            text: '确定',
            onPressed: () {
              // TODO: 实现退出登录
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
