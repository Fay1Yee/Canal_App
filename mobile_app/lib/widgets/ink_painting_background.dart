import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

/// 水墨画背景组件 - 参考图片1的水墨晕染效果
class InkPaintingBackground extends StatelessWidget {
  final Widget child;
  final bool showPoem;

  const InkPaintingBackground({
    super.key,
    required this.child,
    this.showPoem = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 水墨渐变背景
        Positioned.fill(child: CustomPaint(painter: InkWashPainter())),
        // 内容层
        child,
      ],
    );
  }
}

/// 水墨晕染画家
class InkWashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 创建多层水墨效果
    _paintInkLayer(
      canvas,
      size,
      0.15,
      Offset(size.width * 0.2, size.height * 0.15),
    );
    _paintInkLayer(
      canvas,
      size,
      0.08,
      Offset(size.width * 0.7, size.height * 0.4),
    );
    _paintInkLayer(
      canvas,
      size,
      0.12,
      Offset(size.width * 0.4, size.height * 0.7),
    );
    _paintInkLayer(
      canvas,
      size,
      0.05,
      Offset(size.width * 0.8, size.height * 0.85),
    );
  }

  void _paintInkLayer(Canvas canvas, Size size, double opacity, Offset center) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppTheme.inkBlack.withValues(alpha: opacity),
          AppTheme.inkGray.withValues(alpha: opacity * 0.5),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.4))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);

    canvas.drawCircle(center, size.width * 0.4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 几何网格背景 - 参考图片2的技术图纸感
class GeometricGridBackground extends StatelessWidget {
  final Widget child;
  final bool showGrid;

  const GeometricGridBackground({
    super.key,
    required this.child,
    this.showGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showGrid)
          Positioned.fill(child: CustomPaint(painter: GridPainter())),
        child,
      ],
    );
  }
}

/// 网格画家
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.subtleGray.withValues(alpha: 0.2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final heavyPaint = Paint()
      ..color = AppTheme.subtleGray.withValues(alpha: 0.4)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const gridSize = 40.0;
    const heavyGridMultiple = 5;

    // 绘制垂直网格线
    for (int i = 0; i <= (size.width / gridSize).ceil(); i++) {
      final x = i * gridSize;
      final isHeavy = i % heavyGridMultiple == 0;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        isHeavy ? heavyPaint : paint,
      );
    }

    // 绘制水平网格线
    for (int i = 0; i <= (size.height / gridSize).ceil(); i++) {
      final y = i * gridSize;
      final isHeavy = i % heavyGridMultiple == 0;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        isHeavy ? heavyPaint : paint,
      );
    }

    // 绘制对角线辅助线
    _drawDiagonalGuides(canvas, size, paint);
  }

  void _drawDiagonalGuides(Canvas canvas, Size size, Paint paint) {
    final dashedPaint = Paint()
      ..color = AppTheme.subtleGray.withValues(alpha: 0.15)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // 主对角线
    _drawDashedLine(
      canvas,
      Offset.zero,
      Offset(size.width, size.height),
      dashedPaint,
    );
    _drawDashedLine(
      canvas,
      Offset(size.width, 0),
      Offset(0, size.height),
      dashedPaint,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 10.0;
    final distance = (end - start).distance;
    final normalizedVector = (end - start) / distance;

    for (double i = 0; i < distance; i += dashWidth + dashSpace) {
      final dashStart = start + (normalizedVector * i);
      final dashEnd =
          start + (normalizedVector * math.min(i + dashWidth, distance));
      canvas.drawLine(dashStart, dashEnd, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 圆形数据可视化组件 - 参考图片3的圆形图表
class CircularDataWidget extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final double size;

  const CircularDataWidget({
    super.key,
    required this.label,
    required this.value,
    required this.progress,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景圆环
          CustomPaint(
            size: Size(size, size),
            painter: CircularProgressPainter(
              progress: 1.0,
              strokeWidth: 1.0,
              color: AppTheme.subtleGray.withValues(alpha: 0.3),
            ),
          ),
          // 进度圆环
          CustomPaint(
            size: Size(size, size),
            painter: CircularProgressPainter(
              progress: progress,
              strokeWidth: 2.0,
              color: AppTheme.accentWhite,
            ),
          ),
          // 中心数据
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: AppTheme.accentWhite,
                  fontSize: size * 0.25,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.inkLight,
                  fontSize: size * 0.12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 圆形进度画家
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 诗词文字组件 - 参考图片1的竖排文字
class PoemTextWidget extends StatelessWidget {
  final String poem;
  final bool isVertical;

  const PoemTextWidget({
    super.key,
    required this.poem,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: isVertical
          ? _buildVerticalPoem()
          : Text(
              poem,
              style: const TextStyle(
                color: AppTheme.inkLight,
                fontSize: 14,
                height: 1.8,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  Widget _buildVerticalPoem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: poem.split('').map((char) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            char,
            style: const TextStyle(
              color: AppTheme.inkLight,
              fontSize: 16,
              height: 1.5,
              letterSpacing: 0,
              fontWeight: FontWeight.w300,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// 参数标注组件 - 参考图片2的技术参数标注
class ParameterLabel extends StatelessWidget {
  final String parameter;
  final String value;
  final bool showLine;

  const ParameterLabel({
    super.key,
    required this.parameter,
    required this.value,
    this.showLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLine)
          Container(
            width: 20,
            height: 1,
            color: AppTheme.subtleGray,
            margin: const EdgeInsets.only(right: 8),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              parameter.toUpperCase(),
              style: const TextStyle(
                color: AppTheme.inkLight,
                fontSize: 10,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: AppTheme.accentWhite,
                fontSize: 14,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
