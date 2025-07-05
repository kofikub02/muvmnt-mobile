import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvmnt_cli/core/util/device/device_utility.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/paypal/paypal_cubit.dart';
import 'package:mvmnt_cli/features/payments/presentation/cubits/paypal/paypal_state.dart';
import 'package:mvmnt_cli/ui/widgets/svg_icon.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalTile extends StatelessWidget {
  const PaypalTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PaypalWidget(key: Key('paypal_widget'));
  }
}

class _PaypalWidget extends StatefulWidget {
  const _PaypalWidget({super.key});

  @override
  State<_PaypalWidget> createState() => __PaypalWidgetState();
}

class __PaypalWidgetState extends State<_PaypalWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaypalCubit, PaypalState>(
      listenWhen:
          (previous, current) => previous.approvalUrl != current.approvalUrl,
      listener: (context, state) async {
        if (state.approvalUrl != null && state.approvalUrl!.isNotEmpty) {
          // Push to the webview screen
          final approvalToken = await Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => _PaypalWebviewVault(
                    key: const Key('paypalwebviewvault'),
                    approvalUrl: state.approvalUrl!,
                  ),
            ),
          );

          if (approvalToken != null &&
              approvalToken.runtimeType == String &&
              approvalToken.isNotEmpty) {
            context.read<PaypalCubit>().createPaymentToken(approvalToken);
          }
        }
      },
      builder: (context, state) {
        final var loading = state.status == PaypalStatus.loading;
        final var settingUp = state.status == PaypalStatus.settingUp;
        final bool hasMethod = state.methods.isNotEmpty;

        if (hasMethod || loading) {
          return Container();
        }

        return ListTile(
          leading: SvgIcon(name: 'paypal', hasIntrinsic: true),
          title: const Text('Paypal'),
          trailing:
              settingUp
                  ? const CircularProgressIndicator.adaptive()
                  : SvgIcon(name: 'chevron-right'),
          onTap:
              loading || settingUp
                  ? null
                  : () {
                    _onSetup(() {
                      if (!hasMethod) {
                        context.read<PaypalCubit>().setupPaypalInitiated();
                      }
                    });
                  },
        );
      },
    );
  }

  void _onSetup(Function onContinue) {
    if (TDeviceUtils.isIOS()) {
      showDialog(
        context: context,
        builder:
            (context) => CupertinoAlertDialog(
              title: const Text(
                '"Muvmnt" wants to Use "paypal.com" to Sign in',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'This allows the app and website to share information about you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    onContinue();
                    Navigator.pop(context);
                  },
                  child: const Text('Continue'),
                ),
              ],
            ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text(
                '"Muvmnt" wants to Use "paypal.com" to Sign in',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'This allows the app and website to share information about you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    onContinue();
                    Navigator.pop(context);
                  },
                  child: const Text('Continue'),
                ),
              ],
            ),
      );
    }
  }
}

class _PaypalWebviewVault extends StatefulWidget {

  const _PaypalWebviewVault({super.key, required this.approvalUrl});
  final String approvalUrl;

  @override
  State<_PaypalWebviewVault> createState() => __PaypalWebviewVaultState();
}

class __PaypalWebviewVaultState extends State<_PaypalWebviewVault> {
  late final WebViewController _controller;
  int loadingPagePercentage = 0;

  @override
  void initState() {
    super.initState();
    _initiateWebView();
  }

  void _initiateWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  loadingPagePercentage = 0;
                });
              },
              onProgress: (int progress) {
                setState(() {
                  loadingPagePercentage = progress;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  loadingPagePercentage = 100;
                });
              },
              onHttpError: (HttpResponseError error) {
                Navigator.pop(context);
              },
              onWebResourceError: (WebResourceError error) {
                Navigator.pop(context);
              },
              onNavigationRequest: (NavigationRequest request) {
                final uri = Uri.parse(request.url);

                if (uri.path.contains('/payments/paypal/setup/success')) {
                  final token = uri.queryParameters['approval_token_id'];
                  Navigator.pop(context, token);
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: const Border(),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: SvgIcon(name: 'x'),
        ),
        centerTitle: true,
        title: const Text('paypal.com'),
        actions: [
          IconButton(
            onPressed: () async {
              await _controller.reload();
            },
            icon: SvgIcon(name: 'reload'),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (loadingPagePercentage < 100) ...[
            LinearProgressIndicator(value: loadingPagePercentage / 100),
          ],
        ],
      ),
    );
  }
}
