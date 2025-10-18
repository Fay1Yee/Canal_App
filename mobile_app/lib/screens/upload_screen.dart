import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ink_style_components.dart';
import '../widgets/ink_painting_background.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _poemController = TextEditingController();

  String _selectedPeriod = '唐代';
  final List<String> _selectedEmotions = [];
  String? _audioFilePath;
  bool _isUploading = false;

  final List<String> _periods = [
    '先秦',
    '秦汉',
    '魏晋',
    '隋唐',
    '宋',
    '元',
    '明',
    '清',
    '近现代',
    '当代',
  ];
  final List<String> _emotions = [
    '宁静',
    '怀古',
    '庄严',
    '雅致',
    '繁华',
    '忧伤',
    '欢快',
    '激昂',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('上传声景'),
        actions: [
          TextButton.icon(
            onPressed: _isUploading ? null : _submitUpload,
            icon: const Icon(Icons.check, color: AppTheme.accentWhite),
            label: const Text(
              '提交',
              style: TextStyle(color: AppTheme.accentWhite),
            ),
          ),
        ],
      ),
      body: InkPaintingBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 音频文件选择
              InkStyleComponents.inkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.audiotrack,
                          color: AppTheme.accentWhite,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '音频文件',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_audioFilePath == null)
                      InkStyleComponents.inkButton(
                        text: '选择音频文件',
                        onPressed: _pickAudioFile,
                        icon: Icons.upload_file,
                        isPrimary: false,
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.subtleGray.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.audio_file,
                              color: AppTheme.accentWhite,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '已选择音频',
                                    style: TextStyle(
                                      color: AppTheme.accentWhite,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    _audioFilePath!,
                                    style: const TextStyle(
                                      color: AppTheme.inkLight,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: AppTheme.inkLight,
                              ),
                              onPressed: () =>
                                  setState(() => _audioFilePath = null),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 基本信息
              InkStyleComponents.inkCard(
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.accentWhite,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '基本信息',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    InkStyleComponents.inkTextField(
                      label: '声景标题',
                      hint: '如：唐代扬州夜雨',
                      controller: _titleController,
                    ),

                    const SizedBox(height: 16),

                    InkStyleComponents.inkTextField(
                      label: '地点名称',
                      hint: '如：扬州',
                      controller: _locationController,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 历史时期
              InkStyleComponents.inkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.history,
                          color: AppTheme.accentWhite,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '历史时期',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _periods.map((period) {
                        final isSelected = period == _selectedPeriod;
                        return InkStyleComponents.inkTag(
                          text: period,
                          backgroundColor: isSelected
                              ? AppTheme.accentWhite
                              : AppTheme.secondaryBlack,
                          textColor: isSelected
                              ? AppTheme.primaryBlack
                              : AppTheme.accentWhite,
                          onTap: () => setState(() => _selectedPeriod = period),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 情绪标签
              InkStyleComponents.inkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.emoji_emotions_outlined,
                          color: AppTheme.accentWhite,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '情绪标签',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '可多选',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.inkLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _emotions.map((emotion) {
                        final isSelected = _selectedEmotions.contains(emotion);
                        return InkStyleComponents.inkTag(
                          text: emotion,
                          backgroundColor: isSelected
                              ? AppTheme.accentWhite
                              : AppTheme.secondaryBlack,
                          textColor: isSelected
                              ? AppTheme.primaryBlack
                              : AppTheme.accentWhite,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedEmotions.remove(emotion);
                              } else {
                                _selectedEmotions.add(emotion);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 收尾诗
              InkStyleComponents.inkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: AppTheme.accentWhite,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '收尾诗',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '选填',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.inkLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    InkStyleComponents.inkTextField(
                      label: '诗词内容',
                      hint: '如：夜雨扬州巷，墨香染诗篇。',
                      controller: _poemController,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 提交按钮
              SizedBox(
                width: double.infinity,
                child: InkStyleComponents.inkButton(
                  text: '提交审核',
                  onPressed: _isUploading ? () {} : _submitUpload,
                  icon: Icons.send,
                  isLoading: _isUploading,
                ),
              ),

              const SizedBox(height: 16),

              // 提示信息
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.subtleGray.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.subtleGray, width: 0.5),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppTheme.inkLight,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '提交后将进入审核流程，审核通过后会在地图上显示',
                        style: TextStyle(
                          color: AppTheme.inkLight,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickAudioFile() async {
    // TODO: 实现文件选择
    setState(() {
      _audioFilePath = 'soundscape_audio.mp3';
    });
  }

  void _submitUpload() async {
    if (_audioFilePath == null) {
      _showMessage('请先选择音频文件');
      return;
    }

    if (_titleController.text.isEmpty) {
      _showMessage('请输入声景标题');
      return;
    }

    if (_locationController.text.isEmpty) {
      _showMessage('请输入地点名称');
      return;
    }

    setState(() => _isUploading = true);

    // TODO: 实现上传逻辑
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isUploading = false);

    if (mounted) {
      _showMessage('上传成功，等待审核');
      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.secondaryBlack,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _poemController.dispose();
    super.dispose();
  }
}
