# Peat Dashboard

## Description

Peat Dashboard is a Flutter-based application designed to display data fetched from the Peat API. It uses environment variables to configure the API connection and authentication via token.

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- A device or emulator set up for Flutter (Chrome is recommended)

---

## Installation

1. **Clone the repository:**

```bash
git clone https://github.com/viniciusmecosta/PeatDashboard.git
cd PeatDashboard
```

2. **Create a `.env` file** based on the example located in `assets/example.env`. Example content:

```
BASE_URL=http://127.0.0.1:8002
API_TOKEN=example
```

> This file is required to connect the application to the API.

3. **Install dependencies:**

```bash
flutter pub get
```

4. **Run the application:**

```bash
flutter run
```

When prompted to select a device, choose **Chrome** for best compatibility.

---

## API

This application consumes data from the [Peat Data API](https://github.com/viniciusmecosta/PeatData.git).

---
