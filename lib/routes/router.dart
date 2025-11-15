import 'package:cargo_app/auth/loginScreen.dart';
import 'package:cargo_app/screen/profile/profileScreen.dart';
import 'package:cargo_app/screen/profile/riwayatScreen.dart';
import 'package:cargo_app/splash/splashScreen.dart';
import 'package:cargo_app/screen/beranda/berandaScreen.dart';
import 'package:cargo_app/screen/beranda/scanScreen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/Login', builder: (context, state) => const LoginScreen()),
    //GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/beranda',
      builder: (context, state) => const BerandaKurirScreen(),
    ),
    GoRoute(
      path: '/riwayat',
      builder: (context, state) => const RiwayatKurirScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileKurirScreen(),
    ),
    GoRoute(
      path: '/foto_kurir',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final resi = args?['resi'] ?? '';
        return FotoKurirScreen(resi: resi);
      },
    ),
  ],
);
