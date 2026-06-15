# Journal Trend Analyzer - Guide & Instructions

This guide provides instructions on how to set up, run, test, and build the **Journal Trend Analyzer** Flutter application.

---

## Prerequisites

Ensure you have the following installed on your system:
- **Flutter SDK** (recommended version `3.11.x` or later)
- **Dart SDK** (automatically bundled with Flutter)
- **Java Development Kit (JDK)** (required for Android builds)
- **Android Studio** or **VS Code** with Flutter & Dart extensions
- A physical Android device with **USB Debugging** enabled, or an Android Emulator

---

## Getting Started

1. Open your terminal and navigate to the project sub-directory:
   ```bash
   cd journaltrend
   ```

2. Retrieve project dependencies:
   ```bash
   flutter pub get
   ```

3. Perform static code analysis to ensure there are no issues:
   ```bash
   flutter analyze
   ```

---

## How to Run the App

### 1. Run on an Emulator or Connected Device
Make sure an emulator is running or your physical device is connected, then run:
```bash
flutter run
```

### 2. Run on Google Chrome (Quick Web Preview)
If you do not have an emulator or device setup, you can test the UI layout instantly in your browser:
```bash
flutter run -d chrome
```

---

## How to Build the Android APK

To generate a standalone APK package that can be shared and installed on any physical Android device:

1. Clean the previous build files:
   ```bash
   flutter clean
   ```

2. Fetch dependencies again:
   ```bash
   flutter pub get
   ```

3. Build the release APK:
   ```bash
   flutter build apk --release
   ```

4. Locate your build artifact:
   Once the compilation finishes, the installer APK will be available at:
   `journaltrend/build/app/outputs/flutter-apk/app-release.apk`

---

## Deploying to a Physical Android Device

1. Copy the generated `app-release.apk` file from your computer to your Android phone (via USB cable, Google Drive, email, or messaging app).
2. Open the file manager on your phone, locate the copied APK, and tap it.
3. If prompted, allow **"Install from unknown sources"** in your device security settings to complete the installation.
4. Open the installed **Journal Trend Analyzer** app and run your tests.
