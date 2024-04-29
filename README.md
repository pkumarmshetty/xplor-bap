# Project Title : Xplor

This Flutter mobile app is designed to provide a secure and convenient way for users to manage their documents digitally.
It includes features for user authentication, role selection, KYC (Know Your Customer) verification, and document management.The app is currently in active development for the Android platform.

## Table of Contents

- [Features]
- [Installation]
- [Contributing]
- [License]
- [Contact]


## Features

1. User Authentication:

- Description: Users can authenticate using their phone number and verify their identity using OTP (One-Time Password).

2. Role Selection:
- Description: Users can select their role as an agent or seeker based on their requirements and preferences.

3. KYC Verification:
- Description: The app facilitates KYC verification for users to ensure compliance with regulatory requirements.

4. MPIN Creation and Verification
- Description: Users can create and verify an MPIN to add an extra layer of security before sharing documents.
- Functionality:
    - MPIN creation: Users must first create a unique MPIN before document sharing.
    - MPIN verification: Before sharing sensitive documents, users are prompted to enter their MPIN to authenticate their identity.
    - Security enhancement: MPIN serves as an additional security measure, protecting documents from unauthorized access or sharing.


5. Document Management
- Description: Users can manage their documents digitally within the app.
- Functionality:
    - Digital wallet: Users have access to a digital wallet where they can store their documents securely.
    - Document actions:
        - View: Users can view the details of their stored documents.
        - Update: Documents can be updated with new information or versions.
        - Share: Users can share their documents with authorized parties.
        - Delete: Unwanted or outdated documents can be deleted from the digital wallet.

6. Consent Information Management with Expiry
- Description: Users can manage consent information associated with their documents, including a duration for consent expiration.
- Functionality:
    - Specify duration: When granting consent for document access or sharing, users can specify a duration for which the consent remains valid.
    - Automatic expiration: After the specified duration elapses, the consent for document access expires automatically, restricting further access unless renewed.

## Installation

To install and run the app locally, follow these steps:

1. Ensure you have Flutter installed on your machine. If not, follow the installation instructions on the [Flutter website](https://flutter.dev/docs/get-started/install).

2. Clone the repository:

   git clone <https://gitlab.thewitslab.com/wil-workspace/xplor/xplor-reference-app>

3. Navigate to the project directory:

   cd [path to project-directory]

4. Install dependencies:

   flutter pub get

5. Run the app:

   flutter run

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Your Name - your@email.com

Project Link: [https://gitlab.thewitslab.com/wil-workspace/xplor/xplor-reference-app]
