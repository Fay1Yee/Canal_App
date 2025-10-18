#!/bin/bash

# 高德地图 API Key 配置脚本
# 用法: ./configure_amap.sh

set -e

echo "🗺️  高德地图 API Key 配置向导"
echo "================================"
echo ""

# 检查是否在正确的目录
if [ ! -d "mobile_app" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    echo "   当前目录: $(pwd)"
    echo "   应该在: /Users/zephyruszhou/Documents/Canal_App"
    exit 1
fi

# 读取 Android Key
echo "📱 步骤 1/3: Android API Key"
echo ""
echo "   获取方法:"
echo "   1. 访问 https://lbs.amap.com/"
echo "   2. 创建应用并添加 Android Key"
echo "   3. 包名: com.canal.waterscapes.mobile_app"
echo ""
read -p "   请输入 Android API Key: " ANDROID_KEY

if [ -z "$ANDROID_KEY" ]; then
    echo "❌ Android Key 不能为空"
    exit 1
fi

# 读取 iOS Key
echo ""
echo "🍎 步骤 2/3: iOS API Key"
echo ""
echo "   获取方法:"
echo "   1. 在同一应用中添加 iOS Key"
echo "   2. Bundle ID: com.canal.waterscapes.mobileApp"
echo ""
read -p "   请输入 iOS API Key: " IOS_KEY

if [ -z "$IOS_KEY" ]; then
    echo "❌ iOS Key 不能为空"
    exit 1
fi

echo ""
echo "⚙️  步骤 3/3: 应用配置"
echo ""

# 1. 配置 app_config.dart
echo "   [1/4] 配置 app_config.dart..."
CONFIG_FILE="mobile_app/lib/config/app_config.dart"

if [ -f "$CONFIG_FILE" ]; then
    # 备份原文件
    cp "$CONFIG_FILE" "${CONFIG_FILE}.backup"
    
    # 替换 Android Key
    sed -i '' "s/static const String amapApiKeyAndroid = '.*';/static const String amapApiKeyAndroid = '$ANDROID_KEY';/" "$CONFIG_FILE"
    
    # 替换 iOS Key
    sed -i '' "s/static const String amapApiKeyIOS = '.*';/static const String amapApiKeyIOS = '$IOS_KEY';/" "$CONFIG_FILE"
    
    echo "   ✅ app_config.dart 已更新"
else
    echo "   ❌ 找不到 $CONFIG_FILE"
    exit 1
fi

# 2. 配置 AndroidManifest.xml
echo "   [2/4] 配置 AndroidManifest.xml..."
MANIFEST_FILE="mobile_app/android/app/src/main/AndroidManifest.xml"

if [ -f "$MANIFEST_FILE" ]; then
    # 备份原文件
    cp "$MANIFEST_FILE" "${MANIFEST_FILE}.backup"
    
    # 检查是否已经存在 meta-data
    if grep -q "com.amap.api.v2.apikey" "$MANIFEST_FILE"; then
        # 更新现有的 key
        sed -i '' "s|android:value=\".*\" /><!-- AMap API Key -->|android:value=\"$ANDROID_KEY\" /><!-- AMap API Key -->|" "$MANIFEST_FILE"
        echo "   ✅ AndroidManifest.xml 已更新"
    else
        # 添加新的 meta-data (在 </application> 之前)
        sed -i '' "s|</application>|    <!-- 高德地图 API Key -->\n    <meta-data\n        android:name=\"com.amap.api.v2.apikey\"\n        android:value=\"$ANDROID_KEY\" /><!-- AMap API Key -->\n\n</application>|" "$MANIFEST_FILE"
        echo "   ✅ AndroidManifest.xml 已添加配置"
    fi
else
    echo "   ⚠️  警告: 找不到 AndroidManifest.xml"
fi

# 3. 配置 Info.plist
echo "   [3/4] 配置 Info.plist..."
PLIST_FILE="mobile_app/ios/Runner/Info.plist"

if [ -f "$PLIST_FILE" ]; then
    # 备份原文件
    cp "$PLIST_FILE" "${PLIST_FILE}.backup"
    
    # 检查是否已经存在 AMapApiKey
    if grep -q "AMapApiKey" "$PLIST_FILE"; then
        # 更新现有的 key
        sed -i '' "/<key>AMapApiKey<\/key>/,/<string>/ s|<string>.*</string>|<string>$IOS_KEY</string>|" "$PLIST_FILE"
        echo "   ✅ Info.plist 已更新"
    else
        # 添加新的 key (在 </dict> 之前)
        sed -i '' "s|</dict>|	<key>AMapApiKey</key>\n	<string>$IOS_KEY</string>\n	\n	<!-- 位置权限描述 -->\n	<key>NSLocationWhenInUseUsageDescription</key>\n	<string>水上书需要访问您的位置来显示附近的声景</string>\n	\n	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>\n	<string>水上书需要访问您的位置来记录声景</string>\n	\n</dict>|" "$PLIST_FILE"
        echo "   ✅ Info.plist 已添加配置"
    fi
else
    echo "   ⚠️  警告: 找不到 Info.plist"
fi

# 4. 清理并重新构建
echo "   [4/4] 清理构建缓存..."
cd mobile_app
flutter clean > /dev/null 2>&1
echo "   ✅ 构建缓存已清理"

echo ""
echo "🎉 配置完成！"
echo ""
echo "📋 配置摘要:"
echo "   Android Key: ${ANDROID_KEY:0:8}...${ANDROID_KEY: -4}"
echo "   iOS Key:     ${IOS_KEY:0:8}...${IOS_KEY: -4}"
echo ""
echo "🔄 下一步:"
echo "   1. 获取依赖: cd mobile_app && flutter pub get"
echo "   2. 运行应用: flutter run -d 001521567001406"
echo "   3. 测试地图功能"
echo ""
echo "💾 备份文件:"
echo "   - ${CONFIG_FILE}.backup"
echo "   - ${MANIFEST_FILE}.backup"
echo "   - ${PLIST_FILE}.backup"
echo ""
echo "📖 详细文档: cat AMAP_KEY_SETUP.md"
echo ""






