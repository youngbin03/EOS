import 'package:flutter/material.dart';
import 'package:house_of_tomorrow/src/model/product.dart';
import 'package:house_of_tomorrow/src/service/theme_service.dart';
import 'package:house_of_tomorrow/theme/component/bottom_sheet/base_bottom_sheet.dart';
import 'package:house_of_tomorrow/theme/component/button/button.dart';
import 'package:house_of_tomorrow/theme/component/counter_button.dart';
import 'package:house_of_tomorrow/theme/res/layout.dart';
import 'package:house_of_tomorrow/util/helper/intl_helper.dart';
import 'package:house_of_tomorrow/util/lang/generated/l10n.dart';

class ProductBottomSheet extends StatelessWidget {
  const ProductBottomSheet({
    super.key,
    required this.count,
    required this.product,
    required this.onCountChanged,
    required this.onAddToCartPressed,
  });

  // 부모 위젯으로부터 전달받은 속성들
  final int count; // 현재 선택된 수량
  final Product product; // 표시할 제품 정보
  final void Function(int count) onCountChanged; // 수량 변경 콜백 함수
  final void Function() onAddToCartPressed; // 장바구니 추가 콜백 함수

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      // 데스크톱 모드에서는 모든 모서리를 둥글게, 모바일에서는 상단만 둥글게 처리
      isRoundAll: context.layout(false, desktop: true),

      // 기기 유형에 따라 다른 패딩 적용 (반응형 처리)
      padding: EdgeInsets.only(
        top: context.layout(32, desktop: 16), // 모바일 32, 데스크톱 16
        bottom: 16,
        left: 16,
        right: 16,
      ),
      child: Wrap(
        runSpacing: 16,
        children: [
          // 수량 선택 영역
          Row(
            children: [
              Text(
                S.current.quantity,
                style: context.typo.headline3,
              ),
              const Spacer(),

              /// 수량 조절 버튼 (사용자 상호작용 처리)
              CounterButton(
                count: count,
                onChanged: onCountChanged, // 부모 위젯의 콜백 함수 전달
              ),
            ],
          ),

          // 가격 표시 영역
          Row(
            children: [
              Text(
                S.current.totalPrice,
                style: context.typo.headline3,
              ),
              const Spacer(),

              /// 총 금액 계산 및 표시 (국제화 처리)
              Text(
                IntlHelper.currency(
                  symbol: product.priceUnit,
                  number: product.price * count, // 단가 × 수량 계산
                ),
                style: context.typo.headline3.copyWith(
                  color: context.color.primary,
                ),
              ),
            ],
          ),

          /// 장바구니 추가 버튼
          Button(
            width: double.infinity,
            size: ButtonSize.large,
            text: S.current.addToCart,
            onPressed: onAddToCartPressed, // 부모 위젯의 콜백 함수 전달
          ),
        ],
      ),
    );
  }
}
