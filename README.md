# 🍳 Cook Diary - Recipe Discovery App

A beautiful Flutter mobile application for discovering, exploring, and managing recipes from cuisines around the world. Built with **Flutter**, **Firebase**, and **TheMealDB API**.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Realtime-orange?logo=firebase)


## 🚀 Quick Start

### Prerequisites
* Flutter 3.x installed ([Install Flutter](https://docs.flutter.dev/get-started/install))
* Android/iOS development environment configured
* Firebase project created ([Firebase Console](https://console.firebase.google.com/))

### Installation
1. **Clone the repository**
   ```bash
   git clone https://github.com/shubhamnevgi/Cook-Diary-Recipe-Discovery-Application.git
   cd cook-diary

   ```
   
2. **Install dependencies**
   ```bash
   flutter pub get
   
   ```

3. **Configure Firebase**
* Run `flutterfire configure` to generate `firebase_options.dart`.
* **For Android:** Download `google-services.json` from Firebase Console and place it in `android/app/`.
* **For iOS:** Download `GoogleService-Info.plist` and place it in `ios/Runner/`.


4. **Run the app**
```bash
flutter run

```

## 🔑 API Integration

### TheMealDB API Endpoints

* **Search:** `https://www.themealdb.com/api/json/v1/1/search.php?s={query}`
* **Categories:** `https://www.themealdb.com/api/json/v1/1/categories.php`
* **Filter by Category:** `https://www.themealdb.com/api/json/v1/1/filter.php?c={category}`
* **Filter by Area:** `https://www.themealdb.com/api/json/v1/1/filter.php?a={area}`
* **Meal Details:** `https://www.themealdb.com/api/json/v1/1/lookup.php?i={id}`

*No API key required - Free public API 🎉*

## 📸 Screenshots

### Authentication Flow

* Welcome page with Get Started & Login buttons
* Registration with email validation and profile image upload

### Recipe Discovery

* Real-time search with instant results
* 2-column responsive grid layout
* Category and country filtering

### Recipe Details

* Full ingredient list with measurements
* Step-by-step instructions
* YouTube link integration
* Recipe metadata (tags, cuisine type)

## 🐛 Known Issues & Future Improvements

### Current Limitations

* ⚠️ No recipe bookmarking/favorites feature yet
* ⚠️ No image caching (uses `Image.network`)
* ⚠️ Limited search filters (no prep time, difficulty level)
* ⚠️ No shopping list functionality

### Planned Features

* 📋 Save favorite recipes to Firestore
* 🖼️ Implement image caching with `cached_network_image`
* ⏱️ Add advanced filters (prep time, difficulty, dietary restrictions)
* 🛒 Shopping list feature with ingredient collection
* 🌙 Improved dark mode styling
* 📱 Tablet-optimized layout

## 🤝 Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🙏 Acknowledgments

* Flutter Documentation
* Firebase Documentation
* TheMealDB API
* Lottie Animations

## 📞 Support

If you encounter any issues, please:

1. Check existing Issues
2. Create a new issue with detailed description
3. Include device model, Flutter version, and error logs

*Made with ❤️*
