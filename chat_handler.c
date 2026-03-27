// src/chat_handler.c

#include <stdio.h>
#include <string.h>
#include <time.h>
#include "chat_handler.h"

void log_chat_message(const char* username, const char* message) {
    FILE* fp = fopen("data/chat_log.txt", "a");
    if (fp == NULL) {
        perror("Failed to open chat_log.txt");
        return;
    }

    time_t now = time(NULL);
    char* timestamp = ctime(&now);
    timestamp[strcspn(timestamp, "\n")] = 0; // Remove newline

    fprintf(fp, "[%s] %s: %s\n", timestamp, username, message);
    fclose(fp);
}

void handle_screenshot_warning(const char* username, const char* action) {
    FILE* fp = fopen("data/security_alerts.txt", "a");
    if (fp == NULL) {
        perror("Failed to open security_alerts.txt");
        return;
    }

    time_t now = time(NULL);
    char* timestamp = ctime(&now);
    timestamp[strcspn(timestamp, "\n")] = 0;

    fprintf(fp, "[%s] ⚠️ Screenshot detected by %s during: %s\n", timestamp, username, action);
    fclose(fp);
}
