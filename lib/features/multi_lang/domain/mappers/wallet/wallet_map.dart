import 'package:xplor/features/multi_lang/domain/mappers/wallet/wallet_keys.dart';

import '../app_utils/app_utils_keys.dart';
import '../mpin/generate_mpin_keys.dart';

final Map<String, dynamic> originalWalletMap = {
  /// Wallet No Document Keys
  WalletKeys.noDocumentAdded: "No Documents Added!",
  WalletKeys.noRecordFound: "No Record Found!",
  WalletKeys.thereIsNoDocumentAddedYet: "There is no document added yet.",
  WalletKeys.pleaseAddDocument: "Please add a document.",
  WalletKeys.addDocument: "Add Document",
  WalletKeys.wallet: "Wallet",
  WalletKeys.searchSomething: "Search something",

  /// Upload file Keys
  WalletKeys.selectFile: "Select File",
  WalletKeys.selectDocument: "Select Document",
  WalletKeys.choose: "Choose ",
  WalletKeys.fileToUpload: "file to upload",
  WalletKeys.upload: "Upload",
  WalletKeys.fileName: "File Name",
  WalletKeys.enterFileName: "Enter File Name",
  WalletKeys.fileSizeShouldBeLess: "File size should be less than 10 MB",
  WalletKeys.continueString: "Continue",

  /// Update/Share consent Keys
  WalletKeys.pleaseWait: "Please wait",
  WalletKeys.shareDocument: "Share Document",
  WalletKeys.selectDate: "Select Date",
  WalletKeys.cancel: "Cancel",
  WalletKeys.update: "Update",
  WalletKeys.ok: "Ok",
  WalletKeys.sharedTo: "Shared to",
  WalletKeys.sharedFile: "Shared File:",
  WalletKeys.remarks: "Remarks",
  WalletKeys.enterSomeRemarks: "Enter some remarks",
  WalletKeys.suggestedTags: "Suggested Tags:",
  WalletKeys.validity: "Validity",
  WalletKeys.onceOnly: "Once only",
  WalletKeys.oneDay: "1 Day",
  WalletKeys.threeDays: "3 Days",
  WalletKeys.customDaysString: "Custom Days",
  WalletKeys.day: " Day",
  WalletKeys.days: " Days",
  WalletKeys.scholarship: "Scholarship",
  WalletKeys.enterMPin: "Enter MPIN",

  /// Tags Widget
  WalletKeys.enterTags: "Enter Tags",
  WalletKeys.includeComma: "Include comma (,) separated values",
  WalletKeys.admission: "Admission",
  WalletKeys.job: "Job",
  WalletKeys.eachTagMustBeDifferent: "Each tag must be different",
  WalletKeys.tags1: "Tags1",
  WalletKeys.tags3: "tags2",
  WalletKeys.files: " files",

  /// Enter MPin Keys
  WalletKeys.forgotMPin: "Forgot PIN",
  WalletKeys.verifyShare: "Verify & Share",

  /// Document Widget Keys
  WalletKeys.share: "Share",
  WalletKeys.delete: "Delete",
  WalletKeys.deleteMessage: "Are you sure, you want to delete file",

  /// Add Document Keys
  WalletKeys.documentUploaded: "Document Uploaded Successfully",
  WalletKeys.documentUploadedMessage:
      "Your document has been successfully uploaded.",
  WalletKeys.documentUploadFailed: "Document Upload Failed!",
  WalletKeys.documentUploadFailedMessage:
      "An error occurred while uploading the file. Please try again later.",
  WalletKeys.forAssistance: "For assistance,",
  WalletKeys.contactSupport: "contact support.",
  WalletKeys.retry: "Retry",

  /// Tab Widget
  WalletKeys.myDocuments: "My Documents",
  WalletKeys.myConsents: "My Consents",

  /// My Previous consent
  WalletKeys.inactive: "Inactive",

  /// My Consents
  WalletKeys.consentGivenFor: "Consent given for:",
  WalletKeys.modifiedOn: "Modified On:",
  WalletKeys.revoke: "Revoke",
  WalletKeys.revokeMessage: "Are you sure, you want to revoke access",
  WalletKeys.noConsentSharedYet: "No Consent Shared Yet!",
  WalletKeys.thereAreCurrentlyNoConsent:
      "There are currently no consent\nrecords shared.",

  /// Bloc messages
  WalletKeys.fileNameCannotBeEmpty: "Filename cannot be empty",
  WalletKeys.fileNameErrorMessage:
      "File name error. Please ensure the file name meets requirements (eg. no special characters) ",
  WalletKeys.fileTagCannotBeEmpty: "File tags cannot be empty",

  /// My Consent List
  WalletKeys.activeConsents: "Active Consents",
  WalletKeys.previousConsents: "Previous Consents",
  WalletKeys.walletIdEmptyError:
      "Wallet Id is empty from backend so you are not able to upload any document",

  WalletKeys.linkGeneratedTitle: "Link Generated successfully",

  WalletKeys.linkGeneratedDescription:
      'The link is copied on the clipboard. Please paste it into the required field.',

  WalletKeys.gotIt: "Got it!",

  AppUtilsKeys.fileManager: "File Manager",
  AppUtilsKeys.photoGallery: "Photo Gallery",
  AppUtilsKeys.camera: "Camera",

  GenerateMpinKeys.generateMpin: "Generate MPIN",
  GenerateMpinKeys.generateMpinSecurelyForAccountAccess:
      "Your MPIN serves as a password for accessing your account securely on our platform.",
  GenerateMpinKeys.reEnter: "Re-Enter",
  GenerateMpinKeys.verify: "Verify",
  GenerateMpinKeys.thePinYouEnteredDoNotMatch:
      "The PINs you entered do not match. Please ensure that both PINs match before proceeding.",

  /// Reset MPin Keys:
  GenerateMpinKeys.mPinResetSuccessfully: "MPin Reset successfully",
  GenerateMpinKeys.resetMPin: "Reset MPIN",
  GenerateMpinKeys.verified: "VERIFIED",
  GenerateMpinKeys.verifyOtp: "Verify Otp",
  GenerateMpinKeys.sendCodeAgainIn: "Send code again in",
  GenerateMpinKeys.iDidntReceiveCode: "I didn’t receive code.",
  GenerateMpinKeys.resend: "Resend",
  GenerateMpinKeys.reEnterMPin: "Re-Enter MPIN",
  GenerateMpinKeys.thereIsAMismatchBetween:
      "There is a mismatch between pin1 and pin2!",
  GenerateMpinKeys.enterSixDigitsOtp:
      "Enter the 6 digit OTP that we have sent to",
  GenerateMpinKeys.enterOtp: "Enter OTP",
  GenerateMpinKeys.exceeded: "exceeded",
};
