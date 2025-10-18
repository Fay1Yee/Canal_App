import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 水墨风格组件库
class InkStyleComponents {
  /// 墨点标记组件 - 用于地图上的声景标记
  static Widget inkDot({
    required double size,
    required VoidCallback onTap,
    bool isActive = false,
    String? period,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isActive
              ? AppTheme.inkGradient
              : LinearGradient(
                  colors: [
                    AppTheme.inkGray.withValues(alpha: 0.7),
                    AppTheme.inkBlack.withValues(alpha: 0.5),
                  ],
                ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.inkBlack.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: period != null
            ? Center(
                child: Text(
                  period,
                  style: TextStyle(
                    color: AppTheme.accentWhite,
                    fontSize: size * 0.3,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  /// 水墨风格卡片
  static Widget inkCard({
    required Widget child,
    EdgeInsets? padding,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.secondaryBlack,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppTheme.subtleGray, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.inkBlack.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  /// 水墨风格按钮
  static Widget inkButton({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = true,
    bool isLoading = false,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: isPrimary ? AppTheme.inkGradient : null,
        color: isPrimary ? null : AppTheme.secondaryBlack,
        borderRadius: BorderRadius.circular(4),
        border: isPrimary ? null : Border.all(color: AppTheme.subtleGray),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.accentWhite,
                      ),
                    ),
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    size: 16,
                    color: isPrimary
                        ? AppTheme.primaryBlack
                        : AppTheme.accentWhite,
                  ),
                if (isLoading || icon != null) const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isPrimary
                          ? AppTheme.primaryBlack
                          : AppTheme.accentWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 水墨风格输入框
  static Widget inkTextField({
    required String label,
    String? hint,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.accentWhite,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.secondaryBlack,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppTheme.subtleGray),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            maxLines: maxLines ?? 1,
            style: const TextStyle(color: AppTheme.accentWhite, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppTheme.lightGray,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }

  /// 水墨风格分割线
  static Widget inkDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, AppTheme.subtleGray, Colors.transparent],
        ),
      ),
    );
  }

  /// 水墨风格加载指示器
  static Widget inkLoadingIndicator({String? text}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.inkGradient,
          ),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentWhite),
            ),
          ),
        ),
        if (text != null) ...[
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.inkLight,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ],
    );
  }

  /// 水墨风格标签
  static Widget inkTag({
    required String text,
    Color? backgroundColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppTheme.secondaryBlack,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppTheme.subtleGray, width: 0.5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? AppTheme.accentWhite,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
