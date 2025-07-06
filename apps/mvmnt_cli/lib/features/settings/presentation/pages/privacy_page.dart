import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_cubit.dart';
import 'package:mvmnt_cli/features/location/presentation/cubit/location_service_state.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/ui/widgets/page_description.dart';
import 'package:mvmnt_cli/features/settings/presentation/widgets/access_widget.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    context.read<LocationServiceCubit>().requestLocationServiceState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<LocationServiceCubit>().requestLocationServiceState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Privacy'),
      body: BlocBuilder<LocationServiceCubit, LocationServiceState>(
        builder: (context, state) {
          bool isLoading = state.status == LocationServiceStatus.fetching;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: PageDescription(
                    description:
                        'Muvmnt is dedicated to protecting your privacy and personal information',
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () async {},
                    child: Text('Learn more ↗', style: TextStyle(fontSize: 14)),
                  ),
                ),
                AccessWidget(
                  loading: isLoading,
                  title: 'Location access',
                  description:
                      "Allow location access to easily find nearby vendors and help ensure accurate deliveries",
                  status:
                      state.isLocationEnabled != null
                          ? state.isLocationEnabled!
                              ? 'Allowed'
                              : 'Denied'
                          : '',
                  onTap: () async {
                    context
                        .read<LocationServiceCubit>()
                        .onLocationAccessPressed();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
