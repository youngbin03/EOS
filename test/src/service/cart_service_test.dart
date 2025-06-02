import 'package:flutter_test/flutter_test.dart';
import 'package:house_of_tomorrow/src/model/cart_item.dart';
import 'package:house_of_tomorrow/src/service/cart_service.dart';

import '../../dummy.dart';

/// CartService 단위 테스트
///
/// 단위 테스트(Unit Test)는 소프트웨어의 가장 작은 단위인 개별 함수나 메서드를 테스트합니다.
///
/// 단위 테스트의 특징:
/// 1. 빠른 실행 속도 (UI 렌더링 없음)
/// 2. 외부 의존성 최소화 (Mock 객체 사용)
/// 3. 특정 기능의 정확성 검증
/// 4. 코드 변경 시 회귀 버그 방지
///
/// 테스트 구조 (AAA 패턴):
/// - Arrange: 테스트 환경 설정
/// - Act: 테스트 대상 실행
/// - Assert: 결과 검증
void main() {
  /// 테스트 간 공유되는 변수
  /// late 키워드: 나중에 초기화될 것임을 명시 (null safety)
  late CartService cartService;

  /// setUp(): 각 테스트 실행 전에 호출되는 초기화 함수
  ///
  /// 테스트 격리(Test Isolation) 원칙:
  /// - 각 테스트는 독립적으로 실행되어야 함
  /// - 이전 테스트의 결과가 다음 테스트에 영향을 주면 안됨
  /// - setUp()으로 매번 새로운 인스턴스를 생성하여 격리 보장
  setUp(() {
    cartService = CartService();
  });

  group('CartService', () {
    /// add() 메서드 테스트 그룹
    ///
    /// group(): 관련된 테스트들을 논리적으로 묶어서 관리
    /// 테스트 결과 출력 시 계층 구조로 표시되어 가독성 향상
    group('add()', () {
      /// 기본 기능 테스트: 새로운 아이템 추가
      ///
      /// 테스트 시나리오:
      /// 1. 빈 장바구니에 상품 추가
      /// 2. 장바구니 길이가 1이 되는지 확인
      test('신규 CartItem을 cartItemList에 추가한다.', () {
        // Arrange: 테스트 환경 준비 (setUp에서 이미 완료)

        // Act: 테스트 대상 메서드 실행
        cartService.add(Dummy.cartItem);

        // Assert: 결과 검증
        expect(cartService.cartItemList.length, 1);
      });
    });

    /// selectedCartItemList getter 테스트 그룹
    ///
    /// Getter 테스트의 중요성:
    /// - 비즈니스 로직이 포함된 계산 프로퍼티 검증
    /// - 필터링, 변환 등의 로직 정확성 확인
    group('selectedCartItemList', () {
      /// 필터링 로직 테스트: 선택된 아이템만 반환
      ///
      /// 테스트 시나리오:
      /// 1. 선택된 아이템 2개, 선택되지 않은 아이템 1개 추가
      /// 2. selectedCartItemList가 선택된 아이템 2개만 반환하는지 확인
      /// 3. 반환된 모든 아이템의 isSelected가 true인지 확인
      test('isSelected가 true인 CartItem만 반환한다.', () {
        // Arrange: 다양한 선택 상태의 아이템들 추가
        cartService.add(Dummy.cartItem.copyWith(isSelected: true));
        cartService.add(Dummy.cartItem.copyWith(isSelected: true));
        cartService.add(Dummy.cartItem.copyWith(isSelected: false));

        // Act & Assert: getter 호출 및 결과 검증
        expect(cartService.selectedCartItemList.length, 2);

        // 반환된 모든 아이템이 선택 상태인지 확인
        for (final cartItem in cartService.selectedCartItemList) {
          expect(cartItem.isSelected, true);
        }
      });
    });

    /// update() 메서드 테스트 그룹
    ///
    /// 상태 변경 테스트의 중요성:
    /// - 데이터 무결성 보장
    /// - 인덱스 기반 업데이트의 정확성 검증
    group('update()', () {
      /// 특정 인덱스 아이템 수정 테스트
      ///
      /// 테스트 시나리오:
      /// 1. 장바구니에 아이템 추가
      /// 2. 수량을 100으로 변경한 새 아이템 생성
      /// 3. 0번 인덱스 아이템을 새 아이템으로 업데이트
      /// 4. 업데이트가 정확히 적용되었는지 확인
      test('선택한 index의 CartItem을 수정한다.', () {
        // Arrange: 초기 아이템 추가
        cartService.add(Dummy.cartItem);

        // 수정할 새로운 아이템 생성 (copyWith 패턴 사용)
        CartItem newCartItem = Dummy.cartItem.copyWith(
          count: 100,
        );

        // Act: 특정 인덱스의 아이템 업데이트
        cartService.update(0, newCartItem);

        // Assert: 업데이트 결과 검증
        expect(cartService.cartItemList[0], newCartItem);
      });
    });

    /// delete() 메서드 테스트 그룹
    ///
    /// 삭제 로직 테스트:
    /// - 복수 아이템 삭제 기능 검증
    /// - 선택된 아이템만 삭제되는지 확인
    /// - 삭제 후 남은 아이템들의 상태 검증
    group('delete()', () {
      /// 선택된 아이템들 일괄 삭제 테스트
      ///
      /// 테스트 시나리오:
      /// 1. 선택된 아이템 2개, 선택되지 않은 아이템 2개 추가
      /// 2. 선택된 아이템들을 삭제
      /// 3. 장바구니에 선택되지 않은 아이템 2개만 남아있는지 확인
      /// 4. 남은 아이템들이 모두 선택되지 않은 상태인지 확인
      test('deleteList에 포함된 cartItemList의 CartItem을 삭제한다.', () {
        // Arrange: 다양한 선택 상태의 아이템들 추가
        cartService.add(Dummy.cartItem.copyWith(isSelected: true));
        cartService.add(Dummy.cartItem.copyWith(isSelected: true));
        cartService.add(Dummy.cartItem.copyWith(isSelected: false));
        cartService.add(Dummy.cartItem.copyWith(isSelected: false));

        // Act: 선택된 아이템들 삭제
        cartService.delete(cartService.selectedCartItemList);

        // Assert: 삭제 결과 검증
        expect(cartService.cartItemList.length, 2);

        // 남은 아이템들이 모두 선택되지 않은 상태인지 확인
        for (final cartItem in cartService.cartItemList) {
          expect(cartItem.isSelected, false);
        }
      });
    });
  });
}
