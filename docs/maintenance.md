# Application Maintenance Guide

This document outlines the processes and workflows for keeping the StegaCrypt application up-to-date and maintainable.

## 1. Checking for Outdated Dependencies
To check if any Dart/Flutter packages have newer versions, run:
```bash
flutter pub outdated
```
This command shows all outdated dependencies. The output distinguishes between safely upgradable packages and those that require major version bumps.

## 2. Upgrading Dependencies
### Minor and Patch Updates (Safe)
To update compatible packages to their latest safe versions, run:
```bash
flutter pub upgrade
```

### Major Version Upgrades
To upgrade packages that involve major, potentially breaking changes:
1. Review the package's changelog on pub.dev.
2. Manually edit `pubspec.yaml` with the new version constraint.
3. Run `flutter pub get`.
4. Run `flutter analyze` and `flutter test` to fix any breaking API changes in the code.

## 3. Flutter SDK Management
This project currently uses Flutter version `3.47.1`.
- GitHub Actions is pinned to `3.47.1` in `.github/workflows/flutter_ci.yml`.
- When upgrading Flutter locally (`flutter upgrade`), remember to also update the version pinned in the CI workflows (`flutter_ci.yml` and `release.yml`).

## 4. Android & iOS Updates
### Android
Dependabot monitors Gradle dependencies located in `android/build.gradle.kts` and `android/app/build.gradle.kts`. When an Android Gradle Plugin (AGP) or Kotlin update is needed, Dependabot will open a PR. Ensure the new AGP version is compatible with the current Flutter SDK version.

### iOS
CocoaPods dependencies will be generated when native iOS plugins are added. Ensure you update your local pods by running:
```bash
cd ios
pod repo update
pod install
```
*(Note: Dependabot is not currently configured for CocoaPods as there is no `Podfile` in the repository.)*

## 5. Application Versioning
The application uses Semantic Versioning defined in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```
- `1.0.0`: `MAJOR.MINOR.PATCH` format.
    - `PATCH`: bug fixes.
    - `MINOR`: backwards-compatible features.
    - `MAJOR`: breaking changes.
- `+1`: The build number. This **must** be incremented for each new upload to the Google Play Store or Apple App Store.

## 6. Creating a Release
This project has an automated release workflow configured via GitHub Actions.
1. Update the `version` in `pubspec.yaml` (e.g., to `1.1.0+2`).
2. Commit the change.
3. Create a Git tag that matches the new version prefix (e.g., `v1.1.0`).
```bash
git tag v1.1.0
git push origin v1.1.0
```
4. Pushing the tag will trigger `.github/workflows/release.yml`, which will build the release APK and publish it as a GitHub Release.

## 7. Automated Dependency Workflow
- **Dependabot** checks for outdated dependencies (Dart, Gradle, GitHub Actions) weekly.
- When an update is found, it opens a Pull Request.
- **GitHub Actions** runs automatically on the PR (`flutter analyze`, `flutter test`, `flutter build apk --debug`).
- Review the PR and ensure checks pass before merging. **Do not enable automatic merging.**
