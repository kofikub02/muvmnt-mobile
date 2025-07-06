import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/notifications/presentation/widgets/notification_preference_tile.dart';
import 'package:mvmnt_cli/features/notifications/presentation/cubits/notification_preferences/notification_preferences_cubit.dart';
import 'package:mvmnt_cli/features/notifications/presentation/cubits/notification_preferences/notification_preferences_state.dart';
import 'package:mvmnt_cli/ui/shimmers/shimmer_list_tile.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';

class NotificationPreferencesPage extends StatelessWidget {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationPreferencesCubit>(
      create: (_) => serviceLocator<NotificationPreferencesCubit>(),
      child: _NotificationPreferencesView(key: key),
    );
  }
}

class _NotificationPreferencesView extends StatefulWidget {
  const _NotificationPreferencesView({super.key});

  @override
  State<_NotificationPreferencesView> createState() =>
      _NotificationPreferencesViewState();
}

class _NotificationPreferencesViewState
    extends State<_NotificationPreferencesView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationPreferencesCubit>().getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Notifications'),
      body: BlocBuilder<
        NotificationPreferencesCubit,
        NotificationPreferencesState
      >(
        builder: (context, state) {
          var isLoading = state.status == NotificationPreferenceStatus.loading;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                  ), // Add some spacing at the top
                  child: ListView.builder(
                    itemCount:
                        isLoading
                            ? 6
                            : state.notificationPreferencesEntity.length,
                    itemBuilder: (context, index) {
                      if (isLoading) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 10,
                          ),
                          child: ShimmerListTile(),
                        );
                      }

                      return NotificationPreferenceTile(
                        index: index,
                        preference: state.notificationPreferencesEntity[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
