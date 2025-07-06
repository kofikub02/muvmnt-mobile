import 'package:flutter/material.dart';
import 'package:mvmnt_cli/ui/forms/custom_text_field.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';
import 'package:mvmnt_cli/ui/widgets/custom_bottom_navigation_bar.dart';

class DeleteProfilePage extends StatefulWidget {
  const DeleteProfilePage({super.key});

  @override
  State<DeleteProfilePage> createState() => _DeleteProfilePageState();
}

class _DeleteProfilePageState extends State<DeleteProfilePage> {
  String? _selectedReason;
  final TextEditingController _messageController = TextEditingController();

  final List<String> reasons = [
    'I have a duplicate account',
    "I am concerned about my privacy",
    'I no longer need the service',
    "I am not satisfied with the experience",
    'Other',
  ];

  void _submitDeletionRequest() {
    final reason = _selectedReason;
    final message = _messageController.text.trim();

    // You can now call your Cubit/Bloc or API to handle the deletion
    print('Deleting account for reason: $reason');
    print('Message: $message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Delete Account'),
      bottomNavigationBar: CustomBottomNavigationBar(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: _selectedReason == null ? null : _submitDeletionRequest,
            child: Text('Delete My Account'),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: const Text(
                  'We are very sad to see you go, please tell us why you have to leave',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              ...reasons.map(
                (reason) => RadioListTile<String>(
                  title: Text(reason),
                  value: reason,
                  groupValue: _selectedReason,
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: CustomTextField(
                  maxLines: 4,
                  hintText: 'Please tell us what we can do better',
                  label: "Goodbye Feedback",
                  controller: _messageController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
