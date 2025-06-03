import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_of_tomorrow/src/service/cart_service.dart';
import 'package:house_of_tomorrow/src/service/theme_service.dart';
import 'package:house_of_tomorrow/theme/component/cart_button.dart';
import 'package:provider/provider.dart';

import '../../dummy.dart';

/// CartButton 위젯 테스트
///
/// 위젯 테스트(Widget Test)는 Flutter의 3가지 테스트 유형 중 하나입니다:
/// 1. Unit Test: 개별 함수, 메서드, 클래스 테스트
/// 2. Widget Test: 단일 위젯의 UI와 상호작용 테스트 ← 현재 파일
/// 3. Integration Test: 전체 앱의 통합 테스트
///
/// 위젯 테스트의 특징:
/// - 실제 디바이스 없이 위젯의 렌더링과 동작을 검증
/// - 사용자 상호작용 시뮬레이션 가능 (탭, 스크롤 등)
/// - 위젯 트리에서 특정 요소 찾기 및 검증
void main() {
  group('CartButton', () {
    testWidgets('장바구니에 담긴 상품 개수를 보여준다.', (tester) async {
      /// Golden Test를 위한 폰트 로드
      ///
      /// Golden Test는 위젯의 시각적 출력을 픽셀 단위로 비교하는 테스트입니다.
      /// 폰트가 로드되지 않으면 텍스트 렌더링이 달라져 테스트가 실패할 수 있습니다.
      /// 따라서 일관된 시각적 결과를 위해 폰트를 명시적으로 로드합니다.
      final font = rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
      final fontLoader = FontLoader('noto_sans')..addFont(font);
      await fontLoader.load();

      /// 테스트용 위젯 트리 구성
      ///
      /// Provider 패턴을 사용하는 위젯을 테스트하기 위해:
      /// 1. MultiProvider로 필요한 서비스들을 주입
      /// 2. MaterialApp으로 Material Design 컨텍스트 제공
      /// 3. 테스트 대상 위젯(CartButton)을 중앙에 배치
      final cartService = CartService();
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => ThemeService(),
            ),
            ChangeNotifierProvider(
              create: (context) => cartService,
            ),
          ],
          child: const MaterialApp(
            home: Center(child: CartButton()),
          ),
        ),
      );

      /// 장바구니에 상품 추가 및 상태 변경 테스트
      ///
      /// 1. cartService.add(): 장바구니에 동일한 상품을 2번 추가
      /// 2. pumpAndSettle(): 모든 애니메이션과 상태 변경이 완료될 때까지 대기
      ///    - pump(): 한 프레임만 진행
      ///    - pumpAndSettle(): 모든 애니메이션이 끝날 때까지 대기
      cartService.add(Dummy.cartItem);
      cartService.add(Dummy.cartItem);
      await tester.pumpAndSettle();

      /// 위젯 트리에서 특정 텍스트 찾기 및 검증
      ///
      /// find.text("2"): 위젯 트리에서 "2"라는 텍스트를 가진 위젯 검색
      /// findsOneWidget: 정확히 하나의 위젯이 발견되어야 함을 검증
      ///
      /// 다른 Finder 옵션들:
      /// - findsNothing: 위젯이 발견되지 않아야 함
      /// - findsWidgets: 하나 이상의 위젯이 발견되어야 함
      /// - findsNWidgets(n): 정확히 n개의 위젯이 발견되어야 함
      expect(
        find.text("2"),
        findsOneWidget,
      );

      /// Golden Test: 위젯의 시각적 출력 검증
      ///
      /// Golden Test는 위젯의 렌더링 결과를 이미지 파일과 비교합니다:
      /// 1. 첫 실행 시 "flutter test --update-goldens" 명령으로 기준 이미지 생성
      /// 2. 이후 테스트에서는 현재 렌더링과 기준 이미지를 픽셀 단위로 비교
      /// 3. 차이가 있으면 테스트 실패
      ///
      /// 장점:
      /// - UI 변경사항을 자동으로 감지
      /// - 의도하지 않은 시각적 회귀(regression) 방지
      /// - 디자인 일관성 유지
      ///
      /// 주의사항:
      /// - 플랫폼별로 렌더링이 다를 수 있음
      /// - 폰트, 해상도 등의 환경 요소에 민감
      await expectLater(
        find.byType(CartButton),
        matchesGoldenFile('cart_button_golden_test.png'),
      );
    }, tags: ['golden']);
  });
}
