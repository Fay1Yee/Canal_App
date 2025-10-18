#!/usr/bin/env python3
"""
测试豆包AI绘画API
生成京杭大运河声景的水墨画配图
"""

import os
import sys

# 尝试导入openai，如果失败则提示安装
try:
    from openai import OpenAI
except ImportError:
    print("❌ OpenAI库未安装")
    print("请运行: pip3 install openai")
    sys.exit(1)

# API配置
ARK_API_KEY = "e779c50a-bc8c-4673-ada3-30c4e7987018"
BASE_URL = "https://ark.cn-beijing.volces.com/api/v3"
MODEL = "doubao-seedream-4-0-250828"

# 测试提示词 - 京杭大运河水墨画风格
test_prompts = [
    {
        "name": "扬州二十四桥",
        "prompt": "中国传统水墨画，扬州二十四桥明月夜，玉人吹箫，月色如水，运河水面波光粼粼，柳树依依，古桥倒影，远山朦胧，留白处理，黑白灰色调，写意风格，诗意画面，4K高清"
    },
    {
        "name": "杭州拱宸桥",
        "prompt": "中国水墨画，杭州拱宸桥，大运河终点，千年古桥，船只往来，波涛声声，历史沧桑感，远处西湖山色，墨色渲染，泼墨技法，层次分明，意境深远，宣纸质感，2K分辨率"
    },
    {
        "name": "苏州寒山寺",
        "prompt": "传统水墨山水画，苏州寒山寺，夜半钟声，运河客船，古寺钟楼，月光下的运河，静谧氛围，禅意画面，简约留白，浓淡相宜，诗意朦胧，中国画美学，高清画质"
    }
]

def generate_image(prompt_dict):
    """生成单张图片"""
    try:
        # 初始化客户端
        client = OpenAI(
            base_url=BASE_URL,
            api_key=ARK_API_KEY,
        )
        
        print(f"\n🎨 正在生成: {prompt_dict['name']}")
        print(f"📝 提示词: {prompt_dict['prompt'][:50]}...")
        
        # 调用API生成图片
        response = client.images.generate(
            model=MODEL,
            prompt=prompt_dict['prompt'],
            size="2K",  # 2K分辨率
            response_format="url",
            extra_body={
                "watermark": False,  # 不要水印
            },
        )
        
        # 获取图片URL
        image_url = response.data[0].url
        print(f"✅ 成功生成!")
        print(f"🔗 图片URL: {image_url}")
        
        return {
            "name": prompt_dict['name'],
            "url": image_url,
            "prompt": prompt_dict['prompt']
        }
        
    except Exception as e:
        print(f"❌ 生成失败: {str(e)}")
        return None

def main():
    """主函数"""
    print("="*60)
    print("🎨 京杭大运河声景 - 豆包AI配图生成测试")
    print("="*60)
    
    print(f"\n📌 API配置:")
    print(f"   Base URL: {BASE_URL}")
    print(f"   Model: {MODEL}")
    print(f"   API Key: {ARK_API_KEY[:20]}...")
    
    results = []
    
    # 生成所有测试图片
    for i, prompt_dict in enumerate(test_prompts, 1):
        print(f"\n[{i}/{len(test_prompts)}] 开始生成...")
        result = generate_image(prompt_dict)
        if result:
            results.append(result)
    
    # 输出汇总结果
    print("\n" + "="*60)
    print("📊 生成结果汇总:")
    print("="*60)
    
    if results:
        print(f"\n✅ 成功生成 {len(results)}/{len(test_prompts)} 张图片:\n")
        for i, result in enumerate(results, 1):
            print(f"{i}. {result['name']}")
            print(f"   URL: {result['url']}")
            print()
        
        # 生成用于更新代码的URL映射
        print("\n💡 可以用以下URL更新 CanalSoundscapeData:")
        print("-"*60)
        for result in results:
            print(f'"{result["name"]}": "{result["url"]}",')
        
    else:
        print("\n❌ 所有图片生成失败")
        print("请检查:")
        print("1. API Key是否正确")
        print("2. 网络连接是否正常")
        print("3. API配额是否充足")
    
    print("\n" + "="*60)
    print("测试完成！")
    print("="*60)

if __name__ == "__main__":
    main()






