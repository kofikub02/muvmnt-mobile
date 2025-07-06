import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/safety/safety_cubit.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/safety/safety_state.dart';
import 'package:mvmnt_cli/ui/widgets/check_list.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/ui/widgets/sheet_dash.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';
import 'package:mvmnt_cli/ui/widgets/toggle_item.dart';

class SafetyPage extends StatelessWidget {
  const SafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SafetyCubit>(
      create: (_) => serviceLocator<SafetyCubit>(),
      child: _SafetyView(key: key),
    );
  }
}

class _SafetyView extends StatefulWidget {
  const _SafetyView({super.key});

  @override
  State<_SafetyView> createState() => _SafetyViewState();
}

class _SafetyViewState extends State<_SafetyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Safety'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('Delivery code'),
            onTap: () async {
              await _showUpdatePreference(context: context);
            },
            leading: SvgIcon(name: 'lock'),
            trailing: SvgIcon(name: 'chevron-right'),
          ),
        ],
      ),
    );
  }

  Future _showUpdatePreference({required BuildContext context}) {
    final safetyCubit = context.read<SafetyCubit>();
    context.read<SafetyCubit>().getDeliveryCodeStatus();

    return showModalBottomSheet(
      useRootNavigator: true,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (buildContext) {
        return BlocProvider.value(
          value: safetyCubit,
          child: Builder(
            builder: (context) {
              return BlocBuilder<SafetyCubit, SafetyState>(
                builder: (buildContext, subState) {
                  bool isLoading = subState.status == SafetyStatus.loading;

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
                          'Delivery Code',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            CheckList(
                              items: [
                                'Verify each fulfilment by matching a unique code with your courier',
                                'Feel safer knowing your items cannot be delivered to anyone else',
                                'Prevent someone else from taking your ride by mistake',
                              ],
                            ),
                            ToggleItem(
                              item: 'Enable delivery code',
                              loading: isLoading,
                              value: subState.settings?.codeEnabled ?? false,
                              onChanged: (toggleValue) {
                                context
                                    .read<SafetyCubit>()
                                    .updateDeliveryCodeStatus({
                                      'code_enabled': toggleValue,
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
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
