# GhostTalk – Privacy-First Snap & Chat Application

## Overview

GhostTalk is a terminal-based social media application focused on privacy-first communication. It allows users to chat in real time, send temporary image snaps, and post messages.

This project demonstrates system-level programming concepts using C, including socket programming, multithreading, and file handling.

---

## Features

* Real-time chat using TCP sockets
* Temporary image sharing with auto-deletion
* Multi-client handling using pthreads
* Wall post system
* Privacy-focused design with temporary storage

---

## System Architecture

Client → TCP Socket → Server (C + Threads) → File System

* Clients communicate with the server using TCP sockets
* The server handles multiple clients using threads
* Snap data is stored temporarily and deleted automatically

---

## Tech Stack

* Language: C
* Networking: TCP sockets
* Concurrency: POSIX threads (pthreads)
* File Handling: Linux file system

---

## Project Structure

* server.c
* chat_handler.c
* snap_handler.c
* utils.c
* Makefile
* run.sh
* GhostTalk_Report.pdf
* README.md

---

## How to Run

1. Compile the project:
   make

2. Run the server:
   ./server

3. Run the client (if implemented separately):
   ./client

---

## Challenges Faced

* Handling multiple clients concurrently
* Managing concurrent file access
* Implementing safe auto-deletion
* Synchronizing communication between clients

---

## Project Report

Detailed explanation is available in:
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
