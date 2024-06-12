import '../../../../../core/exception_errors.dart';

final Map<String, dynamic> originalNetworkErrorMaps = {
  ExceptionErrors.checkInternetConnection: "Check your internet connection.",
  ExceptionErrors.requestCancelError: "Request to API server was cancelled",
  ExceptionErrors.connectionTimeOutError: "Connection timeout with API server",
  ExceptionErrors.unknownConnectionError: "Connection to API server failed due to internet connection",
  ExceptionErrors.receiveTimeOutError: "Receive timeout in connection with API server",
  ExceptionErrors.badResponseError: "response.error",
  ExceptionErrors.sendTimeOutError: "Send timeout in connection with API server",
  ExceptionErrors.badCertificate: "Bad certificate",
  ExceptionErrors.serverConnectingIssue: "Server connecting issues",
  ExceptionErrors.unexpectedErrorOccurred: "Unexpected error occurred",
  ExceptionErrors.unknownErrorOccurred: "Unknown error occurred",
  ExceptionErrors.unknownError: "Unknown error",
};
