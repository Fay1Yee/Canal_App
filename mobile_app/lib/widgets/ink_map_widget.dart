import 'package:flutter/material.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'; // TODO: 配置 Mapbox token
import '../theme/app_theme.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

/// 水墨风格地图组件 (Mapbox)
/// TODO: 需要配置 Mapbox Access Token 才能使用
class InkMapWidget extends StatefulWidget {
  // final Function(dynamic)? onMapCreated;
  // final Function(dynamic)? onMapClick;
  final List<SoundscapeMarker>? markers;

  const InkMapWidget({
    super.key,
    // this.onMapCreated,
    // this.onMapClick,
    this.markers,
  });

  @override
  State<InkMapWidget> createState() => _InkMapWidgetState();
}

class _InkMapWidgetState extends State<InkMapWidget> {
  // MapboxMap? _mapboxMap;
  // PointAnnotationManager? _pointAnnotationManager;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // TODO: 配置 Mapbox Access Token 后启用
        // Mapbox 地图
        Container(
          color: AppTheme.primaryBlack,
          child: const Center(
            child: Text(
              'Mapbox 地图\n需要配置 Access Token',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.inkLight),
            ),
          ),
        ),

        // 水墨风格覆盖层
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.inkBlack.withValues(alpha: 0.3),
                  Colors.transparent,
                  AppTheme.inkBlack.withValues(alpha: 0.2),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // TODO: Mapbox 相关方法，需要配置 token 后启用
  /*
  Future<void> _onMapCreated(dynamic mapboxMap) async {
    // 配置水墨风格
    await _configureInkStyle();
    // 创建标注管理器和添加标记
  }

  Future<void> _configureInkStyle() async {
    // 设置水墨风格的地图样式
  }

  Future<void> _addMarkers(List<SoundscapeMarker> markers) async {
    // 添加标记到地图
  }
  */

  Future<Uint8List> _createInkMarkerIcon(String period) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = 60.0;

    // 绘制水墨风格圆点
    final paint = Paint()
      ..shader =
          RadialGradient(
            colors: [AppTheme.accentWhite, AppTheme.inkGray, AppTheme.inkBlack],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size / 2, size / 2),
              radius: size / 2,
            ),
          )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);

    // 绘制文字
    final textPainter = TextPainter(
      text: TextSpan(
        text: period.substring(0, 1),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w300,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  // void _onMapTap(dynamic context) {
  //   // widget.onMapClick?.call(context.point);
  // }
}

/// 声景标记数据
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
