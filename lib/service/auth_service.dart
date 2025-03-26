import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  // Google 로그인 기능
  Future<void> signInWithGoogle({
    required Function() onSuccess,
    required Function(String err) onError,
  }) async {
    try {
      // Google 로그인 과정 시작
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // 사용자가 로그인 과정을 취소한 경우
      if (googleUser == null) {
        onError('구글 로그인이 취소되었습니다.');
        return;
      }

      try {
        // 인증 정보 얻기
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // 구글 OAuth 자격 증명 생성
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Firebase에 구글 자격 증명으로 로그인
        await FirebaseAuth.instance.signInWithCredential(credential);

        // 로그인 성공
        onSuccess();
        notifyListeners();
      } catch (authError) {
        print('구글 인증 단계 오류: $authError');
        onError('구글 계정 인증 중 오류가 발생했습니다.');
      }
    } catch (e) {
      print('구글 로그인 오류: $e');
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'account-exists-with-different-credential':
            onError('이미 다른 방법으로 가입된 계정입니다.');
            break;
          case 'invalid-credential':
            onError('잘못된 인증 정보입니다.');
            break;
          case 'operation-not-allowed':
            onError('구글 로그인이 활성화되지 않았습니다. 관리자에게 문의하세요.');
            break;
          case 'user-disabled':
            onError('사용자 계정이 비활성화되었습니다.');
            break;
          case 'user-not-found':
            onError('사용자 계정이 존재하지 않습니다.');
            break;
          case 'network-request-failed':
            onError('네트워크 연결에 실패했습니다. 인터넷 연결을 확인해주세요.');
            break;
          default:
            onError('구글 로그인 중 오류가 발생했습니다: ${e.code}');
            break;
        }
      } else {
        onError('구글 로그인 중 예상치 못한 오류가 발생했습니다: ${e.toString()}');
      }
    }
  }
}
