import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvmnt_cli/features/support/domain/entities/support_session_entity.dart';
import 'package:mvmnt_cli/features/support/presentation/widgets/active_sessions.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/features/support/presentation/widgets/grouped_avatars.dart';
import 'package:mvmnt_cli/ui/widgets/page_description.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Support'),
      body: Column(
        children: [
          SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PageDescription(description: "What can we help with?"),
                GroupedAvatars(
                  imageUrls: ['life-buoy', 'chat-bot', 'smile-plus'],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(thickness: 0.1),
          ),
          Expanded(
            child: ListView(
              children: [
                ActiveSessions(),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Support Options',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                ListTile(
                  title: Text('Get help with order'),
                  onTap: () async {
                    var newSession = await context.push<SupportSessionEntity?>(
                      '/support/select',
                    );

                    if (newSession != null) {
                      context.push('/support/contact', extra: newSession.id);
                    }
                  },
                  leading: SvgIcon(name: 'heart-handshake'),
                  trailing: SvgIcon(name: 'chevron-right'),
                ),
                ListTile(
                  title: Text('Feedback about the app'),
                  onTap: () => context.push('/support/feedback'),
                  leading: SvgIcon(name: 'feedback'),
                  trailing: SvgIcon(name: 'chevron-right'),
                ),
                ListTile(
                  title: Text('Browse FAQs'),
                  onTap: () {},
                  leading: SvgIcon(name: 'faq'),
                  trailing: SvgIcon(name: 'chevron-right'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
