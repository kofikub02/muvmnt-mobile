import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/features/orders/presentation/widgets/completed_order_card.dart';
import 'package:mvmnt_cli/features/support/presentation/cubits/session/support_session_cubit.dart';
import 'package:mvmnt_cli/features/support/presentation/cubits/session/support_session_state.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/ui/widgets/loading_overlay.dart';

class SelectOrderForSupportPage extends StatefulWidget {
  const SelectOrderForSupportPage({super.key});

  @override
  State<SelectOrderForSupportPage> createState() =>
      _SelectOrderForSupportPageState();
}

class _SelectOrderForSupportPageState extends State<SelectOrderForSupportPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportSessionCubit, SupportSessionState>(
      listenWhen:
          (previousState, currentState) =>
              previousState.status != currentState.status,
      listener: (context, state) {
        if (state.status == SessionStatus.created &&
            state.activeSessions.isNotEmpty) {
          context.pop(state.activeSessions[0]);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Select related order'),
          body: LoadingOverlay(
            isLoading: state.status == SessionStatus.loading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: Text('What order do you need help with?'),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return CompletedOrderCard(
                        onSelected: (orderId) {
                          context.read<SupportSessionCubit>().initiateSession(
                            orderId,
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(thickness: 4, color: Colors.grey.shade200);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
