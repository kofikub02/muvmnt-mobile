import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mvmnt_cli/features/profile/data/models/profile_model.dart';

class ProfileRemoteDataSource {
  final Dio dio;
  final FirebaseAuth firebaseAuth;

  ProfileRemoteDataSource({required this.dio, required this.firebaseAuth});

  Future<ProfileModel> getProfile() async {
    User? currentUser = firebaseAuth.currentUser;

    if (currentUser == null || currentUser.isAnonymous) {
      throw 'No Profile';
    }

    var response = await dio.get('/users/customers/self');

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return ProfileModel.fromJson(response.data['data']);
      }
    } else if (response.statusCode == 404) {
      return createProfile();
    }

    throw response.data['message'];
  }

  Future<ProfileModel> createProfile() async {
    User? currentUser = firebaseAuth.currentUser;

    if (currentUser == null || currentUser.isAnonymous) {
      throw 'No Profile';
    }

    var newProfile = await createProfileRequestBody();
    var response = await dio.post('/users/customers', data: newProfile);

    if (response.statusCode == 201) {
      if (response.data != null && response.data['data'] != null) {
        return ProfileModel.fromJson(response.data['data']);
      }
    }

    throw response.data['message'];
  }

  Future<ProfileModel> updateProfile(
    String id,
    Map<String, dynamic> updatedProfileValues,
  ) async {
    var response = await dio.patch(
      '/users/customers/$id',
      data: updatedProfileValues,
    );

    if (response.statusCode == 200) {
      if (response.data != null && response.data['data'] != null) {
        return ProfileModel.fromJson(response.data['data']);
      }
    }

    throw response.data['message'];
  }

  Future<Map<String, dynamic>> createProfileRequestBody() async {
    // Get the current Firebase user
    User? currentUser = firebaseAuth.currentUser;

    // Check if user exists
    if (currentUser == null) {
      throw Exception('No authenticated user found');
    }
    print(currentUser);

    // Extract display name and split into first and last name
    String firstName = '';
    String lastName = '';

    if (currentUser.displayName != null &&
        currentUser.displayName!.isNotEmpty) {
      List<String> nameParts = currentUser.displayName?.trim().split(' ') ?? [];
      firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    }

    // Extract email
    String email = currentUser.email ?? '';

    // Extract phone number - remove country code prefix if present
    String phoneNumber = currentUser.phoneNumber ?? '';
    String countryCode = '';
    String number = '';

    if (phoneNumber.isNotEmpty) {
      // Try to extract country code - assumes format like +1234567890
      RegExp regex = RegExp(r'^\+(\d+)(\d{10})$');
      var match = regex.firstMatch(phoneNumber);

      if (match != null && match.groupCount >= 2) {
        countryCode = '+${match.group(1)}';
        number = match.group(2) ?? '';
      } else {
        // If pattern doesn't match, keep number as is
        number = phoneNumber;
      }
    }

    // Check the provider used to sign in
    final providerIds =
        currentUser.providerData.map((e) => e.providerId).toList();
    final usedPhoneProvider = providerIds.contains('phone');

    Map<String, dynamic> data = {};

    if (firstName.isNotEmpty) data['first_name'] = firstName;
    if (lastName.isNotEmpty) data['last_name'] = lastName;
    if (email.isNotEmpty) {
      data['email'] = {'address': email, 'verified': currentUser.emailVerified};
    }
    if (number.isNotEmpty) {
      data['phone'] = {
        'country_code': countryCode,
        'number': number,
        'verified': usedPhoneProvider,
      };
    }
    if ((currentUser.photoURL ?? '').isNotEmpty) {
      data['photo_url'] = currentUser.photoURL!;
    }

    return data;
  }
}
