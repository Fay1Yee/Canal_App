import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';

/// 声景标记数据模型
class SoundscapeMarker {
  final String id;
  final String title;
  final String period;
  final double latitude;
  final double longitude;
  final String emotion;

  SoundscapeMarker({
    required this.id,
    required this.title,
    required this.period,
    required this.latitude,
    required this.longitude,
    required this.emotion,
  });
}

/// OpenStreetMap 水墨风格地图组件
class OsmInkMapWidget extends StatefulWidget {
  final Function(MapController)? onMapCreated;
  final Function(LatLng)? onMapClick;
  final List<SoundscapeMarker>? markers;

  const OsmInkMapWidget({
    super.key,
    this.onMapCreated,
    this.onMapClick,
    this.markers,
  });

  @override
  State<OsmInkMapWidget> createState() => _OsmInkMapWidgetState();
}

class _OsmInkMapWidgetState extends State<OsmInkMapWidget> {
  late final MapController _mapController;

  // 京杭大运河中心坐标（扬州附近）
  static const LatLng _center = LatLng(33.0, 118.0);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onMapCreated?.call(_mapController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 地图层
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _center,
            initialZoom: 6.5,
            minZoom: 4.0,
            maxZoom: 18.0,
            onTap: (tapPosition, point) {
              widget.onMapClick?.call(point);
            },
          ),
          children: [
            // 地图瓦片层 - 使用高德地图
            TileLayer(
              urlTemplate:
                  'https://wprd01.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=7',
              userAgentPackageName: 'com.canal.waterscapes',
              maxNativeZoom: 18,
              maxZoom: 18,
              errorTileCallback: (tile, error, stackTrace) {
                print('地图瓦片加载失败: ${tile.coordinates}, 错误: $error');
              },
              // 水墨画滤镜效果
              tileBuilder: (context, child, tile) {
                return ColorFiltered(
                  colorFilter: ColorFilter.matrix([
                    0.393, 0.769, 0.189, 0, 0, // 红色通道 - 偏棕褐
                    0.349, 0.686, 0.168, 0, 0, // 绿色通道 - 增强对比
                    0.272, 0.534, 0.131, 0, 0, // 蓝色通道 - 降低饱和度
                    0, 0, 0, 1, 0, // Alpha通道
                  ]),
                  child: Opacity(
                    opacity: 0.65, // 强化水墨效果的透明度
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        AppTheme.inkDark.withValues(alpha: 0.4),
                        BlendMode.multiply, // 墨色叠加
                      ),
                      child: child,
                    ),
                  ),
                );
              },
            ),

            // 声景标记层
            if (widget.markers != null && widget.markers!.isNotEmpty)
              MarkerLayer(
                markers: widget.markers!.map((marker) {
                  return Marker(
                    point: LatLng(marker.latitude, marker.longitude),
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                      onTap: () {
                        _showMarkerDetail(marker);
                      },
                      child: _buildMarker(marker),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),

        // 地图控制按钮
        Positioned(
          right: 16,
          bottom: 100,
          child: Column(
            children: [
              // 放大按钮
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.secondaryBlack.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.subtleGray, width: 0.5),
                ),
                child: IconButton(
                  icon: Icon(Icons.add, color: AppTheme.accentWhite),
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      currentZoom + 1,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // 缩小按钮
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.secondaryBlack.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.subtleGray, width: 0.5),
                ),
                child: IconButton(
                  icon: Icon(Icons.remove, color: AppTheme.accentWhite),
                  onPressed: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      currentZoom - 1,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // 定位按钮
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.secondaryBlack.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.subtleGray, width: 0.5),
                ),
                child: IconButton(
                  icon: Icon(Icons.my_location, color: AppTheme.accentWhite),
                  onPressed: () {
                    // 回到运河中心
                    _mapController.move(_center, 6.5);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建声景标记
  Widget _buildMarker(SoundscapeMarker marker) {
    return Column(
      children: [
        // 标记图标
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getEmotionColor(marker.emotion),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.accentWhite, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.waves, color: AppTheme.accentWhite, size: 24),
        ),
        const SizedBox(height: 4),
        // 标记文字
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.secondaryBlack.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.subtleGray, width: 0.5),
          ),
          child: Text(
            marker.title.length > 6
                ? '${marker.title.substring(0, 6)}...'
                : marker.title,
            style: TextStyle(
              color: AppTheme.accentWhite,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  /// 根据情感获取颜色
  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case '繁忙':
        return Colors.orange.withValues(alpha: 0.9);
      case '热闹':
        return Colors.red.withValues(alpha: 0.9);
      case '宁静':
        return Colors.blue.withValues(alpha: 0.9);
      case '悠扬':
        return Colors.purple.withValues(alpha: 0.9);
      case '激昂':
        return Colors.amber.withValues(alpha: 0.9);
      case '凄美':
        return Colors.cyan.withValues(alpha: 0.9);
      case '祥和':
        return Colors.green.withValues(alpha: 0.9);
      default:
        return AppTheme.inkLight.withValues(alpha: 0.9);
    }
  }

  /// 显示标记详情
  void _showMarkerDetail(SoundscapeMarker marker) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.secondaryBlack,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getEmotionColor(marker.emotion),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.waves,
                      color: AppTheme.accentWhite,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          marker.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.accentWhite,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          marker.period,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.lightGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 情感标签
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getEmotionColor(
                    marker.emotion,
                  ).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getEmotionColor(marker.emotion),
                    width: 1,
                  ),
                ),
                child: Text(
                  marker.emotion,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getEmotionColor(marker.emotion),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: 导航到详情页
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.inkLight,
                    foregroundColor: AppTheme.accentWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '查看详情',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
