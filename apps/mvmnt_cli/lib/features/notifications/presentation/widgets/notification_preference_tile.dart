import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/util/string_utils.dart';
import 'package:mvmnt_cli/features/notifications/domain/entities/notification_preference_entity.dart';
import 'package:mvmnt_cli/features/notifications/presentation/cubits/notification_preferences/notification_preferences_cubit.dart';
import 'package:mvmnt_cli/features/notifications/presentation/cubits/notification_preferences/notification_preferences_state.dart';
import 'package:mvmnt_cli/ui/widgets/sheet_dash.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';
import 'package:mvmnt_cli/ui/widgets/toggle_item.dart';

class NotificationPreferenceTile extends StatelessWidget {
  final int index;
  final NotificationPreferenceEntity preference;

  const NotificationPreferenceTile({
    super.key,
    required this.index,
    required this.preference,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(preference.topic.name),
      subtitle: Text(
        preference.channels
            .map(
              (channel) =>
                  '${channel.type.name.toCapitalized}: ${channel.status ? "on" : "off"}',
            )
            .join('; '),
      ),
      trailing: SvgIcon(name: 'chevron-right'),
      onTap: () async {
        await _showUpdatePreference(context: context, index: index);
      },
    );
  }

  Future _showUpdatePreference({
    required BuildContext context,
    required int index,
  }) {
    String updatingChannelName = '';
    final notificationPreferencesCubit =
        context.read<NotificationPreferencesCubit>();

    return showModalBottomSheet(
      useRootNavigator: true,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (buildContext) {
        return BlocProvider.value(
          value: notificationPreferencesCubit,
          child: Builder(
            builder: (context) {
              return BlocBuilder<
                NotificationPreferencesCubit,
                NotificationPreferencesState
              >(
                builder: (buildContext, subState) {
                  bool isUpdating =
                      subState.status == NotificationPreferenceStatus.updating;
                  var currentPreference =
                      subState.notificationPreferencesEntity[index];

                  return ListView(
                    shrinkWrap: true,
                    children: [
                      SheetDash(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Text(
                          currentPreference.topic.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        child: Text(
                          currentPreference.topic.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      ...(currentPreference.channels
                              .map(
                                (channel) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: ToggleItem(
                                    item: channel.type.name.toCapitalized,
                                    loading:
                                        isUpdating &&
                                        updatingChannelName ==
                                            channel.type.name,
                                    value: channel.status,
                                    onChanged: (toggleValue) {
                                      updatingChannelName = channel.type.name;
                                      context
                                          .read<NotificationPreferencesCubit>()
                                          .updatePreferences(
                                            currentPreference.id,
                                            NotificationPreferenceChannelEntity(
                                              type: channel.type,
                                              status: toggleValue,
                                            ),
                                          );
                                    },
                                  ),
                                ),
                              )
                              .toList()
                          as List<Widget>),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
