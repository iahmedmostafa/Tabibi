# tabibi

A new Flutter project.

## Recent changes (summary)

Below is a concise summary of the changes made to the project in the most recent update session.

## Added

- `lib/core/utils/constants/app_border_radius.dart` — Centralized BorderRadius constants (r8, r12, r15, r20).

## Changed

- Responsive spacing
	- `lib/core/utils/constants/app_dimensions.dart` — Converted height/width constants to ScreenUtil-scaled getters (e.g. `AppHeight.h16 => 16.h`).
	- `lib/core/style/spacing/vertical_space.dart` and `lib/core/style/spacing/horizental_space.dart` — spacing widgets now use ScreenUtil (.h/.w).

- Centralized sizes / theming
	- `lib/core/utils/constants/sizes.dart` — used as the canonical source for numeric UI sizes (font sizes, icon sizes, radii, etc.).
	- `lib/core/utils/theme/custom_themes/elevated_button_theme.dart` — uses `AppSizes` for padding/height and `AppBorderRadius` for shape.
	- `lib/core/widgets/primary_button.dart` — button text size now uses `AppSizes.fontSizeMd`.

- UI widget updates (examples)
	- `lib/features/onboarding/presentation/screens/widgets/onboarding_page.dart` — moved hard-coded font sizes to `AppSizes` constants.
	- `lib/features/authentication/presentation/widgets/social_button.dart` — replaced literal spacing with `AppWidth.w8` and font size with `AppSizes.fonAppSizesm`.
	- `lib/core/widgets/custom_input_field.dart` — replaced literal paddings with `AppPadding` / `AppWidth`, made sizes responsive; cleaned imports.
	- `lib/features/authentication/presentation/widgets/top_section.dart` — text sizing moved to `AppSizes`.
	- `lib/features/authentication/presentation/screens/fill_profile/fill_profile.dart` — replaced vertical/horizontal spacers with `AppHeight`/`AppWidth` getters.
	- `lib/features/authentication/presentation/screens/login/login.dart` and `lib/features/authentication/presentation/screens/login/widgets/bottom_login_section.dart` — spacer uses replaced with `AppHeight` getters; login layout adjusted.
	- `lib/features/authentication/presentation/screens/verify_code/widgets/pin_code.dart` — Pin field styling standardized to use `AppBorderRadius`.

- ScreenUtil initialization
	- `lib/main.dart` — added `ScreenUtilInit(...)` wrapper to ensure ScreenUtil is initialized before any `.h/.w/.sp` getters are used.

## Fixed

- Resolved runtime LateInitializationError
	- Problem: `LateInitializationError: Field '_splitScreenMode@...' has not been initialized.`
	- Fix: Ensured `ScreenUtilInit` is placed in `main.dart` so ScreenUtil's internal fields are initialized before any responsive getters are used.

- Invalid const usage
	- Several UI files used `const VerticalSpace(height: AppHeight.h32)` (and similar) after `AppHeight`/`AppWidth` were converted to non-const ScreenUtil getters. This caused "Invalid constant value" compile errors. All instances were updated to remove `const` where the height/width uses non-const getters.
	- Example files updated:
		- `lib/features/authentication/presentation/screens/create_new_password/create_new_password.dart`
		- `lib/features/authentication/presentation/screens/fill_profile/fill_profile.dart`
		- `lib/features/authentication/presentation/screens/forgot_password/forgot_password.dart`
		- `lib/features/authentication/presentation/screens/login/login.dart`
		- `lib/features/authentication/presentation/screens/login/widgets/bottom_login_section.dart`
		- `lib/core/widgets/custom_input_field.dart`

## Notes / Recommendations

- ScreenUtil design size: `main.dart` uses a default `designSize: Size(390, 844)`. If your design uses a different reference resolution, adjust it accordingly.
- There are still places with literal numeric sizes intentionally left unchanged where the number did not directly match a value in `AppSizes` (to avoid changing intended visuals). If you want a full sweep, specify whether to map all remaining font sizes, paddings or icon sizes to `AppSizes`.
- You should run the app (device/emulator) to confirm runtime behavior. The compile-time errors encountered earlier were resolved.

---

Update date: 2025-10-10
