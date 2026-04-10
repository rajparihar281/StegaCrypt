# StegaCrypt

A Flutter-based image steganography app that lets you hide and retrieve secret text messages inside PNG images using the 2nd Least Significant Bit (2nd LSB) technique.

## Features

- **Encode** — Hide a text message inside any image from your gallery or camera
- **Decode** — Extract hidden text from a previously encoded image
- Encoded images are saved to `DCIM/` on your device
- Share encoded images directly from the app

## How It Works

Text is converted to binary and embedded into the 2nd LSB of each RGB channel of the image pixels. A 32-bit header stores the message length for accurate extraction. The visual change to the image is imperceptible to the human eye.

## Tech Stack

- Flutter (Dart) — SDK `^3.7.0`
- [`image`](https://pub.dev/packages/image) — pixel-level image manipulation
- [`image_picker`](https://pub.dev/packages/image_picker) — gallery/camera access
- [`permission_handler`](https://pub.dev/packages/permission_handler) — runtime permissions
- [`share_plus`](https://pub.dev/packages/share_plus) — share encoded images

## Getting Started

### Prerequisites

- Flutter SDK `^3.7.0`
- Android device or emulator (API 21+)

### Run

```bash
flutter pub get
flutter run
```

## Permissions Required

- Camera
- Storage (read/write)

## Limitations

- Only PNG output is supported (lossless format required for steganography)
- Message size is limited by image resolution: `width × height × 3 - 32` bits
