import 'package:flutter/material.dart';
import 'package:mvmnt_cli/ui/forms/custom_text_field.dart';
import 'package:mvmnt_cli/ui/widgets/custom_app_bar.dart';

class FeedBackPage extends StatefulWidget {
  const FeedBackPage({super.key});

  @override
  State<FeedBackPage> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  bool isUpdating = false;

  late final TextEditingController _feedbackController;

  @override
  void initState() {
    _feedbackController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Submit Feedback'),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isUpdating ? null : _onSend,
              child:
                  isUpdating
                      ? CircularProgressIndicator.adaptive()
                      : Text('Submit'),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 8),
            CustomTextField(
              enabled: true,
              maxLines: 5,
              hintText: 'Please describe in detail',
              label: "Please share your honest feedback",
              controller: _feedbackController,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSend() async {
    return;
  }
}
