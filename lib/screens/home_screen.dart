import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'voice_call_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseFirestore firestore;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    authService = AuthService.instance;
  }

  void initiateCall(UserModel targetUser) {
    Get.to(() => VoiceCallScreen(
          remoteUser: targetUser,
          localUser: authService.currentUser!.email ?? '',
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Romyo - Voice Chat'),
        backgroundColor: const Color(0xFF2196F3),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Get.off(() => const LoginScreen());
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('users')
            .where('uid', isNotEqualTo: authService.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No users available'),
            );
          }

          final users = snapshot.data!.docs
              .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: user.status == 'online'
                        ? Colors.green
                        : Colors.grey,
                    child: Text(user.name[0].toUpperCase()),
                  ),
                  title: Text(user.name),
                  subtitle: Text(
                    user.status == 'online' ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: user.status == 'online'
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                  trailing: user.status == 'online'
                      ? IconButton(
                          icon: const Icon(
                            Icons.call,
                            color: Colors.green,
                          ),
                          onPressed: () => initiateCall(user),
                        )
                      : const SizedBox(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}