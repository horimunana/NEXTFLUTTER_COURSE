/// A locally persisted user profile shown on the profile screen.
class ProfileModel {
  final String name;
  final String email;
  final String avatarUrl;
  final String location;
  final String memberSince;

  const ProfileModel({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.location,
    required this.memberSince,
  });
}