#!/usr/bin/env python3
"""
최소 용량 퀴즈 이미지 최적화 스크립트 (Pillow 기반 WebP 압축기)
용도: 임의의 고용량 이미지(PNG, JPG)를 384x384 초경량 WebP (10~25KB)로 변환
사용법:
  python3 scripts/optimize_image.py <input_path> [output_name]
  python3 scripts/optimize_image.py /path/to/folder --batch
"""

import os
import sys
from PIL import Image

TARGET_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '../assets/images/quiz'))
TARGET_SIZE = (384, 384)
WEBP_QUALITY = 80

def optimize_single_image(input_path, output_name=None):
    if not os.path.exists(input_path):
        print(f"[Error] File not found: {input_path}")
        return None

    os.makedirs(TARGET_DIR, exist_ok=True)

    base_name = output_name if output_name else os.path.splitext(os.path.basename(input_path))[0]
    output_filename = f"{base_name}.webp" if not base_name.endswith('.webp') else base_name
    output_path = os.path.join(TARGET_DIR, output_filename)

    original_size_kb = os.path.getsize(input_path) / 1024

    with Image.open(input_path) as img:
        # RGBA 또는 RGB 변환
        if img.mode not in ('RGB', 'RGBA'):
            img = img.convert('RGBA')

        # 종횡비 유지하면서 384x384 안에 맞게 리사이즈
        img.thumbnail(TARGET_SIZE, Image.Resampling.LANCZOS)

        # 384x384 정사각 캔버스 중앙 정렬 (필요시)
        canvas = Image.new('RGBA', TARGET_SIZE, (0, 0, 0, 0))
        offset = ((TARGET_SIZE[0] - img.width) // 2, (TARGET_SIZE[1] - img.height) // 2)
        canvas.paste(img, offset)

        # WebP 초경량 저장
        canvas.save(output_path, 'WEBP', quality=WEBP_QUALITY, method=6)

    optimized_size_kb = os.path.getsize(output_path) / 1024
    reduction = (1 - (optimized_size_kb / original_size_kb)) * 100 if original_size_kb > 0 else 0

    print(f"✅ [최적화 완료] {output_filename}")
    print(f"   - 원본 용량: {original_size_kb:.1f} KB ➔ 최적화 WebP: {optimized_size_kb:.1f} KB ({reduction:.1f}% 절감)")
    print(f"   - 저장 경로: assets/images/quiz/{output_filename}")
    return f"assets/images/quiz/{output_filename}"

def main():
    if len(sys.argv) < 2:
        print("사용법: python3 scripts/optimize_image.py <이미지경로> [출력파일명]")
        print("예시: python3 scripts/optimize_image.py my_piano.png q1_piano")
        sys.exit(1)

    input_path = sys.argv[1]
    output_name = sys.argv[2] if len(sys.argv) > 2 else None
    optimize_single_image(input_path, output_name)

if __name__ == '__main__':
    main()
