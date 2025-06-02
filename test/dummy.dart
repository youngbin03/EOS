import 'package:flutter/material.dart';
import 'package:house_of_tomorrow/src/model/cart_item.dart';
import 'package:house_of_tomorrow/src/model/lang.dart';
import 'package:house_of_tomorrow/src/model/product.dart';
import 'package:house_of_tomorrow/src/model/product_color.dart';

/// 테스트용 더미 데이터 클래스
///
/// 테스트 환경에서 일관된 데이터를 제공하기 위한 정적 클래스입니다.
/// 실제 API 호출 없이 테스트를 수행할 수 있도록 미리 정의된 데이터를 제공합니다.
///
/// 테스트 더미 데이터의 장점:
/// 1. 테스트 실행 속도 향상 (네트워크 호출 불필요)
/// 2. 테스트 결과의 일관성 보장
/// 3. 외부 의존성 제거로 안정적인 테스트 환경 구축
abstract class Dummy {
  /// 테스트용 상품 객체
  ///
  /// Product 모델의 모든 필드를 포함한 완전한 테스트 데이터입니다.
  /// 다국어 지원(한국어/영어), 가격, 평점, 색상 옵션 등을 포함합니다.
  static const Product product = Product(
    name: Lang(
      ko: "3인용 섹션",
      en: "3-seat section",
    ),
    brand: Lang(
      ko: "쇠데르함",
      en: "SÖDERHAMN",
    ),
    desc: Lang(
      ko: "스타일리시하고 산뜻한 느낌이 좋다면 시트가 깊고 넓은 소파는 어떨까요? 개성을 살려 맞춤 구성한 SÖDERHAMN 쇠데르함 소파에 혼자 또는 가족 모두와 함께 앉아 편안한 휴식을 즐겨보세요.",
      en: "If you like the stylish airy look, you have to try the deep generous seats. Create your own personal combination of SÖDERHAMN sofa, then sit down and relax – by yourself or together with the whole family.",
    ),
    price: 699000,
    priceUnit: "￦",
    rating: "4.9",
    productColorList: [
      ProductColor(
        imageUrl:
            "https://i.ibb.co/YTRbKqD/01-soederhamn-3-seat-section-gransel-natural-colour-1057493-pe848854-s5.jpg",
        color: Color(0xFFEBE1D8),
      ),
      ProductColor(
        imageUrl:
            "https://i.ibb.co/ZLB8kfW/02-soederhamn-3-seat-section-viarp-beige-brown-0802813-pe768605-s5.jpg",
        color: Color(0xFFCBC7BF),
      )
    ],
  );

  /// JSON 형태의 상품 목록 데이터
  ///
  /// API 응답을 시뮬레이션하기 위한 JSON 문자열입니다.
  /// ProductRepository의 네트워크 통신 테스트에서 사용됩니다.
  ///
  /// 포함 내용:
  /// - 2개의 상품 데이터 (소파 제품들)
  /// - 각 상품의 다국어 정보
  /// - 색상 옵션과 이미지 URL
  /// - 가격 및 평점 정보
  static const String jsonProductList = '''[
    {
      "name": {
        "ko": "3인용 섹션",
        "en": "3-seat section"
      },
      "brand": {
        "ko": "쇠데르함",
        "en": "SÖDERHAMN"
      },
      "desc": {
        "ko": "스타일리시하고 산뜻한 느낌이 좋다면 시트가 깊고 넓은 소파는 어떨까요? 개성을 살려 맞춤 구성한 SÖDERHAMN 쇠데르함 소파에 혼자 또는 가족 모두와 함께 앉아 편안한 휴식을 즐겨보세요.",
        "en": "If you like the stylish airy look, you have to try the deep generous seats. Create your own personal combination of SÖDERHAMN sofa, then sit down and relax – by yourself or together with the whole family."
      },
      "price": 699000,
      "priceUnit": "￦",
      "rating": "4.9",
      "colorList": [
        {
          "imageUrl": "https://i.ibb.co/YTRbKqD/01-soederhamn-3-seat-section-gransel-natural-colour-1057493-pe848854-s5.jpg",
          "hexColor": "0xFFEBE1D8"
        },
        {
          "imageUrl": "https://i.ibb.co/ZLB8kfW/02-soederhamn-3-seat-section-viarp-beige-brown-0802813-pe768605-s5.jpg",
          "hexColor": "0xFFCBC7BF"
        }
      ]
    },
    {
      "name": {
        "ko": "2인용 소파",
        "en": "2-seat sofa"
      },
      "brand": {
        "ko": "페루프",
        "en": "PÄRUP"
      },
      "desc": {
        "ko": "이 커버는 폴리에스테르 소재의 GUNNARED/군나레드 원착 패브릭으로 제작되었습니다. 울과 같은 느낌을 지닌 내구성이 우수한 패브릭으로, 따스한 분위기와 투톤의 멜란지 효과가 특징입니다.",
        "en": "Do you believe in love at first sight? Sleek design, quick assembly and easy-care with a removable and washable cover make it easy to love PÄRUP sofa. Welcoming to all of your loved ones!"
      },
      "price": 499000,
      "priceUnit": "￦",
      "rating": "4.8",
      "colorList": [
        {
          "imageUrl": "https://i.ibb.co/D9dg49Y/06-paerup-3-seat-sofa-gunnared-beige-1041904-pe841184-s5.jpg",
          "hexColor": "0xFFE1DAD1"
        },
        {
          "imageUrl": "https://i.ibb.co/0B9jMft/07-paerup-3-seat-sofa-vissle-dark-green-1041906-pe841186-s5.jpg",
          "hexColor": "0xFF4D6452"
        }
      ]
    }
  ]
  ''';

  /// 테스트용 장바구니 아이템
  ///
  /// CartService의 기능 테스트에 사용되는 기본 장바구니 아이템입니다.
  /// 상품, 색상 인덱스, 수량, 선택 상태 등의 정보를 포함합니다.
  static const CartItem cartItem = CartItem(
    product: product,
    colorIndex: 0, // 첫 번째 색상 선택
    count: 1, // 기본 수량 1개
    isSelected: true, // 선택된 상태
  );
}
