#include "due_sam3x.init.h"
#include "Arduino.h"
#include <FreeRTOS_ARM.h>

#define LOG(x) Serial.println((x))

int main() {
    init_controller();
    init();
    vTaskStartScheduler();
err:
    LOG("System failed.");
    while (1);
}
