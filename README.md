
# Amaraga – Personal Finance Management App

Amaraga is a personal finance management mobile application developed using Flutter and Dart. This application helps users record, manage, and monitor their personal income and expenses in one place.

## About the Project

Amaraga was developed as a project for the Mobile Application Programming (Pemrograman Aplikasi Bergerak) course.

The application provides a simple and user-friendly interface to help users manage their daily financial activities.

## Features

- **Dashboard** – Displays total balance, income, expenses, and recent transactions.
- **Add Transaction** – Record new income and expense transactions.
- **Transaction History** – View previously recorded transactions.
- **Transaction Filter** – Filter transactions by All, Income, or Expense.
- **Financial Statistics** – View income, expenses, balance, and financial comparisons.
- **User Profile** – Displays user profile information.

## Built With

- Flutter
- Dart
- SQLite
- sqflite
- path
- Visual Studio Code
- Android Studio

## 📂 Project Structure

```text
lib/
├── main.dart
├── database/
│   └── database_helper.dart
├── models/
│   └── transaction_model.dart
├── screens/
│   ├── home_screen.dart
│   ├── transaction_screen.dart
│   ├── add_transaction_screen.dart
│   ├── statistics_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── balance_card.dart
│   ├── bottom_navigation.dart
│   └── transaction_tile.dart
└── theme/
    └── app_theme.dart
```

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code

### Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/YOUR-USERNAME/amaraga.git
   ```

2. Navigate to the project directory:

   ```bash
   cd amaraga
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

## Database

Amaraga uses SQLite as its local database to store transaction data, including income and expenses. The database is managed using the `sqflite` package.

## Developer

**Amanda Damayanti**

Information Systems Student  
Institut Teknologi PLN

## 📌 Project Status

Currently under development as part of the Mobile Application Programming course project.

---

⭐ If you find this project interesting, feel free to explore the repository!
