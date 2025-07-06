import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/features/settings/domain/entities/theme_entity.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/theme/theme_cubit.dart';
import 'package:mvmnt_cli/features/settings/presentation/cubits/theme/theme_state.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Dark Mode'),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile<ThemeType>(
                value: ThemeType.dark,
                groupValue: state.themeEntity?.themeType,
                onChanged: (value) {
                  context.read<ThemeCubit>().setTheme(ThemeType.dark);
                },
                title: Text('On'),
              ),
              RadioListTile<ThemeType>(
                value: ThemeType.light,
                groupValue: state.themeEntity?.themeType,
                onChanged: (value) {
                  context.read<ThemeCubit>().setTheme(ThemeType.light);
                },
                title: Text('Off'),
              ),
              RadioListTile<ThemeType>(
                value: ThemeType.system,
                groupValue: state.themeEntity?.themeType,
                onChanged: (value) {
                  context.read<ThemeCubit>().setTheme(ThemeType.system);
                },
                title: Text('System Settings'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
                child: Text(
                  'If system settings is selected, the appearance will automatically adjust based on your device system settings',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
