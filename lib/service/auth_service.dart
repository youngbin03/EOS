import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class AuthService extends ChangeNotifier {
  User? currentUser() {
    // 현재 유저(로그인 되지 않은 경우 null 반환)
    return FirebaseAuth.instance.currentUser;
  }

  void signUp({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function() onSuccess, // 가입 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    // 회원가입
    if (email.isEmpty || password.isEmpty) {
      onError('이메일과 비밀번호를 입력해주세요.');
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess();
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            onError('이미 사용 중인 이메일입니다. 다른 이메일을 사용하거나 로그인을 시도해보세요.');
            break;
          case 'weak-password':
            onError('비밀번호가 너무 약합니다. 6자리 이상으로 문자, 숫자, 특수문자를 조합해 보세요.');
            break;
          case 'invalid-email':
            onError('유효하지 않은 이메일 형식입니다. 정확한 이메일 주소를 입력해주세요.');
            break;
          case 'operation-not-allowed':
            onError('이메일/비밀번호 계정이 비활성화되어 있습니다. 관리자에게 문의하세요.');
            break;
          case 'network-request-failed':
            onError('네트워크 연결에 실패했습니다. 인터넷 연결을 확인해주세요.');
            break;
          default:
            onError('회원가입 중 오류가 발생했습니다. (오류 코드: ${e.code})');
            break;
        }
      } else {
        onError('회원가입 중 예상치 못한 오류가 발생했습니다: ${e.toString()}');
      }
    }
  }

  void signIn({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function() onSuccess, // 로그인 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    // 로그인
    if (email.isEmpty || password.isEmpty) {
      onError('이메일과 비밀번호를 입력해주세요.');
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess();
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            onError('유효하지 않은 이메일 형식입니다.');
            break;
          case 'wrong-password':
            onError('비밀번호가 일치하지 않습니다.');
            break;
          case 'user-not-found':
            onError('존재하지 않는 이메일입니다.');
            break;
          default:
            onError('로그인 중 오류가 발생했습니다.');
            break;
        }
      } else {
        onError('로그인 중 오류가 발생했습니다.');
      }
    }
  }

  void signOut() async {
    // 로그아웃
  }

  // TODO: [과제 1-2] Google 로그인 및 Firebase 연동 메서드 구현
  Future<void> signInWithGoogle({
    required Function() onSuccess,
    required Function(String err) onError,
  }) async {
    try {
      // 1. GoogleSignIn 인스턴스 생성 및 로그인 요청
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // 사용자가 로그인 과정을 취소한 경우
      if (googleUser == null) {
        onError('구글 로그인이 취소되었습니다.');
        return;
      }

      try {
        // 2. 인증 정보 획득
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // 3. Firebase 인증 정보 생성
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // 4. Firebase 인증 완료
        await FirebaseAuth.instance.signInWithCredential(credential);

        // 5. 성공 처리
        onSuccess();
        notifyListeners(); // 상태 변경 알림
      } catch (authError) {
        print('구글 인증 오류: $authError');
        onError('구글 계정 인증 중 오류가 발생했습니다.');
      }
    } catch (e) {
      print('구글 로그인 오류: $e');
      onError('구글 로그인 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  // TODO: [과제 2-2] 카카오 로그인 및 Firebase 연동 메서드 구현
  Future<void> signInWithKakao({
    required Function() onSuccess,
    required Function(String err) onError,
  }) async {
    try {
      // 1. 카카오톡 설치 여부 확인 및 로그인 진행
      late kakao.OAuthToken token;

      // 카카오톡 앱이 설치되어 있는지 확인
      if (await kakao.isKakaoTalkInstalled()) {
        // 카카오톡 앱으로 로그인 시도
        try {
          token = await kakao.UserApi.instance.loginWithKakaoTalk();
          print('카카오톡 앱으로 로그인 성공');
        } catch (error) {
          // 앱 로그인 실패 시 계정으로 로그인 시도
          print('카카오톡 앱 로그인 실패, 계정으로 시도: $error');
          token = await kakao.UserApi.instance.loginWithKakaoAccount();
        }
      } else {
        // 카카오톡 앱이 설치되어 있지 않은 경우 계정으로 로그인 시도
        print('카카오톡 미설치, 계정으로 로그인 시도');
        token = await kakao.UserApi.instance.loginWithKakaoAccount();
      }

      // 2. 토큰 검증
      if (token.accessToken.isEmpty) {
        onError('카카오 로그인 토큰 발급 실패');
        return;
      }

      // 3. 카카오 사용자 정보 가져오기
      kakao.User kakaoUser = await kakao.UserApi.instance.me();
      print('카카오 사용자 정보 획득: ${kakaoUser.id}');

      // 4. Firebase OAuthProvider 생성 및 인증
      try {
        // OIDCProvider로 카카오 인증 정보 생성
        final provider = OAuthProvider("oidc.kakao");
        final credential = provider.credential(
          idToken: token.idToken, // OIDC 인증을 위한 ID 토큰
          accessToken: token.accessToken, // 접근 토큰
        );

        // Firebase로 인증 진행
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // 로그인 시 사용자 이름 설정 (없는 경우 기본값 제공)
        await userCredential.user?.updateProfile(
            displayName:
                kakaoUser.kakaoAccount?.profile?.nickname ?? "카카오 사용자");

        // 사용자 정보 다시 로드하여 최신 상태 유지
        await userCredential.user?.reload();

        print('Firebase 인증 완료: ${userCredential.user?.uid}');

        // 5. 성공 처리
        onSuccess();
        notifyListeners(); // 상태 변경 알림
      } catch (authError) {
        print('Firebase 인증 오류: $authError');
        onError('카카오 계정으로 Firebase 인증 중 오류가 발생했습니다.');
      }
    } catch (e) {
      print('카카오 로그인 오류: $e');

      // 오류 유형에 따른 메시지 구분
      if (e is kakao.KakaoAuthException) {
        onError('카카오 인증 오류: ${e.message}');
      } else if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            onError('이미 다른 방식으로 가입된 계정입니다. 다른 로그인 방법을 시도해보세요.');
            break;
          case 'invalid-credential':
            onError('유효하지 않은 인증 정보입니다.');
            break;
          default:
            onError('Firebase 인증 오류: ${e.message}');
        }
      } else {
        onError('카카오 로그인 중 오류가 발생했습니다: ${e.toString()}');
      }
    }
  }
}
