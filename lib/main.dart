import 'package:eos_advance_login/firebase_options.dart';
import 'package:eos_advance_login/screens/home_screen.dart';
import 'package:eos_advance_login/service/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eos_advance_login/screens/login_screen.dart';
import 'package:eos_advance_login/theme/light_theme.dart';
import 'package:eos_advance_login/theme/foundation/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// TODO: [과제 1-1] Firebase 초기화 코드 구현
/*
 * Firebase 설정 및 초기화 과제
 * 
 * 1. Firebase 프로젝트 설정하기:
 *    - Firebase 콘솔(https://console.firebase.google.com)에서 새 프로젝트 생성
 *    - Flutter 앱을 Firebase에 등록 (Android/iOS 설정 필요)
 *    - 필요한 구성 파일 다운로드 및 배치:
 *      > Android: google-services.json → android/app/
 *      > iOS: GoogleService-Info.plist → ios/Runner/
 * 
 * 2. 필요한 패키지 설치하기:
 *    flutter pub add firebase_core firebase_auth
 * 
 * 3. Firebase 초기화 구현하기:
 *    - main() 함수를 async로 변경
 *    - WidgetsFlutterBinding.ensureInitialized() 호출
 *    - await Firebase.initializeApp() 호출
 *    
 *    예시:
 *    void main() async {
 *      WidgetsFlutterBinding.ensureInitialized();
 *      await Firebase.initializeApp();
 *      runApp(const MyApp());
 *    }
 */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화 수정
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // 필요시 주석 해제
    );
    print('Firebase 초기화 성공');
  } catch (e) {
    print('Firebase 초기화 오류: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

/// 애플리케이션의 루트 위젯
/// - 앱의 전체 테마 및 초기 화면을 설정합니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = LightTheme();

    // TODO: [과제 1-2] 로그인 상태에 따른 화면 분기 처리
    /*
     * 인증 상태 관리 과제
     * 
     * 사용자의 로그인 상태에 따라 적절한 화면을 보여주는 기능을 구현하세요.
     * 
     * 구현 방법:
     * 1. currentUser를 활용한 로그인 유지:
     *    - FirebaseAuth.instance.currentUser != null 확인
     *    - 앱 시작 시 이전 로그인 세션이 유효한지 확인
     *    - 유효하면 자동으로 HomeScreen으로 이동
     * 
     * 2. 조건부 라우팅 구현하기:
     *    - 로그인 상태: HomeScreen 표시
     *    - 로그아웃 상태: LoginScreen 표시
     * 
     * 참고: 아래 MaterialApp의 home 속성을 수정하여 StreamBuilder를 반환하도록 변경
     */

    return MaterialApp(
      title: 'EOS Advance Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: theme.color.primary),
        useMaterial3: true,
        fontFamily: 'Pretendard', // 프리텐다드 폰트 기본 적용
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 인증 상태 확인 중일 때 로딩 표시
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // 로그인된 유저가 있으면 HomeScreen, 없으면 LoginScreen
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
