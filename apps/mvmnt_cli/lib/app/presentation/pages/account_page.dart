import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/authentication/authentication_cubit.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/authentication/authentication_state.dart';
import 'package:mvmnt_cli/features/auth/presentation/widgets/account_card.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';
import 'package:mvmnt_cli/features/profile/presentation/widgets/profile_card.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static const String route = '/account';

  @override
  Widget build(BuildContext context) {
    return _AccountView(key: Key('account_view'));
  }
}

class _AccountView extends StatefulWidget {
  const _AccountView({super.key});

  @override
  State<_AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<_AccountView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        bool isAnonymous = state.authEntity?.isAnonymous ?? false;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                toolbarHeight: isAnonymous ? 130 : 100,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isAnonymous) ...[
                          AccountCard(),
                        ] else ...[
                          ProfileCard(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 4)),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isAnonymous) ...[
                        ListTile(
                          title: Text('Profile'),
                          subtitle: Text("Update information about you"),
                          onTap: () => context.push('/profile'),
                          leading: SvgIcon(name: 'user-round-cog'),
                          trailing: SvgIcon(name: 'chevron-right'),
                        ),
                        ListTile(
                          title: Text('Payment'),
                          subtitle: Text("Manage your payments and credits"),
                          onTap: () => context.push('/payments'),
                          leading: SvgIcon(name: 'wallet'),
                          trailing: SvgIcon(name: 'chevron-right'),
                        ),
                        ListTile(
                          title: Text('Addresses'),
                          subtitle: Text('Add and remove addresses'),
                          onTap: () => context.push('/addresses'),
                          leading: SvgIcon(name: 'map-pin-house'),
                          trailing: SvgIcon(name: 'chevron-right'),
                        ),
                        ListTile(
                          tileColor: Theme.of(
                            context,
                          ).colorScheme.error.withOpacity(0.1),
                          title: Text('Refer Friends'),
                          subtitle: Text('Earn credits to shop for free'),
                          onTap: () => context.push('/referral'),
                          leading: SvgIcon(name: 'speech'),
                          trailing: SvgIcon(name: 'chevron-right'),
                        ),
                        ListTile(
                          title: Text('Support'),
                          subtitle: Text("Need help? We've got you"),
                          onTap: () => context.push('/support'),
                          leading: SvgIcon(name: 'life-buoy'),
                          trailing: SvgIcon(name: 'chevron-right'),
                        ),
                        ListTile(
                          title: Text('Safety'),
                          subtitle: Text('Configure package safety options'),
                          onTap: () => context.push('/account/safety'),
                          leading: SvgIcon(name: 'shield-check'),
                          trailing: SvgIcon(name: 'chevron-right'),
                        ),
                      ],
                      ListTile(
                        title: Text('Privacy'),
                        subtitle: Text(
                          'Learn about Privacy and manage settings',
                        ),
                        onTap: () => context.push('/account/privacy'),
                        leading: SvgIcon(name: 'globe-lock'),
                        trailing: SvgIcon(name: 'chevron-right'),
                      ),
                      if (!isAnonymous) ...[
                        ListTile(
                          title: Text('Notifications'),
                          subtitle: Text(
                            'Manage your notifications preferences',
                          ),
                          onTap: () => context.push('/account/notifications'),
                          leading: SvgIcon(name: 'bell-ring'),
                          trailing: SvgIcon(name: 'chevron-right'),
                        ),
                        ListTile(
                          title: Text('Appearance'),
                          subtitle: Text('Manage Dark mode appearance'),
                          onTap: () => context.push('/account/theme'),
                          leading: SvgIcon(name: 'moon-star'),
                          trailing: SvgIcon(name: 'chevron-right'),
                        ),
                      ],
                      ListTile(
                        title: Text('Language'),
                        subtitle: Text('English'),
                        onTap: () => context.push('/account/locale'),
                        leading: SvgIcon(name: 'globe'),
                        trailing: SvgIcon(name: 'chevron-right'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(thickness: 0.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12,
                        ),
                        child: Text(
                          'More',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text('Earn as a muver'),
                        onTap: () {},
                        trailing: SvgIcon(name: 'chevron-right'),
                      ),
                      ListTile(
                        title: Text('Become a Business owner'),
                        onTap: () {},
                        trailing: SvgIcon(name: 'chevron-right'),
                      ),
                      ListTile(
                        title: Text('Legal', style: TextStyle(fontSize: 16)),
                        onTap: () {},
                        trailing: SvgIcon(name: 'chevron-right'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 4)),
            ],
          ),
        );
      },
    );
  }
}

// SavedPlaces(),
