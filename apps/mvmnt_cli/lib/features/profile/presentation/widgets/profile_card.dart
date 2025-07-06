import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:mvmnt_cli/features/profile/presentation/cubits/profile_state.dart';
import 'package:mvmnt_cli/ui/shimmers/shimmer_profile_card.dart';
import 'package:mvmnt_cli/ui/widgets/item_rating.dart';
import 'package:mvmnt_cli/features/profile/domain/entities/profile_entity.dart';
import 'package:mvmnt_cli/features/profile/presentation/widgets/profile_avatar.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.profileEntity != null) {
          return GestureDetector(
            onTap: () {
              context.push('/profile');
            },
            child: _ProfileCardView(profile: state.profileEntity!),
          );
        } else {
          return ShimmerProfileCard();
        }
      },
    );
  }
}

class _ProfileCardView extends StatelessWidget {
  final ProfileEntity? profile;

  const _ProfileCardView({required this.profile});

  @override
  Widget build(BuildContext context) {
    String fullName =
        "${profile?.firstName ?? ''} ${profile?.lastName ?? ''}".trim();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName.isNotEmpty ? fullName : 'Setup your profile',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              ItemRating(rating: profile?.rating),
            ],
          ),
        ),
        const SizedBox(width: 20),
        ProfileAvatar(
          firstName: profile?.firstName,
          imageUrl: profile?.photoUrl,
        ),
      ],
    );
  }
}
