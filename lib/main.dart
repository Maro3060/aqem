import 'package:aqem/core/providers/shared_prefs_provider.dart';
import 'package:aqem/features/azkar_screen/data/dua_data.dart';
import 'package:aqem/features/home_screen/presentation/providers/theme_providers.dart';
import 'package:aqem/features/starter_screen/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:aqem/core/theme/dynamic_color.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aqem/core/services/notification_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  TimeThemeManager.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await NotificationService.init();
  await initDuaData();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: const AqemApp(),
      ),
    ),
  );
}

class AqemApp extends ConsumerWidget {
  const AqemApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final themeAsync = ref.watch(themeNotifierProvider);

    final themeMode = themeAsync.maybeWhen(
      data: (t) => t.flutterThemeMode,
      orElse: () => ThemeMode.system,
    );

    return ValueListenableBuilder(
      valueListenable: TimeThemeManager.currentColorNotifier,
      builder: (context, dynamicColor, child) {
        final schemes = TimeThemeManager.getSchemes(dynamicColor);
        final light = schemes[0];
        final dark = schemes[1];
        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          builder: (_, _) {
            return MaterialApp(
              title: 'Aqem',
              theme: ThemeData(
                colorScheme: light,
                iconButtonTheme: IconButtonThemeData(
                  style: ButtonStyle(
                    iconSize: WidgetStateProperty.all(20),
                    iconColor: WidgetStateProperty.all(Colors.white),
                  ),
                ),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: dark,
                iconButtonTheme: IconButtonThemeData(
                  style: ButtonStyle(
                    iconSize: WidgetStateProperty.all(20),
                    iconColor: WidgetStateProperty.all(Colors.white),
                  ),
                ),
                progressIndicatorTheme: ProgressIndicatorThemeData(
                  linearTrackColor: Colors.blue,
                ),
                useMaterial3: true,
              ),
              themeMode: themeMode,
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
              locale: Locale('ar', 'EG'),
              supportedLocales: [Locale('ar', 'EG'), Locale('en', 'US')],
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          },
        );
      },
    );
  }
}
