import 'dart:io';

import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:your_schedule/core/rpc_request/rpc.dart';

Logger getLogger() {
  return Logger();
}

void logRequestError(String message, Object? error, StackTrace stackTrace) {
  if (error is RPCError) {
    if (error.code == RPCError.invalidClientTime) {
      getLogger().w(message, error: error, stackTrace: stackTrace);
    } else if (error.code == RPCError.authenticationFailed) {
      getLogger().w(message, error: error, stackTrace: stackTrace);
    } else if (error.code == RPCError.tooManyResults) {
    } else {
      getLogger().e(message, error: error, stackTrace: stackTrace);
    }
  } else if (error is IllegalIdTokenException) {
    getLogger().w(message, error: error, stackTrace: stackTrace);
  } else if (error is SocketException) {
    getLogger().w(message, error: error, stackTrace: stackTrace);
  } else if (error is HttpException) {
    switch (error.statusCode) {
      case 504:
      case 529:
        getLogger().w('$message: Server down', error: error, stackTrace: stackTrace);
        break;

      default:
        getLogger().e(message, error: error, stackTrace: stackTrace);
    }
  } else if (error is ClientException) {
    getLogger().w(message, error: error, stackTrace: stackTrace);
  } else {
    getLogger().e(message, error: error, stackTrace: stackTrace);
  }
}
