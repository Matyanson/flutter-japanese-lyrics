# Flutter Japanese Lyrics Learning App
A Flutter-based application for learning Japanese through song lyrics. Inspired by the [SvelteKit](https://svelte.dev/docs/kit/introduction) project structure.

## 🗂️ Folder Structure
    lib/
    ├── main.dart                # App entry point
    ├── components/              # Reusable UI widgets
    │   └── handwriting/         # Canvas + controller for handwriting practice
    ├── constants/               # App-wide constants (e.g., API URLs)
    ├── database/                # Hive-based local storage
    ├── models/                  # Data models and generated adapters
    ├── routes/                  # App routes grouped by feature
    │   ├── practice/            # Practice screen & logic
    │   ├── search/              # Search screen & logic
    │   ├── library/             # Library screen
    │   └── song/                # Song detail view
    └── services/                # API clients and external service wrappers

    node/
    ├── server.ts                # Local Node API scraper (j-lyric)
    └── package.json             # Dependencies for Node backend

### For example:

- `lib/routes/practice/` contains:

    - `practice_screen.dart` — the main screen

    - `practice_controller.dart` — logic/state for the screen

    - `components/` — widgets related only to the practice screen

Reusable UI elements live in `lib/components/`, grouped by purpose.

## ⚙️ Prerequisites & Setup
Before running the app, make sure the following are ready:

### 1. VOICEVOX (Text-to-Speech Engine)
Download and run the VOICEVOX app from:
👉 https://voicevox.hiroshiba.jp/ <br>
Should be running on http://localhost:50021 (editable in lib/constants/url.dart)

### 2. J-Lyric Scraper API (Node)
In the node/ directory:

    cd node
    npm install
    npx ts-node server.ts
This launches a local scraping server on http://localhost:3000. The URL is also configurable in lib/constants/url.dart.

### 3. Run on Android Emulator
Make sure an emulator is up and running.

Start the Flutter App
From the project root:

    flutter pub get
    flutter run

## 📝 Features
- Search and download Japanese song lyrics

- Practice reading (meaning), handwriting (with ML Kit), and word-image association

- Text-to-speech with VOICEVOX

- Local library persistence with Hive

- Offline-friendly architecture

## 📲 Screens

| Screen              | Description                            |
|---------------------|----------------------------------------|
| Search              | Search for songs and add them to library |
| Library             | View downloaded songs                  |
| Practice            | Learn words in the selected song       |
| Handwriting Canvas  | Draw kana and get recognition feedback |

## 📦 Technologies
- **Flutter**

- **Riverpod, Hive** - state management, local persistence

- **VOICEVOX** (offline Japanese TTS)

- **Google ML Kit Handwriting Recognition**

- **Custom backend** (Node.js, optional) – for scraping lyrics from [j-lyric.net](https://j-lyric.net)

- **[Ringo tokenizer](https://pub.dev/packages/ringo)** - tokenize japanese text

- ~~**MeCab tokenizer** (via mecab.dart wrapper)~~