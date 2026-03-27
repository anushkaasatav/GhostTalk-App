# Makefile for GhostTalk Server

CC=gcc
CFLAGS=-Wall -pthread
SRC=src/server.c src/chat_handler.c src/snap_handler.c src/utils.c
OUT=ghosttalk_server

all:
	$(CC) $(CFLAGS) $(SRC) -o $(OUT)

clean:
	del ghosttalk_server.exe 2>nul || true

