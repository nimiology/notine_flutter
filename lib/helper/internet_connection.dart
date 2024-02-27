import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isInternetConnected() async {
  ConnectivityResult result = await Connectivity().checkConnectivity();

  return result != ConnectivityResult.none;
}
