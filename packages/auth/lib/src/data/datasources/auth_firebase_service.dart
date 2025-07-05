import 'dart:io';

import 'package:auth/src/crypto_util.dart';
import 'package:auth/src/data/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show
        ActionCodeSettings,
        EmailAuthProvider,
        FacebookAuthProvider,
        FirebaseAuth,
        FirebaseAuthException,
        GoogleAuthProvider,
        OAuthCredential,
        OAuthProvider,
        PhoneAuthProvider,
        User;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthFirebaseService {
  final FirebaseAuth firebaseAuth;

  AuthFirebaseService({required this.firebaseAuth});

  Stream<AuthModel?> get authChanges {
    return firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      }

      return AuthModel.fromFirebaseAuthUser(firebaseUser);
    });
  }

  User? get getCurrentUser {
    return firebaseAuth.currentUser;
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final currentUser = getCurrentUser;
      if (currentUser == null) {
        await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await signInWithEmailAndPassword(email, password);
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw 'Provide a valid email address';
        case 'email-already-in-use':
          throw 'Email is already registered';
        case 'operation-not-allowed':
          throw 'Email/password accounts temporarily unavailable';
        case 'weak-password':
          throw 'Password is too weak';
        case 'wrong-password':
          throw 'Password is not associated to';
        default:
          throw 'Unknown error occurred';
      }
    } catch (e) {
      throw 'Sign in failed';
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final oauthCredential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await signInWithCredential(oauthCredential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw 'Provide a valid email address';
        case 'user-disabled':
          throw 'Your account is temporarily on hold';
        case 'user-not-found':
          throw 'Email not found, please sign up';
        case 'wrong-password':
          throw 'Email or password is incorrect';
        default:
          throw 'Unknown error occurred';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'missing-email':
        case 'invalid-email':
          throw 'Provide a valid email address';
        case 'user-not-found':
          throw 'Email address was not found';
        default:
          throw 'Password reset failed';
      }
    } catch (e) {
      throw 'Reset password failed';
    }
  }

  Future<void> sendEmailVerification(String email, bool isNew) async {
    try {
      final currentUser = getCurrentUser;
      if (currentUser != null) {
        print('calling $email & $isNew');
        ActionCodeSettings acs = ActionCodeSettings(
          url: '',
          handleCodeInApp: true,
          iOSBundleId: 'com.example.mvmntCli',
          androidMinimumVersion: '21',
          androidInstallApp: true,
          androidPackageName: 'com.example.mvmntCli',
        );
        if (isNew) {
          print('calling verify before updated');
          await currentUser.verifyBeforeUpdateEmail(email, acs);
        } else {
          print('calling send email verification');
          await currentUser.sendEmailVerification(acs);
        }
      } else {
        throw 'No user is currently signed in';
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      switch (e.code) {
        case 'requires-recent-login':
          throw '';
        case 'too-many-requests':
          throw 'Too many requests, try again later';
        case 'unauthorized-domain':
          throw 'unauthorized doamin';
        case 'invalid-continue-uri':
          throw 'Continue uri invalid';
        default:
          throw 'Internal, failed to send verification email';
      }
    } catch (e) {
      print(e);
      throw 'Failed to send verification email';
    }
  }

  Future<bool> confirmEmailVerification() async {
    try {
      final currentUser = getCurrentUser;
      if (currentUser != null) {
        await currentUser.reload();
        return currentUser.emailVerified;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final hashedNonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );

      await signInWithCredential(oauthCredential);
    } on SignInWithAppleAuthorizationException catch (e) {
      switch (e.code) {
        case AuthorizationErrorCode.invalidResponse:
        case AuthorizationErrorCode.failed:
          throw 'Sign in failed';
        default:
          throw '';
      }
    } on FirebaseAuthException catch (e) {
      print('what error');
      print(e);
      switch (e.code) {
        case 'missing-or-invalid-nonce':
          throw 'Internal nonce error';
        case 'user-not-found':
          throw 'Email address was not found';
        case 'credential-already-in-use':
          throw 'Another account already uses this';
        default:
          throw 'Password reset failed';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;
      final GoogleSignInAccount? googleUser = await signIn.authenticate();
      if (googleUser == null) {
        throw '';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        // accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      await signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw 'An account already exists with the same email but different sign-in method.';
        case 'invalid-credential':
          throw 'The Google credential is invalid or expired.';
        case 'operation-not-allowed':
          throw 'Google sign-in accounts temporarily disabled.';
        case 'user-disabled':
          throw 'This user account has been disabled.';
        default:
          throw '${e.message}';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final rawNonce = generateNonce();
      final hashedNonce = sha256ofString(rawNonce);

      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
        nonce: hashedNonce,
      );
      if (loginResult.status != LoginStatus.success) {
        throw '';
      }

      final OAuthCredential facebookAuthCredential;
      if (Platform.isIOS) {
        switch (loginResult.accessToken!.type) {
          case AccessTokenType.classic:
            final token = loginResult.accessToken as ClassicToken;
            facebookAuthCredential = FacebookAuthProvider.credential(
              token.authenticationToken!,
            );
            break;
          case AccessTokenType.limited:
            final token = loginResult.accessToken as LimitedToken;
            facebookAuthCredential = OAuthCredential(
              providerId: 'facebook.com',
              signInMethod: 'oauth',
              idToken: token.tokenString,
              rawNonce: rawNonce,
            );
            break;
        }
      } else {
        facebookAuthCredential = FacebookAuthProvider.credential(
          loginResult.accessToken!.tokenString,
        );
      }

      await signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw 'An account already exists with the same email but different sign-in method.';
        case 'invalid-credential':
          throw 'The Facebook credential is invalid or expired.';
        case 'operation-not-allowed':
          throw 'Facebook sign-in is disabled in Firebase.';
        case 'user-disabled':
          throw 'This user account has been disabled.';
        default:
          throw 'Authentication error: ${e.message}';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthModel> signInAnonymous() async {
    final credential = await firebaseAuth.signInAnonymously();

    return AuthModel.fromFirebaseAuthUser(credential.user!);
  }

  Future<void> sendPhoneVerification({
    required String phoneNumber,
    required onVerificaitonFailed,
    required onCodeSent,
    required onCodeAutoRetrievalTimeOut,
    int? forceResendingToken,
  }) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendingToken,
      verificationCompleted: (phoneCredential) async {
        await authenticateWithPhoneCredential(phoneCredential);
      },
      verificationFailed: (FirebaseAuthException e) {
        switch (e.code) {
          case 'invalid-phone-number':
            onVerificaitonFailed('Invalid phone number format');
            break;
          case 'quota-exceeded':
            onVerificaitonFailed('SMS quota exceeded. Try again later.');
            break;
          case 'user-disabled':
            onVerificaitonFailed('This user account has been disabled.');
            break;
          case 'captcha-check-failed':
            onVerificaitonFailed('reCAPTCHA verification failed. Try again.');
            break;
          case 'too-many-requests':
            onVerificaitonFailed('Too many requests. Please try again later');
            break;
          case 'network-request-failed':
            onVerificaitonFailed('Network error. Please check your connection');
            break;
          case 'internal-error':
            onVerificaitonFailed('Please verify number and retry');
            break;
          case 'operation-not-allowed':
            onVerificaitonFailed('Not available in region');
            break;
          case 'web-context-cancelled':
            onVerificaitonFailed('Please retry verification');
            break;
          default:
            onVerificaitonFailed('Verification failed, please retry');
            break;
        }
      },
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeOut,
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> verifyPhoneCode({
    required String smsCode,
    required String verificationId,
  }) async {
    try {
      final phoneCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await authenticateWithPhoneCredential(phoneCredential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-verification-code':
          throw 'Invalid code, please retry';
        case 'session-expired':
          throw 'Session expired, please retry';
        case 'credential-already-in-use':
          throw 'Another account already uses this number';
        case 'provider-already-linked':
          throw 'You cannot change this number';
        default:
          throw 'Could not verify, please retry';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> authenticateWithPhoneCredential(dynamic phoneCredential) async {
    if (firebaseAuth.currentUser != null) {
      await firebaseAuth.currentUser?.updatePhoneNumber(phoneCredential);
    } else {
      await firebaseAuth.signInWithCredential(phoneCredential);
    }
  }

  Future<void> signInWithCredential(dynamic credential) async {
    if (firebaseAuth.currentUser != null) {
      try {
        await firebaseAuth.currentUser?.linkWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        print('inside sign in with credential');
        print(e);
        print(e.code);
        print(
          e.code == 'credential-already-in-use' ||
              e.code == 'email-already-in-use',
        );
        if (e.code == 'credential-already-in-use' ||
            e.code == 'email-already-in-use') {
          print('inside here');
          // Sign in with that credential
          await firebaseAuth.signInWithCredential(credential);
          // Call to migrate data
          // TODO: api call to migrate data

          // delete old account
          // await firebaseAuth.currentUser!.delete();
        } else {
          rethrow;
        }
      }
    } else {
      await firebaseAuth.signInWithCredential(credential);
    }
  }
}
