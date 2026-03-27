# GhostTalk – Privacy-First Snap & Chat Application

## Overview

GhostTalk is a terminal-based social media application focused on privacy-first communication. It allows users to chat in real time, send temporary image snaps, and post messages to a personal wall.

This project demonstrates low-level system programming concepts using C, including socket programming, concurrency, and file handling.

---

## Features

* Real-time chat using TCP sockets
* Temporary image sharing (auto-deleted after 10 seconds)
* Multi-client handling using pthreads
* Wall post system for users
* Privacy-focused design with temporary storage

---

## System Architecture

Client → TCP Socket → Server (C + Threads) → File System

* Clients communicate with the server through TCP sockets
* The server handles multiple clients using threads
* Snap images are stored temporarily in `/data/snaps`
* Files are automatically deleted after a fixed duration

---

## Tech Stack

* Language: C
* Networking: TCP sockets
* Concurrency: POSIX threads (pthreads)
* File Handling: Linux file system

---

## Project Structure

GhostTalk-App/

* backend/

  * src/

    * server.c
    * chat_handler.c
    * snap_handler.c
    * post_handler.c
    * utils.c
  * Makefile
  * run.sh
* GhostTalk_Report.pdf
* README.md

---

## How to Run

1. Navigate to backend folder:
   cd backend

2. Compile the project:
   make

3. Run the server:
   ./server

4. Run the client (in another terminal):
   ./client

---

## Challenges Faced

* Handling multiple clients concurrently using threads
* Managing concurrent file access
* Implementing safe auto-deletion of files
* Synchronizing communication between client and server

---

## Project Report

Detailed explanation is available here:
GhostTalk_Report.pdf

---

## Author

Anushka Vijay Satav
MS Computer Science – Binghamton University

---

## Future Improvements

* Graphical user interface
* End-to-end encryption
* Database integration
* Improved scalability
