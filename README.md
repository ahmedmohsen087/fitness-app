# 🏋️‍♂️ Fitness & AI Smart Coach Mobile Application

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-4CAF50?style=for-the-badge)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![State Management](https://img.shields.io/badge/State%20Management-BLoC%20%2F%20Cubit-blue?style=for-the-badge)](https://bloclibrary.dev)
[![AI Powered](https://img.shields.io/badge/AI-Ollama%20LLM-FF6F00?style=for-the-badge)](https://ollama.com)

A comprehensive, modern cross-platform Flutter application designed to deliver personal fitness workouts, tailored nutrition plans, and an intelligent **AI Smart Coach** assistant. Built following **Clean Architecture**, **SOLID Principles**, and **BLoC Pattern**.

---

## 🌟 Key Features

### 🤖 1. Smart Coach (AI Fitness & Nutrition Assistant)
* **Intelligent Recommendations**: Conversational AI powered by Ollama LLM integration that answers nutrition and exercise queries in natural Arabic and English.
* **Category-Aware Food Suggestions**: Smart category mapping (Seafood, Beef, Chicken, Pasta, Vegetarian, Dessert) prioritizing specific user cravings.
* **Exercise Action Cards**: Directly generates interactive UI action cards embedded in chat for instant navigation to target muscle exercises.
* **Persistent Chat Sessions**: Stores local chat session history using **Hive**.

### 🏋️ 2. Fitness & Workout Training
* **Muscle Group Directory**: Browse target muscle groups (Chest, Back, Biceps, Triceps, Shoulders, Quadriceps, Abdominals, etc.).
* **Targeted Muscle Workouts**: Detailed exercise routines with images, difficulty levels, and step-by-step instructions.
* **Video Tutorials**: Embedded YouTube video player (`youtube_player_iframe`) for exercise demonstrations.

### 🥗 3. Food & Nutrition Catalog
* **Category Browsing**: Live data integration with **TheMealDB API**.
* **Meal Details & Recipes**: Full ingredients list, cooking instructions, area/origin, and high-resolution media.

### 👤 4. User Profile & Personalization
* **Fitness Metric Tracking**: Age, Weight, Height, Gender, and Fitness Goal customization.
* **Profile Image Processing**: Custom photo picker, image compression (`flutter_image_compress`), and secure storage.

### 🔐 5. Security & Authentication
* **Secure Auth Flow**: Registration, Sign-In, Google Social Sign-In, Forgot Password, and OTP Verification (`pinput`).
* **Encrypted Storage**: JWT Token storage via `flutter_secure_storage`.

### 🌐 6. Multi-language & UI Excellence
* **Full RTL / LTR Support**: Arabic and English localizations powered by `easy_localization`.
* **Shimmer Effects**: Smooth skeletonized loading screens via `skeletonizer`.

---

## 🏗️ Architecture & Technical Stack

The codebase strictly adheres to **Clean Architecture** separated into three distinct layers per feature:

```text
lib/
 ├── core/                      # Global utilities, network clients, base contracts & themes
 └── features/
      ├── auth/                 # Authentication & Security Feature
      ├── fitness/              # Exercises & Muscle Training Feature
      ├── food/                 # Meals & Recipes Feature
      ├── home/                 # Dashboard & Quick Access Feature
      ├── profile/              # User Profile & Metrics Feature
      └── smart_coach/          # AI Coach Chat & Action Handler Feature
           ├── api/             # Remote Data Sources & DTO Models
           ├── data/            # Repositories Implementation & Local Data Sources
           ├── domain/          # Entities, Use Cases & Repository Contracts
           └── presentation/    # BLoC ViewModels, Screens & UI Widgets
```

### 🛠️ Core Libraries & Tools

| Category | Technology / Package |
| :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) (Dart 3.x) |
| **State Management** | [flutter_bloc](https://pub.dev/packages/flutter_bloc) & [RxDart](https://pub.dev/packages/rxdart) |
| **Dependency Injection** | [get_it](https://pub.dev/packages/get_it) & [injectable](https://pub.dev/packages/injectable) |
| **Networking & APIs** | [dio](https://pub.dev/packages/dio), [retrofit](https://pub.dev/packages/retrofit), [pretty_dio_logger](https://pub.dev/packages/pretty_dio_logger) |
| **Local Storage & Cache** | [hive](https://pub.dev/packages/hive), [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage), [shared_preferences](https://pub.dev/packages/shared_preferences) |
| **Localization** | [easy_localization](https://pub.dev/packages/easy_localization) |
| **Media & UI** | [cached_network_image](https://pub.dev/packages/cached_network_image), [flutter_svg](https://pub.dev/packages/flutter_svg), [lottie](https://pub.dev/packages/lottie), [skeletonizer](https://pub.dev/packages/skeletonizer) |
| **Testing** | `flutter_test`, `bloc_test`, `mockito`, `network_image_mock` |

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK `^3.12.1` or higher
* Dart SDK `^3.x`
* Android Studio or VS Code with Flutter extension
* **Local Machine Ollama Instance**: [Ollama](https://ollama.com) must be installed and running locally on your machine (`http://localhost:11434` or `http://10.0.2.2:11434` for Android Emulator) to power the AI Smart Coach feature.

### 🤖 Local Ollama Setup (Required for AI Smart Coach)

To use the AI Smart Coach feature, you must have Ollama running locally on your machine:

1. **Download & Install Ollama** from [ollama.com](https://ollama.com).
2. **Start Local Ollama Server & Pull Model:**
   ```bash
   ollama run gemma3
   ```
3. Ensure the local Ollama instance is active and listening on port `11434` (`http://localhost:11434` or `http://10.0.2.2:11434` for Android Emulator).

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/ahmedmohsen087/fitness-app.git
   cd fitness-app
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Dependencies & Retrofit API Clients:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the Application:**
   ```bash
   flutter run
   ```

---

## 👥 Engineering Team & Contributors

This application was developed by a team of software engineers:

| Contributor | Role | GitHub Profile |
| :--- | :--- | :--- |
| **AbdEl-Rahman Mohamed Shalaan** | Lead Flutter Engineer | [@AER-Shalaan](https://github.com/AER-Shalaan) |
| **Ahmed Mohsen** | Flutter Engineer | [@ahmedmohsen087](https://github.com/ahmedmohsen087) |
| **Mohamed Abbas** | Flutter Engineer | [@MohamedAbbas289](https://github.com/MohamedAbbas289) |
| **Mohamed Ebrahim** | Flutter Engineer | [@MohamedEbrahim10](https://github.com/MohamedEbrahim10) |

---

## 📝 License

This project is proprietary and intended for private use. All rights reserved.