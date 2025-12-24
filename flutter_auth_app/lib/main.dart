import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'core/network/auth_interceptor.dart';
import 'core/storage/token_storage.dart';

import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'features/auth/presentation/pages/auth_gate.dart';

void main() {
  final tokenStorage = TokenStorage();
  final apiClient = ApiClient(http.Client());
  final authInterceptor = AuthInterceptor(
    tokenStorage: tokenStorage,
    apiClient: apiClient,
  );

  apiClient.setAuthInterceptor(authInterceptor);

  final authRepository = AuthRepositoryImpl(
    remote: AuthRemoteDataSource(apiClient),
    tokenStorage: tokenStorage,
  );

  runApp(MyApp(
    loginUseCase: LoginUseCase(authRepository),
    tokenStorage: tokenStorage,
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final TokenStorage tokenStorage;

  const MyApp({super.key, required this.loginUseCase, required this.tokenStorage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => AuthBloc(
          loginUseCase,
          CheckAuthStatusUseCase(tokenStorage),
        ),
        child: const AuthGate(),
      ),
    );
  }
}