import 'package:booking/core/helpers/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// User profile document (`users/{uid}`) — written on registration.
///
/// Schema evolution is additive-only: never rename, remove, or retype a
/// field; defaults are applied in fromJson.
@freezed
sealed class UserProfile with _$UserProfile {
  const factory UserProfile({
    @Default('') String uid,
    required String name,
    required String email,
    @Default('') String avatarUrl,
    @Default(Constants.schemaVersion) int schemaVersion,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

extension UserProfileCollectionConverter on CollectionReference<Map<String, dynamic>> {
  CollectionReference<UserProfile> withUserProfileConverter() =>
      withConverter<UserProfile>(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snap, _) =>
            UserProfile.fromJson(<String, dynamic>{...snap.data() ?? <String, dynamic>{}, 'uid': snap.id}),
        toFirestore: (UserProfile profile, _) {
          final Map<String, dynamic> json = profile.toJson()..remove('uid');
          return json;
        },
      );
}
