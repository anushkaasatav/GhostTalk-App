// snap_handler.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <time.h>

// Save the snap temporarily, then auto-delete after 10 sec
void *delete_snap_after_delay(void *filename_ptr) {
    char *filename = (char *)filename_ptr;
    sleep(10);
    if (remove(filename) == 0) {
        printf("🗑️ Snap deleted: %s\n", filename);
    } else {
        perror("Error deleting snap");
    }
    free(filename_ptr);
    return NULL;
}

void save_snap(const char *sender, const char *data) {
    char path[256];
    time_t now = time(NULL);
    snprintf(path, sizeof(path), "../data/snaps/%s_%ld.txt", sender, now);

    FILE *f = fopen(path, "w");
    if (f) {
        fprintf(f, "%s\n", data);
        fclose(f);
        printf("📸 Snap saved: %s\n", path);
    } else {
        perror("Failed to save snap");
        return;
    }

    // Create a thread to delete after 10 sec
    pthread_t tid;
    char *copy = strdup(path); // Allocate memory to pass to thread
    pthread_create(&tid, NULL, delete_snap_after_delay, copy);
    pthread_detach(tid);
}

