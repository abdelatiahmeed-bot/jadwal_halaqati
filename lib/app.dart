import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:athar/core/localization/app_localizations.dart';
import 'package:athar/core/theme/theme.dart';
import 'package:athar/core/routing/router.dart';

class AtharApp extends ConsumerWidget {
  const AtharApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'جدول حلقتي',
      debugShowCheckedModeBanner: false,
      
      // Theme settings (Olive & Gold accents, custom M3 styles)
      theme: IslamicTheme.buildTheme(Brightness.light),
      darkTheme: IslamicTheme.buildTheme(Brightness.dark),
      themeMode: ThemeMode.light,

      // Routing configuration
      routerConfig: router,

      // Localization delegates
      locale: locale,
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale?.languageCode) {
            return locale;
          }
        }
        return const Locale('ar', ''); // Default to Arabic RTL
      },
    );
  }
}
