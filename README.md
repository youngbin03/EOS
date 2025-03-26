# 📦 Week 3: Firebase 연동 로그인 구현하기 (Flutter)

---

## 📝 과제 개요
이번 주 과제에서는 Flutter 앱에서 **Firebase Authentication**을 활용하여 아래 기능들을 구현합니다:

- 비밀번호 재설정
- 구글 로그인
- 카카오 로그인

사용자는 다양한 방법으로 앱에 로그인할 수 있으며, Firebase를 통해 인증 상태를 관리할 수 있습니다.

---

## 🎯 학습 목표

- Firebase Authentication을 활용한 비밀번호 재설정 기능 구현
- Google 및 Kakao 소셜 로그인 기능 구현
- Flutter에서 외부 인증 공급자와의 연동 이해
- 사용자 경험을 고려한 인증 UI 설계

---

## 📋 과제 상세 내용

### 1️⃣ 비밀번호 재설정 기능 구현
**기능 설명**: 사용자가 비밀번호를 잊었을 때 이메일을 통해 재설정 메일을 받을 수 있게 합니다.

#### 구현 단계:
1. 이메일 입력 다이얼로그 구현
   - `AlertDialog` 또는 `SimpleDialog` 사용
   - `TextEditingController`로 입력값 관리

2. 비밀번호 재설정 요청 처리
   - `FirebaseAuth.instance.sendPasswordResetEmail()` 사용
   - 이메일 형식 유효성 검증 포함
   - 요청 성공/실패에 따른 사용자 피드백 제공

3. 오류 처리
   - 존재하지 않는 사용자 이메일 등 예외 처리

---

### 2️⃣ 구글 로그인 기능 구현
**기능 설명**: 사용자가 Google 계정으로 앱에 로그인할 수 있게 합니다.

#### 구현 단계:
1. Google 로그인 요청
   - `GoogleSignIn().signIn()` 호출
   - 사용자 계정 선택 및 권한 동의 처리

2. 인증 정보 획득
   - `googleUser.authentication` 호출 → `accessToken`, `idToken` 획득

3. Firebase 인증 연결
   - `GoogleAuthProvider.credential()`로 `OAuthCredential` 생성
   - `FirebaseAuth.instance.signInWithCredential()` 호출로 로그인 완료

4. 성공/실패 처리
   - 성공 시: `onSuccess()` 콜백 호출
   - 실패 시: 오류 유형에 따라 메시지 표시

---

### 3️⃣ 카카오 로그인 기능 구현
**기능 설명**: 사용자가 Kakao 계정으로 앱에 로그인할 수 있게 합니다.

#### 구현 단계:
1. 카카오 SDK 초기화
   - `KakaoSdk.init()` 호출 (`main.dart` 또는 로그인 시점)

2. 로그인 요청 및 토큰 획득
   - `UserApi.instance.loginWithKakaoAccount()` 사용
   - 로그인 성공 시 토큰 확인

3. Firebase Functions 호출
   - 카카오 액세스 토큰을 Firebase 커스텀 토큰으로 교환하는 HTTP 요청
   - 서버가 Firebase 커스텀 토큰을 발급

4. Firebase 인증
   - `FirebaseAuth.instance.signInWithCustomToken()` 호출

5. 성공/실패 처리
   - 성공 시: `onSuccess()` 콜백 호출
   - 실패 시: 오류에 따른 메시지 제공

#### ✅ 예시 함수
```dart
void signInWithKakao() async {
  bool isInstalled = await isKakaoTalkInstalled();
  OAuthToken token = isInstalled
    ? await UserApi.instance.loginWithKakaoTalk()
    : await UserApi.instance.loginWithKakaoAccount();

  final response = await http.get(
    Uri.https('kapi.kakao.com', '/v2/user/me'),
    headers: { HttpHeaders.authorizationHeader: 'Bearer \${token.accessToken}' },
  );
  final profileInfo = json.decode(response.body);
  setState(() { _loginPlatform = LoginPlatform.kakao; });
}
```

```dart
void signOut() async {
  if (_loginPlatform == LoginPlatform.kakao) {
    await UserApi.instance.logout();
  }
  setState(() { _loginPlatform = LoginPlatform.none; });
}
```

---

## 🚀 시작하기

### 🔧 사전 요구사항
- Flutter SDK (최신 버전)
- Firebase 계정
- Kakao 개발자 계정
- Google Cloud Platform 계정

### 💻 설치 방법

1. 저장소 클론:
```bash
git clone [your-repo-url]
```

2. 의존성 설치:
```bash
flutter pub get
```

3. Firebase 설정 파일 추가:
- `firebase_options.dart` → `lib/`에 위치시킴

4. 카카오 및 구글 키 설정:
- `main.dart`에서 SDK 초기화 및 앱 키 설정 확인

5. 앱 실행:
```bash
flutter run
```

---

## 🧪 테스트 및 디버깅

### 🔹 비밀번호 재설정 테스트
- 유효한 이메일 입력 후 → 재설정 메일 수신 확인
- 잘못된 이메일 입력 시 → 오류 메시지 확인

### 🔹 구글 로그인 테스트
- 구글 계정 선택 → 로그인 성공 여부 확인
- 실패 시 오류 피드백 확인

### 🔹 카카오 로그인 테스트
- 카카오톡 설치/미설치 환경 테스트
- 로그인 성공 및 실패 케이스별 메시지 확인

---

## 📚 참고 자료
- [Firebase Authentication 문서](https://firebase.google.com/docs/auth)
- [카카오 개발자 문서](https://developers.kakao.com/docs/latest/ko/kakaologin/flutter)
- [Google Sign-In 문서](https://developers.google.com/identity/sign-in/flutter)
- [Flutter Provider 패키지](https://pub.dev/packages/provider)

---

## 📄 라이센스
이 프로젝트는 MIT 라이센스를 따릅니다. 자세한 내용은 LICENSE 파일을 참조하세요.

---