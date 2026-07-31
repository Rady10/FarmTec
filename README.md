# FarmTec

**Precision Intelligence for the Modern Farm**

## Overview

FarmTec is a comprehensive, AI-powered mobile application designed to assist modern farmers and agricultural enthusiasts. Built with Flutter, it provides precision intelligence through features like farm management, soil analysis, market monitoring, and state-of-the-art AI-driven agricultural and medical assistants. The app emphasizes robust multi-lingual support, primarily targeting English and Arabic speakers, and aims to make complex agricultural data understandable for both novice and expert users.

## Features

FarmTec offers a rich set of features to empower farmers and agricultural professionals:

### User Experience & Accessibility

*   **Splash Screen & Onboarding**: A redesigned animated splash screen with plant growth animation and a guided onboarding flow for new users.
*   **Multilingual Support**: Seamless, dynamic localization switching between English and Arabic, including farmer-friendly Arabic translations, terminology tooltips, and full Right-to-Left (RTL) layout support.
*   **Dark Mode**: Full dark theme support with a forest-inspired color palette, with user preferences persisted across sessions.
*   **Intuitive Design**: Features micro-animations, consistent visual elements, help tooltips for technical terms, and illustrated empty states for a premium and accessible user experience.

### Authentication & Farm Management

*   **Secure Authentication**: Responsive login and signup screens with email/password and social login (Google, Apple). Signup includes fields for Full Name, Email, Password, Phone Number, optional Farm Name, Location/Region, and User Role (Farmer/Expert/Student).
*   **Farm Selection**: A post-login screen to select existing farms or add a new one. The selected farm becomes the active context for the dashboard and all features.
*   **Interactive Map**: Satellite map preview in the "Add Farm" sheet with tap-to-set-location and live GPS coordinate filling.

### Core Agricultural Tools

*   **Dashboard**: A unified dashboard providing an at-a-glance overview of farm metrics, activities, and alerts. Includes live weather data from Open-Meteo API and smart nudges for pending actions.
*   **My Farm**: Detailed farm management connected to a centralized service, featuring an interactive satellite map view with an advanced NDVI / Vegetation Index Layer overlay to visualize crop health.
*   **Task Automation System**: Create and manage tasks (Irrigation, Fertilization, Spraying) with scheduling, worker assignment, and completion tracking.
*   **Profit Calculator**: A financial tool to estimate expected yields and calculate potential profit based on market prices and input costs.
*   **Soil Analysis**: Tools and data points for tracking soil health, moisture levels, and nutrient profiles.
*   **Market Monitoring**: Real-time market monitoring, commodity prices, and agricultural trends with expandable forecast details and crop-specific visual icons.

### AI-Powered Assistants

*   **AI Agriculture Assistant (Plant Disease Diagnostics)**: Powered by a fine-tuned Qwen3-VL-2B vision-language model (deployed on Hugging Face Spaces) with a RAG pipeline utilizing the AgroLLM knowledge base. Allows image uploads for disease identification and natural language questions for agricultural advice.
*   **AI Medicine Chat**: An interactive, AI-powered medical assistant utilizing the Groq Vision model. Analyzes uploaded images of agricultural or standard medicines to provide contextual, structured medical reports in Arabic, supporting follow-up text conversations.
*   **FarmBrain AI Chat**: A ChatGPT-inspired chat interface for general agricultural queries, featuring a clean UI, conversation history, and animated typing indicators.

## Technical Stack

FarmTec is built using modern and robust technologies:

*   **Frontend / Mobile Client**: Flutter (Dart ^3.7.0)
*   **UI Components & Theming**: Material Design 3, `cupertino_icons`, `google_fonts`, `svg_flutter`.
*   **Data Visualization**: `fl_chart`.
*   **Local Storage**: `shared_preferences`.
*   **Localization**: `flutter_localizations`, `intl`.
*   **AI & Machine Learning (Backend Services)**:
    *   Fine-tuned Qwen3-VL-2B (Vision-Language processing for plant diseases).
    *   Hugging Face Spaces (Model hosting).
    *   Groq Vision (Medicine analysis).
    *   RAG Architecture with AgroLLM.
*   **Weather API**: Open-Meteo (`api.open-meteo.com`).
*   **Mapping**: `flutter_map` with `latlong2` for satellite map views, utilizing Esri World Imagery tile provider.

## Installation

To get a local copy up and running, follow these simple steps.

### Prerequisites

Ensure you have Flutter installed. For installation instructions, refer to the [official Flutter documentation](https://docs.flutter.dev/get-started/install).

### Clone the repository

```bash
git clone https://github.com/Rady10/FarmTec.git
cd FarmTec
```

### Install Dependencies

```bash
flutter pub get
```

### Environment Variables

This project uses environment variables for API keys and other configurations. Create `.env` files (e.g., `agromonitoring.env`, `mapbox.env`) based on the provided `.env.example` files and populate them with your respective keys.

## Usage

To run the application on a connected device or emulator:

```bash
flutter run
```

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information. (Note: A `LICENSE` file was not found in the repository, assuming MIT for placeholder. Please create one if different.)

## Contact

Project Link: [https://github.com/Rady10/FarmTec](https://github.com/Rady10/FarmTec)

## Acknowledgements

*   [Flutter](https://flutter.dev/)
*   [Open-Meteo](https://open-meteo.com/)
*   [Hugging Face Spaces](https://huggingface.co/spaces)
*   [Groq](https://groq.com/)
*   [Esri](https://www.esri.com/)
