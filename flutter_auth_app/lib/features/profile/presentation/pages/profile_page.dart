import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            print('Profile loading...');
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            print('Profile loaded state received');
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Username: ${state.profile.username}'),
                  Text('Role: ${state.profile.role}'),
                ],
              ),
            );
          }

          if (state is ProfileError) {
            print('Profile error state received');
            print('Error message: ${state.message}');
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
