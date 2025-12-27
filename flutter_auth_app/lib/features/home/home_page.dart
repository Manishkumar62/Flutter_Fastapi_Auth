import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/presentation/bloc/auth_bloc.dart';
import '../auth/presentation/bloc/auth_event.dart';
import '../profile/presentation/bloc/profile_bloc.dart';
import '../profile/presentation/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Profile'),
          onPressed: () {
            print("Btn clicked");
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<ProfileBloc>(),
                  child: const ProfilePage(),
                ),
              ),
            );
            // context.read<ProfileBloc>().add(ProfileRequested());
          },
        ),
      ),
    );
  }
}
