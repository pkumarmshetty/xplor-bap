import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool>? get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity? connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectionChecker!.checkConnectivity();

    return (connectivityResult.first == ConnectivityResult.mobile ||
            connectivityResult.first == ConnectivityResult.wifi ||
            connectivityResult.first == ConnectivityResult.ethernet)
        ? true
        : false;
  }
}
