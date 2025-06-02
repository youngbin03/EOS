import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:house_of_tomorrow/src/repository/product_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy.dart';
import 'product_repository_test.mocks.dart';

/// Mock 객체 생성을 위한 어노테이션
///
/// @GenerateNiceMocks: Mockito 라이브러리를 사용하여 Mock 클래스를 자동 생성
/// - MockSpec<Dio>(): Dio 클래스의 Mock 버전을 생성
/// - 실제 네트워크 호출 없이 테스트 가능
/// - 다양한 응답 시나리오를 시뮬레이션 가능
///
/// Mock 객체의 장점:
/// 1. 외부 의존성 제거 (네트워크, 데이터베이스 등)
/// 2. 테스트 실행 속도 향상
/// 3. 다양한 에러 상황 시뮬레이션 가능
/// 4. 테스트 결과의 일관성 보장
@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  /// 테스트에서 사용할 Mock 객체와 테스트 대상 인스턴스
  late MockDio dio;
  late ProductRepository productRepository;

  /// 각 테스트 실행 전 초기화
  ///
  /// 의존성 주입(Dependency Injection) 패턴:
  /// - ProductRepository에 실제 Dio 대신 MockDio를 주입
  /// - 이를 통해 네트워크 호출을 제어하고 예측 가능한 테스트 환경 구성
  setUp(() {
    dio = MockDio();
    productRepository = ProductRepository(dio: dio);
  });

  group('ProductRepository', () {
    /// searchProductList() 메서드 테스트 그룹
    ///
    /// 네트워크 통신 테스트의 핵심:
    /// 1. 성공 케이스: 정상적인 데이터 반환
    /// 2. 실패 케이스: 네트워크 오류 처리
    /// 3. 비즈니스 로직: 검색 필터링 기능
    group('searchProductList()', () {
      /// 네트워크 통신 성공 시나리오 테스트
      ///
      /// Mock 객체 동작 정의:
      /// when().thenAnswer(): Mock 객체의 특정 메서드 호출 시 반환값 정의
      /// - when(dio.get(url)): dio.get() 메서드가 특정 URL로 호출될 때
      /// - thenAnswer(): 비동기 응답을 시뮬레이션
      /// - Response 객체: 실제 HTTP 응답과 동일한 구조로 생성
      test('통신 성공시 List<Product>를 반환한다.', () async {
        // Arrange: Mock 객체의 동작 정의
        when(dio.get(productRepository.searchProductListUrl)).thenAnswer(
          (realInvocation) async => Response(
            data: Dummy.jsonProductList, // 성공 응답 데이터
            statusCode: 200, // HTTP 성공 상태 코드
            requestOptions: RequestOptions(),
          ),
        );

        // Act: 테스트 대상 메서드 실행
        final results = await productRepository.searchProductList('');

        // Assert: 결과 검증
        expect(results.isNotEmpty, true);
      });

      /// 네트워크 통신 실패 시나리오 테스트
      ///
      /// 에러 처리 테스트의 중요성:
      /// - 네트워크 오류, 서버 오류 등 예외 상황 대응
      /// - 사용자에게 적절한 피드백 제공
      /// - 앱 크래시 방지
      test('통신 실패시 빈 배열을 반환한다.', () async {
        // Arrange: 실패 응답 시뮬레이션
        when(dio.get(productRepository.searchProductListUrl)).thenAnswer(
          (realInvocation) async => Response(
            data: '', // 빈 응답 데이터
            statusCode: 500, // HTTP 서버 오류 상태 코드
            requestOptions: RequestOptions(),
          ),
        );

        // Act: 테스트 대상 메서드 실행
        final results = await productRepository.searchProductList('');

        // Assert: 빈 배열 반환 확인
        expect(results.isEmpty, true);
      });

      /// 검색 필터링 로직 테스트
      ///
      /// 비즈니스 로직 테스트:
      /// - 키워드 검색 기능의 정확성 검증
      /// - 대소문자 구분 없는 검색 확인
      /// - 상품명과 브랜드명 모두에서 검색되는지 확인
      test('이름이나 브랜드에 해당 키워드가 포함된 Product만 반환한다.', () async {
        // Arrange: 성공 응답 설정
        when(dio.get(productRepository.searchProductListUrl)).thenAnswer(
          (realInvocation) async => Response(
            data: Dummy.jsonProductList,
            statusCode: 200,
            requestOptions: RequestOptions(),
          ),
        );

        // Act: 특정 키워드로 검색 실행
        final keyword = "3";
        final results = await productRepository.searchProductList(keyword);

        // Assert: 검색 결과 검증
        // 반환된 모든 상품이 키워드를 포함하는지 확인
        for (final result in results) {
          expect(
            "${result.name}${result.brand}"
                .toLowerCase() // 대소문자 구분 없는 검색
                .contains(keyword.toLowerCase()), // 키워드 포함 여부 확인
            true,
          );
        }
      });
    });
  });
}
