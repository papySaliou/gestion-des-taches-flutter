// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:testapi/data_screen.dart';
// // import 'package:testapi/data_screen.dart';
// import 'package:testapi/firebase_options.dart';
// import 'package:testapi/views/calendar_screen.dart';
// import 'package:testapi/views/data_screens.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int _currentIndex = 0;

//   // Liste des écrans associés aux éléments du BottomNavigationBar
//   final List<Widget> _screens = [
//     // const DataScreen(),
//     const DataScreens(),
//     // const TasksScreen(), // Exemple : un écran pour les tâches
//     const AddScreen(),
//     const CalendarScreen(), // Exemple : un écran pour ajouter du contenu
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
//       ),
//       home: Scaffold(
//         body: _screens[_currentIndex],
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: (index) => setState(() => _currentIndex = index),
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Colors.green,
//           unselectedItemColor: Colors.grey,
//           iconSize: 25,
//           elevation: 10,
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.calendar_month),
//               label: 'Tâches',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.calendar_today),
//               label: 'Calendrier',
//             ),
//             // BottomNavigationBarItem(
//             //   icon: Icon(Icons.add),
//             //   label: 'Ajout',
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Écrans fictifs pour compléter la navigation
// class TasksScreen extends StatelessWidget {
//   const TasksScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Écran des tâches'));
//   }
// }

// class AddScreen extends StatelessWidget {
//   const AddScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Écran d\'ajout'));
//   }
// }


// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:testapi/ess/auth.dart';
// import 'package:testapi/ess/info.dart';
// import 'package:testapi/firebase_options.dart';
// import 'package:testapi/views/data_screens.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:testapi/views/home_screen.dart';

// // import 'package:testapi/views/calendar_screen.dart';
// // import 'package:testapi/views/login_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
//       ),
//       home: FirebaseAuth.instance.currentUser == null 
//           ? const Auth() 
//           : const HomeScreen(), // Vérifie si l'utilisateur est connecté
//       routes: {
//         '/auth': (context) => const Auth(),
//         '/home': (context) => const HomeScreen(),
//       },
//     );
//   }
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     const DataScreens(),
//     const TasksScreen(),
//     // const CalendarScreen(),
//     const Info(userData: {})
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
//       ),
//       initialRoute: '/', // Route par défaut
//       routes: {
//         '/': (context) => const Auth(), // Écran de connexion par défaut
//         '/home': (context) => Scaffold(
//           body: _screens[_currentIndex],
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: _currentIndex,
//             onTap: (index) => setState(() => _currentIndex = index),
//             type: BottomNavigationBarType.fixed,
//             selectedItemColor: Colors.green,
//             unselectedItemColor: Colors.grey,
//             iconSize: 25,
//             elevation: 10,
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Accueil'),
//               BottomNavigationBarItem(icon: Icon(Icons.add_task), label: 'Tâches'),
//               BottomNavigationBarItem(icon: Icon(Icons.person_2_sharp), label: 'Profile'),
//             ],
//           ),
//         ),
//       },
//     );
//   }
// }

// // Écrans fictifs pour compléter la navigation
// class TasksScreen extends StatelessWidget {
//   const TasksScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Écran des tâches'));
//   }
// }

// class AddScreen extends StatelessWidget {
//   const AddScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Écran d\'ajout'));
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testapi/ess/auth.dart';

import 'package:testapi/ess/views/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/auth' : '/home',
      routes: {
        '/auth': (context) => const Auth(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
