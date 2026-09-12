# BuyVerse App

Join BuyVerse and step into the future of digital commerce! Whether you're hunting for the best deals on things you love or ready to turn your own items into real profit, BuyVerse gives you a smart, secure, and lightning-fast platform that connects buyers and sellers in one vibrant community.

## Features

- **User Authentication**: Login, Register, and OTP verification
- **Product Browsing**: Browse products with categories and search functionality
- **Favorites**: Save favorite products for quick access
- **Shopping Cart**: Add products to cart and manage orders
- **Profile Management**: View and edit user profile
- **Order Tracking**: Track order history and status
- **Admin Panel**: Complete admin dashboard for product and order management
- **Multi-language Support**: English and Arabic localization
- **Dark/Light Theme**: Toggle between dark and light modes
- **Responsive Design**: Optimized for various screen sizes

## Tech Stack

- **Framework**: Flutter
- **State Management**: BLoC/Cubit
- **Architecture**: Clean Architecture (Domain, Data, Presentation layers)
- **Networking**: Dio
- **Local Storage**: SharedPreferences, Hive
- **Firebase**: FCM for push notifications
- **Maps**: Google Maps integration

## Project Structure

```
lib/
├── core_layer/              # Core utilities and helpers
│   ├── admin/              # Admin-specific core
│   └── user/               # User-specific core
├── data_layer/             # Data layer implementation
│   ├── admin/              # Admin data sources and repositories
│   └── user/               # User data sources and repositories
│       ├── services/       # Services (e.g., SharedPreferencesService)
│       └── remote_data/    # Remote data sources
├── domain_layer/           # Domain layer with business logic
│   ├── admin/              # Admin use cases and entities
│   └── user/               # User use cases and entities
└── presentation_layer/      # UI layer
    ├── admin_version/      # Admin UI
    └── user_version/       # User UI
        ├── pages/          # User pages
        ├── widgets/        # Reusable widgets
        └── state_management/ # Cubits and state
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / Xcode / VS Code
- Firebase account (for FCM)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd buy_verse_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up environment variables:
```bash
# Create .env file in the project root
cp .env.example .env
# Add your API credentials to .env
BASE_URL=https://your-api-url.com/api
API_KEY=your-api-key
```

4. Run the app:
```bash
flutter run
```

### Environment Variables

Create a `.env` file in the project root with the following variables:

```
BASE_URL=https://your-api-url.com/api
API_KEY=your-api-key
```

**Note**: The `.env` file is included in `.gitignore` to prevent committing sensitive data.

## Architecture

The project follows Clean Architecture principles with clear separation of concerns:

- **Presentation Layer**: Handles UI and user interactions using BLoC/Cubit for state management
- **Domain Layer**: Contains business logic, use cases, and entities
- **Data Layer**: Manages data sources (remote and local) and repositories

### Key Design Patterns

- **Repository Pattern**: Abstracts data sources from the domain layer
- **Service Layer**: Centralized services like SharedPreferencesService for local storage
- **Dependency Injection**: Using GetIt for service injection
- **State Management**: BLoC/Cubit for predictable state management

## Security Best Practices

- API keys and sensitive data are stored in `.env` file (not committed to Git)
- SharedPreferences operations are centralized in SharedPreferencesService
- Null safety is enforced throughout the codebase
- Authentication tokens are stored securely

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Support

For support, please contact the development team or open an issue in the repository.
