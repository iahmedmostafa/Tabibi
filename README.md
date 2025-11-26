# 🩺 Tabibi - Your Personal Healthcare Companion

> A modern, secure, and user-friendly Flutter application designed to streamline healthcare access and management.

**Tabibi** ("My Doctor") is a comprehensive mobile application built with Flutter that connects patients with healthcare services. It features a robust authentication system, secure data handling, and a clean, intuitive user interface designed for optimal user experience.

---

## ✨ Features

### 🔐 Authentication & Security

- **Secure Sign Up & Login**: Email and password authentication with robust validation.
- **Forgot Password Flow**: Complete flow including email verification, OTP entry, and password reset.
- **OTP Verification**: Secure 6-digit code verification for account activation and password resets.
- **Token Management**: Secure storage of access and refresh tokens using `flutter_secure_storage`.

### 👤 User Experience

- **Onboarding**: Engaging onboarding screens to guide new users.
- **Responsive Design**: Fully responsive UI adapting to various screen sizes using `flutter_screenutil`.
- **Modern UI/UX**: Clean aesthetics with `Google Fonts` and `Iconsax` for a premium feel.

### ⚙️ Core Functionality

- **State Management**: Efficient state handling using **Cubit** (Bloc pattern).
- **Dependency Injection**: Decoupled architecture using `get_it`.
- **Network Layer**: Robust API communication with `Dio` and custom error handling.

---

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (SDK ^3.9.2)
- **Language**: [Dart](https://dart.dev/)
- **Architecture**: Clean Architecture (Data, Domain, Presentation)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) (Cubit)
- **Routing**: [go_router](https://pub.dev/packages/go_router)
- **Networking**: [dio](https://pub.dev/packages/dio)

---

## 📦 Packages Used

| Package                    | Usage                                                                |
| :------------------------- | :------------------------------------------------------------------- |
| **flutter_bloc**           | State management using the BLoC/Cubit pattern.                       |
| **dio**                    | Powerful HTTP client for API requests.                               |
| **go_router**              | Declarative routing and navigation.                                  |
| **get_it**                 | Service locator for dependency injection.                            |
| **dartz**                  | Functional programming concepts (Either, Option) for error handling. |
| **flutter_screenutil**     | Screen adaptation and responsiveness.                                |
| **flutter_secure_storage** | Secure storage for sensitive data like tokens.                       |
| **shared_preferences**     | Persistent storage for simple data (e.g., onboarding status).        |
| **iconsax**                | High-quality icon pack.                                              |
| **google_fonts**           | Custom typography.                                                   |
| **pin_code_fields**        | Customizable input field for OTP verification.                       |
| **carousel_slider**        | Carousel widget for onboarding and banners.                          |
| **equatable**              | Value equality for efficient state comparison.                       |

---

## 🏗 Architecture

This project follows **Clean Architecture** principles to ensure separation of concerns, testability, and scalability.

### Folder Structure

```
lib/
├── core/                   # Core utilities, constants, network, and widgets
│   ├── error/              # Custom error handling (Failures, Exceptions)
│   ├── network/            # API constants and models
│   ├── routing/            # App router configuration
│   ├── style/              # Theme, colors, and spacing
│   ├── utils/              # Validators and constants
│   └── widgets/            # Reusable global widgets
├── features/               # Feature-based modules
│   ├── authentication/     # Auth feature (Login, Signup, Verify, etc.)
│   │   ├── data/           # Repositories, Data Sources, Models
│   │   ├── domain/         # Use Cases, Entities, Repository Interfaces
│   │   └── modules/        # Presentation (Cubits, Screens, Widgets)
│   ├── home/               # Home screen feature
│   └── onboarding/         # Onboarding feature
└── main.dart               # App entry point
```

---

## 📸 UI Preview

<!-- Add your screenshots here -->


---

## 🚀 Installation & Setup

Follow these steps to run the project locally.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- Android Studio or VS Code set up.

### Steps

1.  **Clone the repository**

    ```bash
    git clone https://github.com/your-username/tabibi.git
    cd tabibi
    ```

2.  **Install dependencies**

    ```bash
    flutter pub get
    ```

3.  **Run the app**
    - **Android**: `flutter run` (Select your emulator or device)
    - **iOS**: `flutter run` (Requires macOS)

---

## 🌍 Environment Configuration

This project connects to a remote API. Ensure you have the correct base URL configured in `lib/core/network/api_constance.dart`.

```dart
class ApiConstance {
  static const String baseUrl = "https://tabibi.runasp.net/";
  // ... other endpoints
}
```

---

## 🤝 Contributing

Contributions are welcome! If you'd like to improve Tabibi, please follow these steps:

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- Placeholder for License Badge -->

![License](https://img.shields.io/badge/license-MIT-blue.svg)

---

## 👏 Credits

- **Flutter Team** for the amazing framework.
- **Iconsax** for the beautiful icons.
- **Open Source Community** for the invaluable packages.

---

<p align="center">
  Made with ❤️ by [Your Name/Team]
</p>
