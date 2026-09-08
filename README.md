# BuyVerse-app

A full e-commerce Flutter application featuring a **Client App** and an **Admin App**, built with Clean Architecture, proper State Management, REST API integration, and Google Maps.

> Build it as a real product, not as a collection of screens.

---

## 📖 Project Overview

BuyVerse is a training project (Easy Learn Academy) aimed at applying advanced Flutter concepts in a practical way: browsing products and categories, placing orders, picking a delivery address on a map, and tracking order status — plus a full admin interface for managing products, categories, and orders.

The project consists of two main parts:

| Part | Description |
|---|---|
| **Client App** | Login/register, browse the store, cart, checkout, pick address on map, track orders, profile |
| **Admin App** | Login with OTP verification, manage categories & products, view and manage orders |

---

## ✨ Key Features

### Client App
- User login and account registration
- Home screen and store content
- Browse categories
- Browse products within categories
- Product details page
- Add/remove products from cart and control quantities
- Checkout and send order data to the backend
- Pick a delivery address via Google Maps (latitude/longitude)
- View and track order status
- View and edit profile data

### Admin App
- Create an admin account
- Login followed by OTP verification via email (valid for 10 minutes, with resend support)
- Store the authentication token after successful verification
- Admin home screen
- View and edit admin profile
- Manage categories (view / add / edit / delete)
- Manage products (view / add / edit / delete, linked to a category)
- View orders list and order details (customer info, address, payment method, status)

---

## 🏗️ Architecture

The project follows **Clean Architecture** with a **Feature-First** structure — each feature (Auth, Products, Orders, etc.) has its own layers, sharing a common Core layer across the app.

| Layer | Responsibility | Examples |
|---|---|---|
| **Presentation** | Handles UI and state only | Pages, Widgets, Cubit/Bloc |
| **Domain** | Business rules, independent of Flutter and API details | Entities, Repository Interfaces, Use Cases |
| **Data** | Handles data sources and JSON parsing | Models, Dio Services, Data Sources, Repository Impl |
| **Core** | Shared across all features | Network, Errors, DI, Theme, Routes, Constants |

### Project Structure

```
lib/
  core/
    network/
    errors/
    di/
    routing/
    theme/
    utils/
    widgets/
  features/
    auth/
      data/
      domain/
      presentation/
    products/
      data/
      domain/
      presentation/
    categories/
    cart/
    checkout/
    orders/
    profile/
    maps/
  main.dart
```

---

## 🛠️ Tech Stack

- **Flutter / Dart**
- **State Management:** Bloc / Cubit
- **Networking:** Dio + Interceptors for automatic token injection
- **Dependency Injection:** get_it
- **Routing:** go_router
- **Maps:** Google Maps
- **Local/Secure Storage:** flutter_secure_storage (for the auth token)
- **Testing:** Unit tests + Bloc/Cubit tests

---

## 🔐 State Handling

Every API-dependent feature accounts for the following states:

- Initial
- Loading
- Success
- Empty (no data available)
- Error (with retry support)
- Pagination / Load More (when the API supports it)
- Refresh

---

## 🗺️ Maps & Location

- Requests location permission correctly, handling the denied case
- Lets the user pin a delivery address on the map
- Sends latitude/longitude to the backend as part of the order data
- Shows the saved location again in order details or the address screen

---

## 🚀 Getting Started

### Requirements
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- A Google Maps API key

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/Abdallah744/BuyVerse-app.git
cd easy-shop

# 2. Install dependencies
flutter pub get

# 3. Add your configuration (Base URL, Maps API key) in the env/config file

# 4. Run the app
flutter run
```

> ⚠️ No API keys or secrets are committed to the repository — they are stored in an `.env` file that is excluded via `.gitignore`.

---

## 🧪 Testing

- Unit tests for important use cases and repository logic
- Bloc/Cubit tests for core states
- Validation and UI-independent logic tests

```bash
flutter test
```

---

## 📌 Notes

- Any incomplete feature or problematic endpoint will be documented here rather than hidden.
- The project follows clean code principles: clear naming, separation of business logic from UI, avoiding unguarded `!` usage, and avoiding code duplication.

---

## 📄 License

This is a training project built as part of the Easy Learn Academy program.
