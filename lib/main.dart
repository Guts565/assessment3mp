import 'package:firebase_core/firebase_core.dart';
import 'package:assessment_3_mp/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Ensure the admin user is created
  await ensureAdminUser();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class User {
  final String name;
  final String password;

  User({required this.name, required this.password});


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
    };
  }
}

Future<void> addUser(String username, String password) async {
  User user = User(name: username, password: password);
  await FirebaseFirestore.instance.collection('users').add(user.toMap());
}

Future<List<User>> getUsers() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
  return querySnapshot.docs.map((doc) => User(name: doc['name'], password: doc['password'])).toList();
}

Future<void> ensureAdminUser() async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  QuerySnapshot querySnapshot = await users.where('name', isEqualTo: 'admin').get();

  if (querySnapshot.docs.isEmpty) {
    await addUser('admin', 'admin');
  }
}
