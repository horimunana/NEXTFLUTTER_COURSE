import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/features/profile/models/profile_model.dart';

/// Mock profile data.
///
/// The profile screen intentionally uses mock data (no backend involved).
/// See `lib/features/profile/note.txt`.
final profileProvider = Provider<ProfileModel>((ref) {
  return const ProfileModel(
    name: 'Munana Hori',
    email: 'munana.hori@example.com',
    avatarUrl: 'https://i.pravatar.cc/300?img=12',
    location: 'Bujumbura, Burundi',
    memberSince: 'January 2024',
  );
});