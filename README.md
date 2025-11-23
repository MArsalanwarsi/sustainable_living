# 🌿 **Sustainable Living – Carbon Tracker App**

A Flutter-based mobile application designed to help users track, measure, and reduce their carbon footprint through daily insights, smart analytics, and eco-friendly recommendations.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/Status-Active-brightgreen" />
  <img src="https://img.shields.io/badge/Theme-Green-green" />
  <img src="https://img.shields.io/badge/License-MIT-success" />
</p>

---

## 🌱 **Overview**

**Sustainable Living** is a modern eco-focused carbon tracker app. It helps users understand their environmental impact, break down daily CO₂ emissions, and adopt greener habits using personalized suggestions.

The UI uses a soothing **green theme** to visually support the sustainability mission.

---

## 📸 **Screenshots**

*(Add your images later)*

```
assets/screenshots/
  ├── home.png
  ├── tracker.png
  └── insights.png
```

---

## 🧩 **Features**

* 🌍 Track daily CO₂ emissions
* 🚌 Travel, energy & lifestyle carbon logs
* 📊 Beautiful graphs and insights
* 🔔 Eco-friendly daily tips
* 📱 Clean, modern Flutter UI
* 🛠 Local storage and/or Firebase integration
* 🎨 Green theme UI

---

## 🛠 **Tech Stack**

| Component        | Technology                           |
| ---------------- | ------------------------------------ |
| Framework        | Flutter                              |
| Language         | Dart                                 |
| State Management | Provider / Riverpod / Bloc           |
| Backend          | Firebase / Local DB                  |
| Charts           | fl_chart / syncfusion_flutter_charts |
| Theme            | Custom Green Theme                   |

---

# 🚀 **Setup Instructions (After Cloning the Project)**

Follow these steps to run this Flutter project on your PC.

---

## 1️⃣ **Clone the Repository**

```bash
git clone https://github.com/yourusername/sustainable_living.git
cd sustainable_living
```

---

## 2️⃣ **Install Dependencies**

Make sure Flutter SDK is installed.

Check Flutter version:

```bash
flutter --version
```

Install required packages:

```bash
flutter pub get
```

---

## 3️⃣ **Firebase Setup (If the project uses Firebase)**

### **Android Setup**

1. Go to Firebase Console
2. Create / open your Firebase project
3. Add Android app
4. Download **google-services.json**
5. Put it here:

```
android/app/google-services.json
```

### **iOS Setup**

1. Add iOS app in Firebase
2. Download **GoogleService-Info.plist**
3. Put it here:

```
ios/Runner/GoogleService-Info.plist
```

Run Firebase CLI setup (optional):

```bash
flutterfire configure
```

---

## 4️⃣ **Run the App**

Run on any connected device:

```bash
flutter run
```

Run for specific platform:

```bash
flutter run -d chrome     # Web
flutter run -d android    # Android
flutter run -d ios        # iOS
```

---

## 5️⃣ **Build Release Version**

### Android APK:

```bash
flutter build apk --release
```

### Web Build:

```bash
flutter build web
```

---

# 🤝 **Contributing**

Contributions are welcome!
Feel free to create issues and pull requests to improve the project.

---

# 📜 **License**

This project is licensed under the **MIT License**.

---
