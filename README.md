# GhostTalk – Privacy-First Chat & Snap Application

## Overview

GhostTalk is a privacy-focused chat and snap application with a C backend and a Flutter web frontend. The project supports real-time communication, temporary image sharing, wall posting, and browser-based interaction.

The backend is implemented using C, TCP sockets, pthreads, and file handling. The frontend is built with Flutter Web and provides the user interface for login, chat, snaps, and wall posts.

---

## Features

* Real-time chat using TCP sockets
* Temporary image sharing with auto-deletion
* Multi-client handling using pthreads
* Wall post functionality
* Browser-based frontend using Flutter Web
* Privacy-focused design with temporary storage

---

## Tech Stack

* Backend: C
* Frontend: Dart / Flutter Web
* Networking: TCP sockets
* Concurrency: POSIX threads (pthreads)
* File Handling: Linux file system / WSL

---

## Project Structure

* `server.c`
* `chat_handler.c`
* `snap_handler.c`
* `utils.c`
* `Makefile`
* `run.sh`
* `lib/`
* `web/`
* `pubspec.yaml`
* `pubspec.lock`
* `Ghost talk report.pdf`
* `README.md`

---

## How to Run

### 1. Start the backend server in WSL

Open WSL and run:

```bash
cd /mnt/c/Users/anush/OneDrive/Desktop/ghosttalk_web/backend
./server
```

If needed, compile first:

```bash
cd /mnt/c/Users/anush/OneDrive/Desktop/ghosttalk_web/backend
make
./server
```

### 2. Start the frontend in PowerShell

Open a new PowerShell window and run:

```powershell
cd "C:\Users\anush\OneDrive\Desktop\ghosttalk_web\frontend\ghosttalk_app"
flutter pub get
flutter run -d chrome
```

### 3. Use the application

* Keep the backend server running in WSL
* Launch the Flutter web app from PowerShell
* Open the app in Chrome
* Log in and test chat, snap, and wall post features

---

## Notes

* Backend runs in WSL
* Frontend runs in PowerShell / Chrome
* The project was tested locally with the backend server running on port 8080

---

## Project Report

Detailed explanation and screenshots are available in:

`Ghost talk report.pdf`

---

## Author

Anushka Vijay Satav
MS Computer Science – Binghamton University

---

## Future Improvements

* Better repository structure for backend and frontend separation
* End-to-end encryption
* Database integration
* Improved scalability
