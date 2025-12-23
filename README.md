![Screenshot_2025-12-23-18-16-17-34_e8f1bd4c4634587c7e6d06270ae2bad2](https://github.com/user-attachments/assets/5f3c070a-fb9d-4ddd-b83b-78b75e633c46)# 🍳 Cook Diary - Recipe Discovery App

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

### 📸 Screenshots

### Authentication Flow


| Welcome Page | Registration | Login Page |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/9631e488-2001-478a-9a29-9b7eba89650c" width="250"> | <img src="https://github.com/user-attachments/assets/0f02ee87-aaa6-4718-bc72-3441099e491c" width="250"> | <img src="https://github.com/user-attachments/assets/b014afa7-912b-42dd-b0e6-2f7feec7f220" width="250"> |

### Recipe Discovery


| Home Page | Real-time search | Explore Page | Country filtering | Category filtering | Recipe page
| :---: | :---: | :---: | ---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/222633a3-e64c-4beb-a4c0-e5849b8b5d90" width="250"> | <img src="https://github.com/user-attachments/assets/ae0b5924-8b8e-4d2e-b624-fdecbbd58e02" width="250"> | <img src="https://github.com/user-attachments/assets/56a814f0-8623-40af-9a34-e7f5c4a72a49" width="250"> | <img src="https://github.com/user-attachments/assets/a0d6d36f-9dbf-4a85-b927-27d4af2358d5" width="250"> | <img src="https://github.com/user-attachments/assets/9ade8834-25a9-4b27-bb3c-fe6e1e144476" width="250"> | <img src="https://github.com/user-attachments/assets/eda56e70-a104-49cc-b515-2cd0bce0fa09" width="250"> |

### Other

| Profile page | Dark Mode |
| :---: | :---: |
| <img src="https://github.com/user-attachments/assets/63ef075c-72ac-4b2e-8163-75861161b6d0" width="250"> | <img src="https://github.com/user-attachments/assets/9b1e910b-c5e1-4ebc-ba01-719dd474afd3" width="250"> |


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
