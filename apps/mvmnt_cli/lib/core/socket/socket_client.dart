// lib/core/network/socket/socket_client.dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mvmnt_cli/core/api/api_config.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'socket_event.dart';
import 'socket_exception.dart';

class SocketClient {
  // Socket instance
  IO.Socket? _socket;

  // Dio instance for authentication token
  final Dio _tokenDio = Dio();
  String? _cachedToken;
  DateTime? _tokenExpiry;

  // Connection status
  bool get isConnected => _socket?.connected ?? false;
  String? _currentUrl;

  // Event streams
  final Map<String, StreamController<SocketEvent>> _eventControllers = {};

  // Connection status stream
  final _connectionStatusController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  /// Connects to a Socket.IO server
  Future<void> connect({
    String? url,
    Map<String, dynamic>? options,
    bool autoReconnect = true,
  }) async {
    // Skip if already connected to this URL
    if (_socket != null && _currentUrl == url && _socket!.connected) {
      return;
    }

    // Disconnect if connected to a different URL
    if (_socket != null) {
      await disconnect();
    }

    try {
      _currentUrl =
          "http://18.222.224.202:3000"; // url ?? SocketConfig.baseUrl;
      final token = await _getToken();

      // Configure socket options
      final Map<String, dynamic> defaultOptions = {
        'transports': ['websocket'],
        'forceNew': true,
        'extraHeaders': {'authorization': token},
        'autoConnect': true,
        'reconnection': autoReconnect,
        'reconnectionAttempts': autoReconnect ? 5 : 0,
        'reconnectionDelay': 1000,
        'reconnectionDelayMax': 5000,
        'timeout': 20000,
      };

      // Merge with provided options
      final Map<String, dynamic> mergedOptions = {
        ...defaultOptions,
        ...(options ?? {}),
      };

      print('===========*************Current URl to connect');
      print(_currentUrl);
      print(mergedOptions);
      print(options);

      // Create socket instance
      _socket = IO.io(_currentUrl, mergedOptions);
      _socket?.onConnect((_) {
        print('connected in onConnect');
      });

      _socket?.on('connect', (data) {
        print('connected in on');
      });

      _socket?.on('connect_error', (error) {
        print('connected in onConnectError $error');
      });

      _socket?.on('error', (error) {
        // TODO: Manage and handle error
        print('Error in onError $error');
      });

      // Create a completer to wait for connection
      final completer = Completer<void>();

      // Set up basic event handlers
      _setupEventHandlers(completer);

      // Return a future that completes when connected
      return completer.future;
    } catch (e) {
      throw SocketException('Failed to initialize socket', e);
    }
  }

  /// Sets up basic event handlers for the socket
  void _setupEventHandlers(Completer<void> completer) {
    _socket!.onConnect((_) {
      _connectionStatusController.add(true);
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    _socket!.onConnectError((error) {
      _connectionStatusController.add(false);
      if (!completer.isCompleted) {
        completer.completeError(SocketException('Connection error', error));
      }
    });

    _socket!.onDisconnect((_) {
      _connectionStatusController.add(false);
    });

    _socket!.onError((error) {
      _connectionStatusController.add(false);
    });

    _socket!.onReconnect((_) {
      _connectionStatusController.add(true);
    });
  }

  /// Disconnects from the server
  Future<void> disconnect() async {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _currentUrl = null;

      // Close all event streams
      for (final controller in _eventControllers.values) {
        if (!controller.isClosed) {
          await controller.close();
        }
      }
      _eventControllers.clear();

      // Notify connection status
      _connectionStatusController.add(false);
    }
    return Future.value();
  }

  /// Emits an event to the server
  void emit(String event, dynamic data) {
    _ensureConnected();

    try {
      print('\n\n==========Inside Socket client Emit');
      print(event);
      print(data);
      _socket!.emit(event, data);
    } catch (e) {
      throw SocketException('Failed to emit event: $event', e);
    }
  }

  /// Listens for a specific event from the server
  Stream<SocketEvent> on(String event) {
    _ensureConnected();

    // Create a new stream controller if needed
    if (!_eventControllers.containsKey(event)) {
      final controller = StreamController<SocketEvent>.broadcast();
      _eventControllers[event] = controller;

      // Listen for events on the socket
      _socket!.on(event, (data) {
        if (!controller.isClosed) {
          controller.add(SocketEvent(name: event, data: data));
        }
      });
    }

    return _eventControllers[event]!.stream;
  }

  /// Stops listening for a specific event
  void off(String event) {
    if (_socket != null) {
      _socket!.off(event);

      if (_eventControllers.containsKey(event)) {
        _eventControllers[event]!.close();
        _eventControllers.remove(event);
      }
    }
  }

  /// Checks if the socket is connected
  void _ensureConnected() {
    if (_socket == null || !_socket!.connected) {
      throw SocketException('Socket not connected');
    }
  }

  /// Cleans up resources
  Future<void> dispose() async {
    await disconnect();

    if (!_connectionStatusController.isClosed) {
      await _connectionStatusController.close();
    }
  }

  Future<String> _getToken() async {
    if (_cachedToken != null &&
        _tokenExpiry != null &&
        _tokenExpiry!.isAfter(DateTime.now())) {
      print('cached token');
      print(_cachedToken);
      return _cachedToken!;
    }

    print('no cached token');

    final firebaseToken =
        await serviceLocator<FirebaseAuth>().currentUser?.getIdToken();
    if (firebaseToken != null) {
      var response = await _tokenDio.get(
        '${ApiConfig.baseUrl}/auth/token/muvmnt_cli',
        options: Options(headers: {'Authorization': 'Bearer $firebaseToken'}),
      );

      if (response.data != null && response.data['data'] != null) {
        final authToken = response.data['data'];
        _cachedToken = authToken;
        // Set token expiry (for example, 50 minutes from now)
        _tokenExpiry = DateTime.now().add(Duration(minutes: 60));
        // options.headers['Authorization'] = 'Bearer $authToken';
        return authToken;
      }
    }

    return '';
  }
}
