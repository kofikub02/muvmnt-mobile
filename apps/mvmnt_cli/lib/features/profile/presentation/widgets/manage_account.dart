import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/authentication/authentication_cubit.dart';
import 'package:mvmnt_cli/ui/widgets/sheet_dash.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class ManageAccount extends StatelessWidget {
  final bool enabled;

  const ManageAccount({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage account',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        ListTile(
          enabled: enabled,
          title: Text(
            'Log out',
            style: TextStyle(
              color:
                  !enabled ? Colors.grey : Theme.of(context).colorScheme.error,
            ),
          ),
          onTap:
              !enabled
                  ? null
                  : () {
                    _onLogoutPressed(context);
                  },
          leading: SvgIcon(
            name: 'log-out',
            color: !enabled ? Colors.grey : Theme.of(context).colorScheme.error,
          ),
        ),
        ListTile(
          enabled: enabled,
          title: Text(
            'Delete account',
            style: TextStyle(
              color:
                  !enabled ? Colors.grey : Theme.of(context).colorScheme.error,
            ),
          ),
          onTap:
              !enabled
                  ? null
                  : () {
                    _onDeleteAccountPressed(context);
                  },
          leading: SvgIcon(
            name: 'trash',
            color: !enabled ? Colors.grey : Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }

  void _onDeleteAccountPressed(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (buildContext) {
        return ListView(
          shrinkWrap: true,
          children: [
            SheetDash(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Delete Account',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: const Text(
                'Are you sure you want to delete your account?',
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        context.pop();
                        context.push('/profile/delete');
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _onLogoutPressed(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (buildContext) {
        return ListView(
          shrinkWrap: true,
          children: [
            SheetDash(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Logout',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: const Text('Are you sure you want to logout?'),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        context.pop();
                        context.read<AuthenticationCubit>().signOutPressed();
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(
                        'Cancel',
                        // style: TextStyle(
                        //   color: Theme.of(context).colorScheme.error,
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
