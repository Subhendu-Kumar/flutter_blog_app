import 'package:blog_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signin({required String email, required String password});

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {"name": name},
      );
      if (response.user == null) {
        throw ServerException("User is null");
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerException("User is null");
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession == null) {
        return null;
      }
      final userData = await supabaseClient
          .from("profiles")
          .select()
          .eq("id", currentUserSession!.user.id);
      if (userData.isEmpty) {
        throw ServerException("User data not found");
      }
      return UserModel.fromJson(
        userData.first,
      ).copyWith(email: currentUserSession!.user.email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Future<String> signup({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Optionally update display name
//       await userCredential.user?.updateDisplayName(name);

//       if (userCredential.user == null) {
//         throw ServerException("User is null");
//       }
//       return userCredential.user!.uid;
//     } catch (e) {
//       throw ServerException(e.toString());
//     }
//   }

//   @override
//   Future<String> signin({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user!.uid;
//     } catch (e) {
//       throw ServerException(e.toString());
//     }
//   }
// }
