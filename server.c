#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <pthread.h>

#define PORT 8080
#define MAX_CLIENTS 100
#define BUFFER_SIZE 65536

typedef struct {
    int sockfd;
    struct sockaddr_in addr;
    char username[50];
} client_t;

client_t clients[MAX_CLIENTS];
pthread_mutex_t clients_mutex = PTHREAD_MUTEX_INITIALIZER;

// 🔁 Broadcast to all except sender
void broadcast_message(char *message, int sender_sockfd) {
    pthread_mutex_lock(&clients_mutex);
    for (int i = 0; i < MAX_CLIENTS; ++i) {
        if (clients[i].sockfd != 0 && clients[i].sockfd != sender_sockfd) {
            send(clients[i].sockfd, message, strlen(message), 0);
        }
    }
    pthread_mutex_unlock(&clients_mutex);
}

// 🧵 Handle each client
void *handle_client(void *arg) {
    int client_sockfd = *((int *)arg);
    free(arg);

    char buffer[BUFFER_SIZE];
    char username[50];
    int bytes_read;

    // Step 1: Receive username
    if ((bytes_read = recv(client_sockfd, username, sizeof(username), 0)) <= 0) {
        close(client_sockfd);
        return NULL;
    }
    username[bytes_read] = '\0';

    printf("👤 New user joined: %s\n", username);

    // Step 2: Add client
    pthread_mutex_lock(&clients_mutex);
    for (int i = 0; i < MAX_CLIENTS; ++i) {
        if (clients[i].sockfd == 0) {
            clients[i].sockfd = client_sockfd;
            strcpy(clients[i].username, username);
            break;
        }
    }
    pthread_mutex_unlock(&clients_mutex);

    // Step 3: Read and broadcast
    while ((bytes_read = recv(client_sockfd, buffer, sizeof(buffer), 0)) > 0) {
        buffer[bytes_read] = '\0';

        if (strncmp(buffer, "IMG:", 4) == 0) {
            // 📸 Image data — already formatted
            printf("📨 [%s] Sent an image\n", username);
            broadcast_message(buffer, client_sockfd);
        } else {
            // 📝 Regular text
            char formatted[BUFFER_SIZE + 100];
            snprintf(formatted, sizeof(formatted), "%s", buffer);
            printf("💬 %s\n", formatted);
            broadcast_message(formatted, client_sockfd);
        }
    }

    // Step 4: Disconnect clean-up
    printf("🔌 Disconnected: %s\n", username);
    pthread_mutex_lock(&clients_mutex);
    for (int i = 0; i < MAX_CLIENTS; ++i) {
        if (clients[i].sockfd == client_sockfd) {
            clients[i].sockfd = 0;
            break;
        }
    }
    pthread_mutex_unlock(&clients_mutex);

    close(client_sockfd);
    return NULL;
}

// 🚀 Main server logic
int main() {
    int server_sockfd, *new_sock;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len = sizeof(client_addr);

    server_sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_sockfd == -1) {
        perror("Socket failed");
        exit(EXIT_FAILURE);
    }

    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PORT);
    server_addr.sin_addr.s_addr = INADDR_ANY;

    if (bind(server_sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Bind failed");
        exit(EXIT_FAILURE);
    }

    if (listen(server_sockfd, MAX_CLIENTS) < 0) {
        perror("Listen failed");
        exit(EXIT_FAILURE);
    }

    printf("📡 GhostTalk Server running on port %d...\n", PORT);

    while (1) {
        int client_sock = accept(server_sockfd, (struct sockaddr *)&client_addr, &client_len);
        if (client_sock < 0) {
            perror("Accept failed");
            continue;
        }

        new_sock = malloc(sizeof(int));
        *new_sock = client_sock;
        pthread_t tid;
        pthread_create(&tid, NULL, handle_client, (void *)new_sock);
        pthread_detach(tid);
    }

    close(server_sockfd);
    return 0;
}
