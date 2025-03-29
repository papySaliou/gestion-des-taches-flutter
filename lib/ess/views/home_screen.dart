import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapi/ess/info.dart';
import 'package:testapi/ess/views/tache_screen.dart';
// import 'package:testapi/views/add_task_screen.dart';
// import 'package:testapi/views/data_screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  setCurrentIndex(int index){
    setState(() {
      _currentIndex = index;
    });
  }


  final List<Widget> _screens = [
    // const DataScreens(),
    // const TasksScreen(),
    // AddTaskScreen(refreshData: () {  },),
    TacheScreen(),
    const Info(userData: {}),
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            // Redirige vers l'écran d'authentification si l'utilisateur est déconnecté
            Future.microtask(() => Navigator.pushReplacementNamed(context, '/auth'));
            return const Center(child: CircularProgressIndicator());
          }
          return _buildHomeScreen(); // Affiche l'écran principal si l'utilisateur est connecté
        }
        return const Center(child: CircularProgressIndicator()); // Chargement en cours
      },
    );
  }

  Widget _buildHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
            backgroundColor: Colors.lightBlue,
        title: [
              
              Text('Liste des Taches',
               style: TextStyle(color: Colors.white,
               fontSize: 20,
               fontWeight: FontWeight.bold,)
               ),
              Text('Profile',
              style: TextStyle(color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,)
              ),
            ][_currentIndex], 
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _logout,
                color: Colors.white,
              ),
            ],

      ),

      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        iconSize: 25,
        elevation: 10,
        items: const [
          // BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tâches'),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_sharp), label: 'Profil'),
        ],
      ),
    );
  }
}
