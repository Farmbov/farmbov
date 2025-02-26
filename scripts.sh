# Generate Native Splash
dart run flutter_native_splash:create --flavors dev,uat,prod

# Generate Flavors
dart run flutter_flavorizr

# Generate Launcher Icon
dart run flutter_launcher_icons

# Run Build Runner Watch
pub run build_runner watch --delete-conflicting-outputs