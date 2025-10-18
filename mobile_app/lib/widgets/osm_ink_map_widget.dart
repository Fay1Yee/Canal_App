import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';

/// 声景标记数据
class SoundscapeMarker {
  final String id;
  final String title;
  final String period;
  final LatLng position;
  final VoidCallback? onTap;

  SoundscapeMarker({
    required this.id,
    required this.title,
    required this.period,
    required this.position,
    this.onTap,
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

  // 运河中心坐标（大致在扬州）
  static const LatLng _center = LatLng(32.39, 119.42);

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
        // OpenStreetMap 地图
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _center,
            initialZoom: 6.0,
            minZoom: 3.0,
            maxZoom: 18.0,
            onTap: (tapPosition, point) {
              widget.onMapClick?.call(point);
            },
          ),
          children: [
            // 地图瓦片层 - 使用国内可访问的地图源
            TileLayer(
              // 使用高德地图瓦片
              urlTemplate:
                  'https://wprd01.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=7',
              userAgentPackageName: 'com.canal.waterscapes',
              maxNativeZoom: 18,
              maxZoom: 18,
              errorTileCallback: (tile, error, stackTrace) {
                // 地图瓦片加载失败时的处理
                print('地图瓦片加载失败: ${tile.coordinates}, 错误: $error');
              },
              // 多重滤镜叠加，创造水墨画效果
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

            // 标记层
            if (widget.markers != null && widget.markers!.isNotEmpty)
              MarkerLayer(
                markers: widget.markers!.map((marker) {
                  return Marker(
                    point: marker.position,
                    width: 80,
                    height: 80,
                    child: GestureDetector(
                      onTap: marker.onTap,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 标记图标
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.accentWhite.withValues(
                                alpha: 0.9,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.inkDark,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: AppTheme.inkDark,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // 标记文字
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.inkDark.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              marker.title,
                              style: const TextStyle(
                                color: AppTheme.accentWhite,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),

        // 水墨纹理叠加层
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    Colors.transparent,
                    AppTheme.inkDark.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
