//Dev URl
//const String baseUrl = "https://xplor-core-nest-dev.thewitslab.com/api/v1/";
// //Staging Url
const String baseUrl = "https://xplor-core-nest-staging.thewitslab.com/api/v1/";
// //Staging Kyc Url
const String eAuthWebHook = "https://xplor-core-nest-staging.thewitslab.com/e-auth/callback?code=";
//Dev Kyc Url
//const String eAuthWebHook = "https://xplor-core-nest-dev.thewitslab.com/e-auth/callback?code=";

// Api End points with base url
const String verifyKycApi = "${baseUrl}user/kyc";
const String sendOtpApi = "${baseUrl}user/send-otp";
const String verifyOtpApi = "${baseUrl}user/verify-otp";
const String getUserJourneyApi = "${baseUrl}user/journey";
const String assignRoleApi = "${baseUrl}user/role";
const String getUserRoleApi = "${baseUrl}user/roles";
const String getAuthProvidersApi = "${baseUrl}e-auth";
const String addDocumentApi = "${baseUrl}wallet/file";
const String getWalletApi = "${baseUrl}wallet";
const String getWalletVcApi = "${baseUrl}wallet/vcs?walletId=";
const String sharedWalletVcApi = "${baseUrl}wallet/vc/share";
const String deletedWalletVcApi = "${baseUrl}wallet/vc?";
const String getMyConsentsApi = "${baseUrl}wallet/vc/shared/requests?";
const String updateConsentApi = "${baseUrl}wallet/vc/shared/requests/update?";
const String revokeConsentApi = "${baseUrl}wallet/vc/shared/requests/status?";
const String generateMpinApi = "${baseUrl}user/create-mpin";
const String verifyMpinApi = "${baseUrl}user/verify-mpin";
const String userDataApi = "${baseUrl}user";
