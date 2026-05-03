import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/sticker_provider.dart';
import 'providers/tournament_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  final stickerProvider = StickerProvider();
  await stickerProvider.load();
  final tournamentProvider = TournamentProvider();
  await tournamentProvider.load();
  runApp(PaniniApp(
    stickerProvider: stickerProvider,
    tournamentProvider: tournamentProvider,
  ));
}

class PaniniApp extends StatelessWidget {
  final StickerProvider stickerProvider;
  final TournamentProvider tournamentProvider;
  const PaniniApp({
    super.key,
    required this.stickerProvider,
    required this.tournamentProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: stickerProvider),
        ChangeNotifierProvider.value(value: tournamentProvider),
      ],
      child: MaterialApp(
        title: 'Panini FIFA 2026',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
