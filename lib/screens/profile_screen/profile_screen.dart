import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskify/screens/auth/login_screen.dart';
import 'package:taskify/service/auth_service.dart';
import 'package:taskify/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  bool _isLoading = true;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        userName = doc['name'] ?? 'No Name';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUserName(String newName) async {
    final user = _auth.currentUser;
    if (user != null) {
      // Update in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'name': newName,
      });
      // Update in FirebaseAuth profile
      await user.updateProfile(displayName: newName);
      await user.reload();
      setState(() {
        userName = newName;
      });
    }
  }

  void _showEditNameDialog() {
    final controller = TextEditingController(text: userName);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Name'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Enter your name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final newName = controller.text.trim();
                  if (newName.isNotEmpty) {
                    _updateUserName(newName);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.korangeMedium,
        title: Text("Profile"),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      maxRadius: 60,
                      backgroundImage: AssetImage("assets/user.png"),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userName ?? "userName",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showEditNameDialog();
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: CustomColors.klightGrey,
                          child: Icon(
                            Icons.logout_rounded,
                            color: CustomColors.korangeMedium,
                          ),
                        ),
                        title: Text("Logout"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: CustomColors.korangeMedium,
                        ),
                        onTap: () {
                          confirmLogout();
                        },
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  void confirmLogout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Confirm Logout"),
            content: Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                  AuthService().logout();
                },
                child: Text("Logout"),
              ),
            ],
          ),
    );
  }
}
