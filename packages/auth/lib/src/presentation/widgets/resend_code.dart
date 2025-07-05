import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/features/auth/presentation/cubits/phone_auth/phone_auth_cubit.dart';

class ResendCode extends StatefulWidget {
  final bool enabled;
  final String phoneNumber;

  const ResendCode({
    super.key,
    required this.enabled,
    required this.phoneNumber,
  });

  @override
  State<ResendCode> createState() => _ResendCodeState();
}

class _ResendCodeState extends State<ResendCode> {
  final TimeNotifier _timeNotifier = TimeNotifier();
  final ValueNotifier<int> _attemptCountNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _timeNotifier.startTimer(_attemptCountNotifier.value);
  }

  @override
  void dispose() {
    _timeNotifier.dispose();
    _attemptCountNotifier.dispose();
    super.dispose();
  }

  void _handleResend() {
    context.read<PhoneAuthCubit>().clearError();
    context.read<PhoneAuthCubit>().sendVerification(widget.phoneNumber, true);
    _attemptCountNotifier.value = (_attemptCountNotifier.value + 1).clamp(0, 3);
    _timeNotifier.startTimer(_attemptCountNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _timeNotifier,
            builder: (_, _) {
              final isActive = _timeNotifier.timer?.isActive ?? false;
              return GestureDetector(
                onTap: isActive ? null : _handleResend,
                child: Text(
                  'Resend code',
                  style: TextStyle(
                    color:
                        isActive
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 3),
            child: AnimatedBuilder(
              animation: _timeNotifier,
              builder: (_, _) => Text(_timeNotifier.timeString),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeNotifier extends ChangeNotifier {
  final List<int> _delaysInMinutes = [0, 4, 14, 44];
  Timer? timer;

  int _seconds = 0;
  int _minutes = 0;
  String timeString = "0:00";

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer(int attempt) {
    final delayMinutes =
        _delaysInMinutes[attempt.clamp(0, _delaysInMinutes.length - 1)];

    _minutes = delayMinutes;
    _seconds = 59;
    _updateTimeString();

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_minutes == 0 && _seconds == 0) {
        timer?.cancel();
        notifyListeners();
      } else {
        if (_seconds == 0) {
          _minutes--;
          _seconds = 59;
        } else {
          _seconds--;
        }
        _updateTimeString();
        notifyListeners();
      }
    });
  }

  void _updateTimeString() {
    timeString = "$_minutes:${_seconds.toString().padLeft(2, '0')}";
  }
}
