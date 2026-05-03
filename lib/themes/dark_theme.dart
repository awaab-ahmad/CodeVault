import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF0F0F14),
  colorScheme: .fromSeed(
    seedColor: const Color(0xFFFFFFFF),
    primary: const Color(0xFF1A1A26),
    onPrimary: const Color.fromARGB(255, 2, 2, 20),
    onPrimaryContainer: const Color(0xFF6C63FF),
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF676767),
    secondary: const Color(0xFFA78BFA),
    onSecondary: const Color(0xFF6C63FF),
    error: const Color(0xFFF7C948),
    onError: const Color(0xFF3B82F6),
    onErrorContainer: const Color(0xFF34D399),
  ),
);
