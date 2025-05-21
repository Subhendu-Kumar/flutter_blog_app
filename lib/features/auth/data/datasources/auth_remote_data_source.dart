// import 'package:blog_app/core/error/exceptions.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:blog_app/core/error/exceptions.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<String> signin({required String email, required String password});
}

// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final SupabaseClient supabaseClient;

//   AuthRemoteDataSourceImpl({required this.supabaseClient});

//   @override
//   Future<String> signup({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await supabaseClient.auth.signUp(
//         email: email,
//         password: password,
//         data: {"name": name},
//       );
//       if (response.user == null) {
//         throw ServerException("User is null");
//       }
//       return response.user!.id;
//     } catch (e) {
//       throw ServerException(e.toString());
//     }
//   }

//   @override
//   Future<String> signin({
//     required String email,
//     required String password,
//   }) async {
//     final response = await supabaseClient.auth.signInWithPassword(
//       email: email,
//       password: password,
//     );

//     return response.user!.id;
//   }
// }

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<String> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optionally update display name
      await userCredential.user?.updateDisplayName(name);

      if (userCredential.user == null) {
        throw ServerException("User is null");
      }
      return userCredential.user!.uid;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> signin({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!.uid;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
