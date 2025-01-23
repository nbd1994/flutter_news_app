import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider.value(
//       value: AuthService().authStateChanges,
//       initialData: null,
//       child: MaterialApp(
//         title: 'News App',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           useMaterial3: true,
//           cardTheme: CardTheme(
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//         debugShowCheckedModeBanner: false,
//         routes: AppRoutes.getRoutes(),
//         initialRoute: '/',
//       ),
//     );
//   }
// }
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthService>(
      future: AuthService.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final authService = snapshot.data!;

        return StreamProvider<User?>.value(
          value: authService.authStateChanges,
          initialData: null,
          child: MaterialApp(
            title: 'News App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              cardTheme: CardTheme(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            routes: AppRoutes.getRoutes(),
            initialRoute: '/',
          ),
        );
      },
    );
  }
}
