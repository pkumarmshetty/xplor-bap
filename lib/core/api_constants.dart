const String baseUrl = "https://xplor-core-nest-staging.thewitslab.com/api/v1/";
const String eAuthWebHook =
    "https://xplor-core-nest-staging.thewitslab.com/aadhaar-callback?code=";

// Api End points with base url
const String verifyKycApi = "${baseUrl}user/kyc";
const String sendOtpApi = "${baseUrl}user/send-otp";
const String verifyOtpApi = "${baseUrl}user/verify-otp";
const String getUserJourneyApi = "${baseUrl}user/journey";
const String assignRoleApi = "${baseUrl}user/role";
const String getUserRoleApi = "${baseUrl}user/roles";
const String getAuthProvidersApi = "${baseUrl}e-auth";
