#include "user_handler.h"


void (*user_handlers[8])() = {0, 0, 0, 0, 0, 0, 0, 0};


void SetHandler(int n, void* handler) {
    user_handlers[n] = handler;
}
