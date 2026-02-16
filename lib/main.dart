import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tictactic/view/Homepage/homepage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactic/view/Homepage/room_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 3. Provide the RoomBloc to the entire app tree
        BlocProvider<RoomBloc>(
          create: (context) => RoomBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Tractal',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home:  GameHomePage(),
      ),
    );
  }
}