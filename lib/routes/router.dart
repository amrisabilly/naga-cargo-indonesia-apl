import 'package:cargo_app/auth/login.dart';
import 'package:cargo_app/landing/landing.dart';
import 'package:cargo_app/presentations/kurir/beranda/beranda-kurir.dart';
import 'package:cargo_app/presentations/kurir/beranda/foto-kurir.dart';
import 'package:cargo_app/presentations/pic/beranda/beranda-pic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/beranda_kurir',
      builder: (context, state) => const BerandaKurirScreen(),
    ),
    GoRoute(
      path: '/beranda_pic',
      builder: (context, state) => const BerandaPicScreen(),
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
