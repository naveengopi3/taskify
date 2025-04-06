import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/bloc/auth_bloc/auth_bloc.dart';
import 'package:taskify/firebase_options.dart';
import 'package:taskify/screens/splash_screen/splash_screen.dart';
import 'package:taskify/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        ],
       child: MaterialApp(
        title: 'Taskify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: CustomColors.korangeMedium,
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
