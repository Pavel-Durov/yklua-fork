#include <pthread.h>
#include <stdio.h>

void *thread_function(void *arg)
{
    printf("\nthread_function is running.\n");
    return NULL; // Add a return statement to match the void* return type.
}

int do_threads()
{
    pthread_t thread;
    pthread_create(&thread, NULL, thread_function, NULL);
    pthread_join(thread, NULL);
    printf("\nthread joined.\n");
    return 0;
}