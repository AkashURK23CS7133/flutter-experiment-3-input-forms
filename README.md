# Experiment 3 – Add Interactivity to App – Input and Forms

## Aim

To develop a Flutter application that displays a predefined list of products and allows users to search or filter the products using input widgets, providing an interactive user experience.

## Features

- `Form` containing a `TextFormField` (search by name), `DropdownButtonFormField` (category) and `Slider` (maximum price, Rs.0–Rs.1,00,000)
- Filters apply as you type/slide, and with the **Apply Filters** button
- **Clear Filters** resets every input
- "N product(s) found" counter and `GridView.builder` of 12 products
- `ProductCard` widget with **Add to Cart**, SnackBar feedback and cart badge

## Source files

`lib/main.dart`

## Dependencies

Only the Flutter SDK.

## Setup

Nothing extra – just run `flutter pub get`.

## Run

Open a terminal **in this folder** (VS Code: right-click the folder → *Open in Integrated Terminal*), then:

```powershell
flutter pub get        # download the packages listed in pubspec.yaml
flutter analyze        # check the code for problems (should say "No issues found!")
flutter test           # run the automated tests
flutter run -d chrome  # start the app in Chrome
```

While the app is running in the terminal: press `r` to hot-reload after editing code, `R` to restart, `q` to quit.

## Expected output

Product Search & Filter screen. Example: typing `su` shows only *Sunglasses*; a max price of Rs.45,000 shows 10 products.

Screenshots of the running app: [`../OUTPUTS/Experiment_03/`](../OUTPUTS/Experiment_03/)

## Troubleshooting

- **`flutter` is not recognized** – Flutter is not on your PATH. See the master README, section *Installing Flutter*.
- **"Unable to determine engine version"** – PowerShell is picking up the empty file `C:\Windows\System32\git` instead of real Git. Put Git first on PATH (see master README).
- **No Chrome device** – run `flutter devices`; install Google Chrome if it is missing.
