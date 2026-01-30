import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/app_theme.dart';
import 'providers/fabric_provider.dart';
import 'providers/visualizer_provider.dart';
import 'providers/saved_designs_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MafatlalVisualizerApp());
}

class MafatlalVisualizerApp extends StatelessWidget {
  const MafatlalVisualizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FabricProvider()),
        ChangeNotifierProvider(create: (_) => VisualizerProvider()),
        ChangeNotifierProvider(create: (_) => SavedDesignsProvider()),
      ],
      child: MaterialApp(
        title: 'Mafatlal Visualizer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
