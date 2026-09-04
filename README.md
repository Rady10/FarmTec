# FarmTec

### Precision Intelligence for the Modern Farm

**FarmTec** is an AI-powered, cross-platform agricultural application built with **Flutter** to help farmers and agricultural professionals manage their farms, monitor crop health, analyze soil conditions, track market prices, and make smarter farming decisions.

The application combines **AI, computer vision, real-time weather data, satellite mapping, and agricultural knowledge** into a single, accessible platform with full **English and Arabic** support.

---

## ✨ Features

### 🌾 Farm Management

* Create and manage multiple farms
* Select an active farm as the context for agricultural operations
* Interactive satellite maps
* GPS-based farm location selection
* Farm dashboard with important metrics and alerts
* Crop health visualization using vegetation/NDVI data

### 📊 Agricultural Tools

* **Soil Analysis** — Monitor soil health, moisture, and nutrient information.
* **Profit Calculator** — Estimate expected yields and potential profits using market prices and input costs.
* **Market Monitoring** — Track agricultural commodity prices, trends, and forecasts.
* **Task Management** — Schedule and manage irrigation, fertilization, and spraying tasks.
* **Weather Monitoring** — Access live weather information based on the farm location.

### 🤖 AI-Powered Features

#### 🦠 Plant Disease Diagnostics

An AI-powered agricultural assistant that allows users to upload plant images and receive disease-related analysis and agricultural recommendations.

The system uses:

* Fine-tuned **Qwen3-VL-2B**
* Vision-language processing
* **RAG (Retrieval-Augmented Generation)**
* AgroLLM agricultural knowledge base
* Hugging Face Spaces for model deployment

#### 💊 AI Medicine Assistant

An AI assistant capable of analyzing uploaded medicine images and generating structured contextual reports.

Powered by:

* **Groq Vision**
* Image analysis
* Arabic responses
* Follow-up conversations

#### 🧠 FarmBrain AI

A ChatGPT-inspired agricultural assistant designed for general farming questions.

Features include:

* Natural-language conversations
* Conversation history
* Animated typing indicators
* Agricultural-focused responses

---

## 🌍 Localization & Accessibility

FarmTec is designed to be accessible to both English- and Arabic-speaking users.

* 🇬🇧 English support
* 🇪🇬 Arabic support
* ↔️ Full RTL layout support
* Farmer-friendly Arabic terminology
* Technical term tooltips
* Dynamic language switching

---

## 🎨 User Experience

FarmTec focuses on providing a modern and accessible mobile experience.

* Animated splash screen
* Guided onboarding
* Material Design 3
* Dark mode
* Persistent user preferences
* Micro-animations
* Illustrated empty states
* Responsive UI
* Consistent design system

---

## 🗺️ Maps & Crop Monitoring

FarmTec integrates interactive satellite maps to help users visualize and manage their farms.

The application uses:

* `flutter_map`
* `latlong2`
* Esri World Imagery
* GPS coordinates
* Vegetation/NDVI overlays

This allows farmers to better understand their farm location and monitor vegetation conditions.

---

## 🏗️ Application Architecture

```text
                    ┌─────────────────────┐
                    │      FarmTec        │
                    │   Flutter Client    │
                    └──────────┬──────────┘
                               │
          ┌────────────────────┼────────────────────┐
          │                    │                    │
          ▼                    ▼                    ▼
   ┌─────────────┐      ┌─────────────┐      ┌─────────────┐
   │ Weather API │      │ Map Services │      │ Market Data │
   │ Open-Meteo  │      │ Esri / Maps  │      │   Services  │
   └─────────────┘      └─────────────┘      └─────────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    AI Services      │
                    ├─────────────────────┤
                    │ Qwen3-VL-2B         │
                    │ AgroLLM + RAG       │
                    │ Groq Vision        │
                    │ Hugging Face       │
                    └─────────────────────┘
```

---

## 🛠️ Tech Stack

| Category                | Technologies                |
| ----------------------- | --------------------------- |
| **Framework**           | Flutter                     |
| **Language**            | Dart                        |
| **UI**                  | Material Design 3           |
| **Charts**              | fl_chart                    |
| **Localization**        | Flutter Localizations, Intl |
| **Local Storage**       | SharedPreferences           |
| **Maps**                | flutter_map, latlong2       |
| **Satellite Imagery**   | Esri World Imagery          |
| **Weather**             | Open-Meteo API              |
| **AI Vision**           | Qwen3-VL-2B                 |
| **AI Platform**         | Hugging Face Spaces         |
| **Vision AI**           | Groq Vision                 |
| **Knowledge Retrieval** | RAG + AgroLLM               |

---

## 📁 Project Structure

```text
FarmTec/
│
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
│
├── assets/
│   └── images/
│
├── lib/
│   ├── ...
│   └── Application source code
│
├── test/
│
├── agromonitoring.env.example
├── mapbox.env.example
├── data.json
├── pubspec.yaml
├── prd.md
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have Flutter installed and configured on your machine.

Check your Flutter installation:

```bash
flutter doctor
```

### 1. Clone the Repository

```bash
git clone https://github.com/Rady10/FarmTec.git

cd FarmTec
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment Variables

The application uses environment variables for external services and API configuration.

Create the required environment files based on the provided examples:

```text
agromonitoring.env.example
mapbox.env.example
```

Add your required API keys and configuration values.

> **Important:** Never commit private API keys or secrets to the repository.

### 4. Run the Application

Connect a physical device or start an emulator, then run:

```bash
flutter run
```

---

## 🔑 External Services

FarmTec integrates several external technologies and services:

* **Open-Meteo** — Weather data
* **Hugging Face Spaces** — AI model deployment
* **Groq Vision** — Medicine image analysis
* **Esri World Imagery** — Satellite imagery
* **AgroLLM** — Agricultural knowledge for the RAG pipeline

---

## 🎯 Project Goals

FarmTec aims to make modern agricultural technology more accessible by bringing multiple farming tools into one application.

The project focuses on:

* 🌱 Improving crop monitoring
* 🦠 Helping identify plant diseases
* 💧 Supporting better farm management
* 🌦️ Providing useful weather information
* 💰 Helping farmers estimate profitability
* 📈 Making agricultural market information easier to understand
* 🤖 Using AI to simplify agricultural decision-making
* 🌍 Making agricultural technology accessible in both English and Arabic

---

## 🔮 Future Improvements

Potential future improvements include:

* Advanced crop yield prediction
* More crop disease models
* Automated irrigation recommendations
* More detailed satellite analytics
* Historical farm performance analytics
* Personalized AI farming recommendations
* Expanded agricultural datasets
* Push notifications for weather and farm tasks
* More regional market data

---

## 📱 Screenshots

Add application screenshots here:

```markdown
![FarmTec Dashboard](assets/screenshots/dashboard.png)

![Farm Management](assets/screenshots/farm.png)

![AI Assistant](assets/screenshots/ai-assistant.png)

![Disease Detection](assets/screenshots/disease-detection.png)
```

---

## 💡 What This Project Demonstrates

FarmTec demonstrates practical experience with:

* Cross-platform Flutter development
* AI-powered mobile applications
* Computer vision
* Vision-language models
* Retrieval-Augmented Generation (RAG)
* REST API integration
* External API integration
* Satellite mapping
* Data visualization
* Localization and RTL interfaces
* Modern mobile UI/UX
* Environment-based configuration
* Agricultural technology solutions

---

## 🔗 Repository

**FarmTec:**
https://github.com/Rady10/FarmTec

---

## 📄 License

This project is provided for educational and development purposes.
