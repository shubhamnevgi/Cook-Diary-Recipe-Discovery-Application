import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'hero-2',
      child: ClipOval(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final photoUrl = snapshot.data?.photoURL ?? AuthService().currentUser?.photoURL;
            if (photoUrl != null && photoUrl.isNotEmpty) {
              return Image.network(
                photoUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stack) => _defaultAvatar(context),
              );
            }
            return _defaultAvatar(context);
          },
        ),
      ),
    );
  }

  Widget _defaultAvatar(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: double.infinity,
      child: Icon(
        Icons.person,
        size: 40,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
