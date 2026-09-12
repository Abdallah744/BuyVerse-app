# Implementation Plan - Project Refactoring & Best Practices

Refactoring the `buy_verse_app` to align with Clean Architecture principles, remove API calls from UI, and eliminate hardcoded values as per the evaluation recommendations.

## Proposed Changes

### 1. Architecture Refactoring (Clean Architecture)
Move all Repository implementations from the `Domain` layer to the `Data` layer to strictly separate concerns.

#### [NEW] `lib/data_layer/user/repositories/`
Create a structured directory for user repositories.

#### [MOVE & MODIFY] `lib/domain_layer/user/repositories/*_impl.dart` -> `lib/data_layer/user/repositories/`
- Move `lib/domain_layer/user/repositories/user_repo_impelement.dart` to `lib/data_layer/user/repositories/auth/auth_repository_impl.dart`.
- Move `lib/domain_layer/user/repositories/orders/*_impl.dart` to `lib/data_layer/user/repositories/orders/`.
- Move `lib/domain_layer/user/repositories/payment/*_impl.dart` to `lib/data_layer/user/repositories/payment/`.
- Move `lib/domain_layer/user/repositories/products/*_impl.dart` to `lib/data_layer/user/repositories/products/`.
- Update imports in all Bloc/Cubit files and `main.dart`.

### 2. UI Refactoring (Remove API calls from UI)
Encapsulate profile fetching logic within a dedicated Cubit.

#### [NEW] `lib/presentation_layer/user_version/state_management/profile/`
- Create `profile_cubit.dart` and `profile_state.dart`.

#### [NEW] `lib/domain_layer/user/repo/profile_repository.dart`
- Define the `ProfileRepository` interface.

#### [NEW] `lib/data_layer/user/repositories/profile_repository_impl.dart`
- Implement `ProfileRepository` using `ProfileRemoteDataSource`.

#### [MODIFY] [home_page.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/presentation_layer/user_version/pages/home_page.dart)
- Replace direct `ProfileRemoteDataSource` call in `_Header` with `ProfileCubit`.

### 3. Cleanup (Hardcoding & Best Practices)
Eliminate hardcoded values and improve code quality.

#### [MODIFY] [profile_bloc.dart](file:///E:/Cross-Platform/Flutter%20Section/buy_verse_app/lib/presentation_layer/admin_version/state_management/profile/profile_bloc.dart)
- Remove hardcoded coordinates (`lat = '30.0'`, `lng = '31.0'`) and handle missing location gracefully.

#### [MODIFY] `lib/core_layer/user/core/network/api_config.dart`
- Ensure all base URLs and API keys are centralized here (if not already).

## Verification Plan

### Automated Tests
- Run existing unit tests to ensure no regressions: `flutter test`.
- Add new tests for `ProfileCubit`.

### Manual Verification
- Verify User login and Home page profile display.
- Verify Admin profile update doesn't default to hardcoded coordinates.
