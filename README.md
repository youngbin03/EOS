# House of Tomorrow 🏠

[![Flutter CI/CD](https://github.com/your-username/house_of_tomorrow/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/your-username/house_of_tomorrow/actions/workflows/flutter_ci.yml)
[![codecov](https://codecov.io/gh/your-username/house_of_tomorrow/branch/main/graph/badge.svg)](https://codecov.io/gh/your-username/house_of_tomorrow)

미래의 집을 위한 Flutter 애플리케이션입니다.

## 🚀 시작하기

### 필수 요구사항
- Flutter SDK 3.24.0 이상
- Dart SDK 3.5.0 이상
- Android Studio / VS Code
- iOS 개발을 위한 Xcode (macOS만)

### 설치 및 실행

1. **저장소 클론**
   ```bash
   git clone https://github.com/your-username/house_of_tomorrow.git
   cd house_of_tomorrow
   ```

2. **의존성 설치**
   ```bash
   flutter pub get
   ```

3. **Mock 파일 생성**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **앱 실행**
   ```bash
   flutter run
   ```

## 🧪 테스트

### 단위 테스트
```bash
# 모든 단위 테스트 실행
flutter test

# 커버리지와 함께 테스트 실행
flutter test --coverage

# 특정 테스트 파일 실행
flutter test test/src/service/cart_service_test.dart
```

### 위젯 테스트
```bash
# 위젯 테스트 실행
flutter test test/src/view/

# Golden 파일 업데이트
flutter test --update-goldens
```

### 통합 테스트
```bash
# iOS 시뮬레이터에서 실행
flutter test integration_test/app_test.dart

# Android 에뮬레이터에서 실행
flutter test integration_test/app_test.dart -d android

# 특정 디바이스에서 실행
flutter devices  # 사용 가능한 디바이스 확인
flutter test integration_test/app_test.dart -d [device-id]
```

### 코드 품질 검사
```bash
# 정적 분석
flutter analyze

# 코드 포맷팅 검사
dart format --output=none --set-exit-if-changed .

# 코드 포맷팅 적용
dart format .
```

## 🔄 CI/CD 파이프라인

이 프로젝트는 GitHub Actions를 사용한 완전한 CI/CD 파이프라인을 포함합니다:

### 워크플로우 단계

1. **🧪 테스트 및 분석**
   - 코드 포맷팅 검사
   - 정적 분석 (flutter analyze)
   - Mock 파일 생성
   - 단위 테스트 실행
   - 테스트 커버리지 업로드

2. **🎨 위젯 테스트**
   - Golden 테스트 실행
   - UI 스냅샷 검증

3. **🤖 Android 통합 테스트**
   - Android 에뮬레이터에서 통합 테스트 실행

4. **🍎 iOS 통합 테스트**
   - iOS 시뮬레이터에서 통합 테스트 실행

5. **🏗️ 빌드 테스트**
   - Android APK 빌드
   - Web 빌드

6. **🚀 배포** (main 브랜치만)
   - 프로덕션 빌드 생성
   - 아티팩트 업로드

### 트리거 조건
- Pull Request 생성/업데이트 (main, develop 브랜치)
- main 브랜치에 push
- 수동 실행 (workflow_dispatch)

## 📁 프로젝트 구조

```
lib/
├── src/
│   ├── model/          # 데이터 모델
│   ├── service/        # 비즈니스 로직 서비스
│   ├── view/           # UI 컴포넌트 및 뷰모델
│   └── repository/     # 데이터 저장소
├── main.dart           # 앱 진입점
└── theme/              # 테마 설정

test/
├── src/
│   ├── model/          # 모델 테스트
│   ├── service/        # 서비스 테스트
│   ├── view/           # 위젯 테스트
│   └── repository/     # 저장소 테스트
└── test_utils/         # 테스트 유틸리티

integration_test/
└── app_test.dart       # 통합 테스트

.github/
└── workflows/
    └── flutter_ci.yml  # CI/CD 워크플로우
```

## 🛠️ 개발 도구

### Mock 생성
이 프로젝트는 `mockito`와 `build_runner`를 사용하여 테스트용 Mock 객체를 생성합니다:

```bash
# Mock 파일 생성
dart run build_runner build

# 기존 파일 삭제 후 재생성
dart run build_runner build --delete-conflicting-outputs

# 변경사항 감지하여 자동 재생성
dart run build_runner watch
```

### 코드 생성
```bash
# 모든 코드 생성 (JSON serialization, Mock 등)
dart run build_runner build --delete-conflicting-outputs
```

## 📊 테스트 커버리지

테스트 커버리지는 Codecov를 통해 추적됩니다. 커버리지 리포트는 각 Pull Request에서 자동으로 생성됩니다.

로컬에서 커버리지 확인:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### 코딩 스타일
- `dart format`을 사용하여 코드 포맷팅
- `flutter analyze`로 정적 분석 통과
- 모든 새로운 기능에 대한 테스트 작성
- 커밋 메시지는 한글 또는 영어로 명확하게 작성

## 📝 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참조하세요.

## 📚 추가 리소스

- [Flutter 공식 문서](https://docs.flutter.dev/)
- [Dart 언어 가이드](https://dart.dev/guides)
- [Flutter 테스팅 가이드](https://docs.flutter.dev/testing)
- [GitHub Actions 문서](https://docs.github.com/en/actions)
