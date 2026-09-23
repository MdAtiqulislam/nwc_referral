# Admission Group (nwc_referral)

A Flutter referral/lead-management app for an admission group — capture student leads, manage follow-ups and stay in touch.

[![Google Play](https://img.shields.io/badge/Google_Play-Download-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=education.nwc.nwc_referral) [![App Store](https://img.shields.io/badge/App_Store-Download-0D96F2?style=for-the-badge&logo=app-store&logoColor=white)](https://apps.apple.com/app/id6746379395)


## Features

- Lead list with add-student flow (`addOrUpdateStudentNew`)
- Home page with bottom navigation and custom app bar
- Contact-us and FAQ sections
- File preview for documents
- Notifications page
- Login and edit-profile flows

## Tech Stack

- Flutter (Dart)
- GetX for state management and routing
- REST API backend

## Getting Started

```bash
flutter pub get
flutter run
```

Build a release APK:

```bash
flutter build apk --release
```

## Project Structure

```
lib/
├── app/modules/   # Leads, students, home, contact, FAQ, auth
├── services/      # API and platform services
├── theme/         # App theme
└── main.dart      # App entry point
```

## Notes

- App label: "Admission Group" (Android)
- No secrets or keystores are committed to this repository.
