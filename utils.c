// utils.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void log_event(const char *username, const char *action) {
    FILE *log = fopen("../data/log.txt", "a");
    if (!log) return;

    time_t now = time(NULL);
    char *time_str = ctime(&now);
    time_str[strcspn(time_str, "\n")] = '\0'; // Remove newline

    fprintf(log, "[%s] %s: %s\n", time_str, username, action);
    fclose(log);
}

void save_wall_post(const char *username, const char *post) {
    char filepath[128];
    snprintf(filepath, sizeof(filepath), "../data/users/%s.txt", username);

    FILE *f = fopen(filepath, "a");
    if (f) {
        fprintf(f, "%s\n", post);
        fclose(f);
    }
}

