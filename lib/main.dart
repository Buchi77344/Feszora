import 'package:feszora/page/invoice/invoice_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feszora/layout/mode.dart';
import 'package:feszora/page/dash.dart';
import 'package:feszora/page/notification.dart';
import 'package:feszora/page/report.dart';
import 'package:feszora/page/signin.dart';
import 'package:feszora/page/signup.dart';
import 'package:feszora/page/invoice/create_invoice.dart';
import 'package:feszora/page/settings.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Feszora',
          debugShowCheckedModeBanner: false,
          // ✅ Keep your same light/dark theme setup
          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 2,
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shadowColor: Colors.black12,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[900],
              surfaceTintColor: Colors.transparent,
              elevation: 2,
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shadowColor: Colors.black,
              surfaceTintColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            scaffoldBackgroundColor: Colors.grey[900],
          ),
          themeMode: themeProvider.themeMode, // supports light/dark switching
          home: const DashPage(),
          routes: {
            '/login': (context) => const LoginPage(),
            '/signup': (context) => const SignupPage(),
            '/notified': (context) => const NotificationPage(),
            '/report': (context) => const ReportPage(),
            '/settings': (context) => const SettingsPage(),
            '/invoice': (context) => const InvoicePage(),
             '/invoice-list': (context) => const InvoiceListPage(),
          },
        );
      },
    );
  }
}
