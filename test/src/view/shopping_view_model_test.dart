import 'package:flutter_test/flutter_test.dart';
import 'package:house_of_tomorrow/src/repository/product_repository.dart';
import 'package:house_of_tomorrow/src/view/shopping/shopping_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy.dart';
import 'shopping_view_model_test.mocks.dart';

/// ProductRepository Mock 객체 생성
///
/// ViewModel 테스트에서 Repository를 Mock으로 대체하는 이유:
/// 1. ViewModel의 비즈니스 로직에만 집중
/// 2. Repository의 네트워크 호출 결과를 제어 가능
/// 3. 다양한 데이터 시나리오 테스트 가능
@GenerateNiceMocks([MockSpec<ProductRepository>()])
void main() {
  /// 테스트에서 사용할 변수들
  late MockProductRepository productRepository;
  late ShoppingViewModel shoppingViewModel;

  /// ChangeNotifier 패턴 테스트를 위한 변수
  ///
  /// ChangeNotifier 테스트의 중요성:
  /// - UI 상태 변경 알림이 올바르게 발생하는지 확인
  /// - Provider 패턴에서 위젯 리빌드 트리거 검증
  /// - 상태 관리의 정확성 보장
  late int notifyCount;
  void notifyListener() {
    notifyCount++;
  }

  /// 각 테스트 실행 전 초기화
  ///
  /// ViewModel 테스트 설정:
  /// 1. notifyCount 초기화 (리스너 호출 횟수 추적)
  /// 2. Mock Repository 생성
  /// 3. ViewModel 인스턴스 생성 및 리스너 등록
  setUp(() {
    notifyCount = 0;
    productRepository = MockProductRepository();
    shoppingViewModel = ShoppingViewModel(productRepository: productRepository)
      ..addListener(notifyListener); // ChangeNotifier 리스너 등록
  });

  /// 각 테스트 실행 후 정리
  ///
  /// 메모리 누수 방지:
  /// - 리스너 제거로 메모리 누수 방지
  /// - 테스트 간 격리 보장
  tearDown(() {
    shoppingViewModel.removeListener(notifyListener);
  });

  group('ShoppingViewModel', () {
    /// searchProductList() 메서드 테스트 그룹
    ///
    /// ViewModel 테스트의 핵심 요소:
    /// 1. Repository 메서드 호출 검증 (verify)
    /// 2. 상태 변경 검증 (productList 업데이트)
    /// 3. UI 알림 검증 (notifyListeners 호출 횟수)
    group('searchProductList()', () {
      /// ViewModel의 전체 플로우 테스트
      ///
      /// 테스트 시나리오:
      /// 1. Repository에서 상품 목록 조회
      /// 2. 조회 결과를 ViewModel의 productList에 할당
      /// 3. UI에 상태 변경 알림 (notifyListeners 호출)
      ///
      /// 검증 항목:
      /// - Repository 메서드가 정확히 1번 호출되었는지
      /// - productList가 비어있지 않은지
      /// - notifyListeners가 적절한 횟수만큼 호출되었는지
      test('검색 결과를 productList에 할당한 뒤 화면을 갱신한다.', () async {
        // Arrange: Mock Repository의 동작 정의
        when(productRepository.searchProductList('')).thenAnswer(
          (realInvocation) async => [Dummy.product],
        );

        // Act: ViewModel 메서드 실행
        await shoppingViewModel.searchProductList();

        // Assert 1: Repository 메서드 호출 검증
        // verify(): Mock 객체의 특정 메서드가 호출되었는지 확인
        // called(1): 정확히 1번 호출되었는지 검증
        verify(productRepository.searchProductList('')).called(1);

        // Assert 2: 상태 변경 검증
        expect(shoppingViewModel.productList.isNotEmpty, true);

        // Assert 3: UI 알림 검증
        // notifyCount가 2인 이유:
        // 1. 로딩 시작 시 notifyListeners() 호출
        // 2. 데이터 로드 완료 시 notifyListeners() 호출
        expect(notifyCount, 2);
      });
    });
  });
}
