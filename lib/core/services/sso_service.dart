// import 'package:dio/dio.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:fluwx/fluwx.dart';
// import 'package:crypto/crypto.dart';
// import 'dart:convert';
// import 'dart:math';
// import 'package:m2health/const.dart';
// import 'package:m2health/utils.dart';

// class SSOService {
//   final Dio _dio;

//   SSOService(this._dio);

//   // Google Sign-In Configuration
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     // You need to get this from Google Cloud Console
//     // For now using placeholder, replace with your actual client ID
//     clientId: '123456789-abcdefgh.apps.googleusercontent.com',
//     scopes: [
//       'email',
//       'profile',
//     ],
//   );

//   /// Generate a nonce for WeChat authentication
//   String _generateNonce([int length = 32]) {
//     const charset =
//         '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//     final random = Random.secure();
//     return List.generate(length, (_) => charset[random.nextInt(charset.length)])
//         .join();
//   }

//   /// SHA256 hash function for nonce
//   String _sha256ofString(String input) {
//     final bytes = utf8.encode(input);
//     final digest = sha256.convert(bytes);
//     return digest.toString();
//   }

//   /// Google Sign-In Implementation
//   Future<Map<String, dynamic>> signInWithGoogle(String role) async {
//     try {
//       print('=== GOOGLE SIGN-IN START ===');
//       print('Role: $role');

//       // Check if user is already signed in
//       GoogleSignInAccount? currentUser = _googleSignIn.currentUser;

//       if (currentUser == null) {
//         // Sign in if not already signed in
//         currentUser = await _googleSignIn.signIn();
//       }

//       if (currentUser == null) {
//         throw Exception('Google Sign-In was cancelled by user');
//       }

//       print('Google user: ${currentUser.email}');
//       print('Google display name: ${currentUser.displayName}');

//       // Get authentication tokens
//       final GoogleSignInAuthentication googleAuth =
//           await currentUser.authentication;

//       if (googleAuth.accessToken == null || googleAuth.idToken == null) {
//         throw Exception('Failed to get Google authentication tokens');
//       }

//       print('Google access token received');
//       print('Google ID token received');

//       // Prepare data to send to your backend
//       final googleSignInData = {
//         'provider': 'google',
//         'role': role.toLowerCase(),
//         'access_token': googleAuth.accessToken,
//         'id_token': googleAuth.idToken,
//         'email': currentUser.email,
//         'name': currentUser.displayName ?? '',
//         'profile_picture': currentUser.photoUrl ?? '',
//         'google_id': currentUser.id,
//       };

//       print('Sending Google auth data to backend...');

//       // Send to your backend API
//       final response = await _dio.post(
//         '${Const.API_REGISTER}social', // You might need to create this endpoint
//         data: googleSignInData,
//         options: Options(
//           validateStatus: (status) => status! < 500,
//         ),
//       );

//       print('Backend response status: ${response.statusCode}');
//       print('Backend response data: ${response.data}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Save user data locally
//         if (response.data['token'] != null) {
//           await Utils.setSpString(Const.TOKEN, response.data['token']);
//         }
//         if (response.data['user'] != null) {
//           final user = response.data['user'];
//           await Utils.setSpString(Const.USER_ID, user['id'].toString());
//           await Utils.setSpString(Const.ROLE, role.toLowerCase());
//           await Utils.setSpString(
//               Const.USERNAME, user['username'] ?? user['name'] ?? '');
//         }

//         return {
//           'success': true,
//           'message': 'Google Sign-In successful',
//           'data': response.data,
//         };
//       } else {
//         throw Exception('Backend authentication failed: ${response.data}');
//       }
//     } catch (e) {
//       print('Google Sign-In Error: $e');

//       // Sign out on error to clean up state
//       await _googleSignIn.signOut();

//       return {
//         'success': false,
//         'message': 'Google Sign-In failed: ${e.toString()}',
//       };
//     }
//   }

//   /// WeChat Sign-In Implementation
//   Future<Map<String, dynamic>> signInWithWeChat(String role) async {
//     try {
//       print('=== WECHAT SIGN-IN START ===');
//       print('Role: $role');

//       // Initialize WeChat if not already done
//       await _initializeWeChat();

//       // Check if WeChat is installed
//       final isWeChatInstalled = await isWeChatInstalled;
//       if (!isWeChatInstalled) {
//         throw Exception('WeChat is not installed on this device');
//       }

//       print('WeChat is installed, proceeding with authentication...');

//       // Generate state and nonce for security
//       final state = _generateNonce();
//       final nonce = _generateNonce();

//       // Send WeChat auth request
//       final authResp = await sendWeChatAuth(
//         scope: "snsapi_userinfo",
//         state: state,
//       );

//       if (authResp.errCode != 0) {
//         throw Exception('WeChat auth failed with code: ${authResp.errCode}');
//       }

//       print('WeChat auth code received: ${authResp.code}');

//       // Prepare data to send to your backend
//       final wechatSignInData = {
//         'provider': 'wechat',
//         'role': role.toLowerCase(),
//         'auth_code': authResp.code,
//         'state': authResp.state,
//         'nonce': nonce,
//       };

//       print('Sending WeChat auth data to backend...');

//       // Send to your backend API
//       final response = await _dio.post(
//         '${Const.API_REGISTER}social', // You might need to create this endpoint
//         data: wechatSignInData,
//         options: Options(
//           validateStatus: (status) => status! < 500,
//         ),
//       );

//       print('Backend response status: ${response.statusCode}');
//       print('Backend response data: ${response.data}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Save user data locally
//         if (response.data['token'] != null) {
//           await Utils.setSpString(Const.TOKEN, response.data['token']);
//         }
//         if (response.data['user'] != null) {
//           final user = response.data['user'];
//           await Utils.setSpString(Const.USER_ID, user['id'].toString());
//           await Utils.setSpString(Const.ROLE, role.toLowerCase());
//           await Utils.setSpString(
//               Const.USERNAME, user['username'] ?? user['nickname'] ?? '');
//         }

//         return {
//           'success': true,
//           'message': 'WeChat Sign-In successful',
//           'data': response.data,
//         };
//       } else {
//         throw Exception('Backend authentication failed: ${response.data}');
//       }
//     } catch (e) {
//       print('WeChat Sign-In Error: $e');

//       return {
//         'success': false,
//         'message': 'WeChat Sign-In failed: ${e.toString()}',
//       };
//     }
//   }

//   /// Initialize WeChat SDK
//   Future<void> _initializeWeChat() async {
//     try {
//       // Replace with your actual WeChat App ID from WeChat Open Platform
//       await registerWxApi(
//         appId: "wx1234567890abcdef", // Replace with your WeChat App ID
//         doOnAndroid: true,
//         doOnIOS: true,
//       );
//       print('WeChat SDK initialized successfully');
//     } catch (e) {
//       print('WeChat SDK initialization failed: $e');
//       throw Exception('Failed to initialize WeChat SDK');
//     }
//   }

//   /// Sign out from Google
//   Future<void> signOutGoogle() async {
//     try {
//       await _googleSignIn.signOut();
//       print('Google sign-out successful');
//     } catch (e) {
//       print('Google sign-out error: $e');
//     }
//   }

//   /// Check if user is signed in with Google
//   Future<bool> isGoogleSignedIn() async {
//     return await _googleSignIn.isSignedIn();
//   }

//   /// Get current Google user
//   Future<GoogleSignInAccount?> getCurrentGoogleUser() async {
//     return _googleSignIn.currentUser;
//   }

//   /// Facebook Sign-In placeholder (for future implementation)
//   Future<Map<String, dynamic>> signInWithFacebook(String role) async {
//     // TODO: Implement Facebook Sign-In using flutter_facebook_auth
//     return {
//       'success': false,
//       'message': 'Facebook Sign-In not implemented yet',
//     };
//   }
// }
