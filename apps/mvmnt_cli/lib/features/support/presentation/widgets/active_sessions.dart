import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/core/util/formatters/formatter.dart';
import 'package:mvmnt_cli/features/support/presentation/cubits/session/support_session_cubit.dart';
import 'package:mvmnt_cli/features/support/presentation/cubits/session/support_session_state.dart';
import 'package:mvmnt_cli/ui/shimmers/shimmer_list_tile.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class ActiveSessions extends StatefulWidget {
  const ActiveSessions({super.key});

  @override
  State<ActiveSessions> createState() => _ActiveSessionsState();
}

class _ActiveSessionsState extends State<ActiveSessions> {
  @override
  void initState() {
    context.read<SupportSessionCubit>().getActiveSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportSessionCubit, SupportSessionState>(
      builder: (context, state) {
        if (state.status == SessionStatus.loading) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: ShimmerListTile(),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.activeSessions.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Support Sessions',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ],
            ...state.activeSessions.map((session) {
              return ListTile(
                title: Text('Case for Order ${session.id.substring(0, 7)}'),
                subtitle: Text(
                  'Opened on ${TFormatter.formatDate(session.createdAt)}',
                ),
                leading: SvgIcon(name: 'dashed-chat'),
                trailing: SvgIcon(name: 'chevron-right'),
                onTap:
                    () => context.push('/support/contact', extra: session.id),
              );
            }),
            if (state.activeSessions.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(thickness: 0.2),
              ),
            ],
          ],
        );
      },
    );
  }
}
