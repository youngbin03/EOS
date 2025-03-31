import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:house_of_tomorrow/src/model/product.dart';
import 'package:house_of_tomorrow/src/service/theme_service.dart';
import 'package:house_of_tomorrow/util/helper/intl_helper.dart';

class ProductColorPreview extends StatelessWidget {
  const ProductColorPreview({
    super.key,
    required this.colorIndex,
    required this.product,
  });

  final int colorIndex; // 현재 선택된 색상 인덱스
  final Product product; // 제품 정보 객체

  @override
  Widget build(BuildContext context) {
    return Container(
      // 테마 시스템을 활용한 스타일링 (context.color, context.deco)
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: context.deco.shadow,
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 이미지 로딩 최적화
          /// - CachedNetworkImage: 네트워크 이미지 캐싱으로 성능 향상
          /// - AspectRatio: 일관된 비율 유지 (1:0.8)
          AspectRatio(
            aspectRatio: 1 / 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                // colorIndex를 사용하여 선택된 색상의 이미지 표시
                imageUrl: product.productColorList[colorIndex].imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// 제품명 - 굵은 폰트 적용
          Text(
            product.name.toString(),
            style: context.typo.headline1.copyWith(
              fontWeight: context.typo.semiBold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              /// 브랜드명 - 연한 색상으로 표시
              Text(
                product.brand.toString(),
                style: context.typo.subtitle1.copyWith(
                  fontWeight: context.typo.light,
                  color: context.color.subtext,
                ),
              ),

              const Spacer(),

              /// 가격 표시 - 국제화 처리 (IntlHelper 활용)
              Text(
                IntlHelper.currency(
                  symbol: product.priceUnit,
                  number: product.price,
                ),
                style: context.typo.headline6.copyWith(
                  color: context.color.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
