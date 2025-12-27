import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfile;

  ProfileBloc(this.getProfile) : super(ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
  }

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    print('_onProfileRequested called');
    emit(ProfileLoading());

    try {
      print('Fetching profile...');
      final profile = await getProfile();
      emit(ProfileLoaded(profile));
      print('Profile loaded: $profile');
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
