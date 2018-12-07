#include "due_sam3x.init.h"
#include "Arduino.h"
#include <FreeRTOS_ARM.h>
#include "HardwareSerial.h"

#define LOG(x) Serial.println((x))

void led_task(void *);
int init_tasks();

void led_task(void *arg) {
    while (1) {
        LOG("Hello world.");
        Sleep(1000);
        if(PIOB->PIO_ODSR & PIO_PB27) {
            /* Set clear register */
            PIOB->PIO_CODR = PIO_PB27;
        } else {
            /* Set set register */
            PIOB->PIO_SODR = PIO_PB27;
        }
        digitalWrite(LED_BUILTIN, LOW);
    }
}

typedef void (*Task_t)(void *);

typedef struct TaskInfo {
    Task_t task;
    int priority;
    TaskHandle_t handle;
} TaskInfo;


TaskInfo all_tasks[] = {
    {led_task, 1},
};

int init_tasks() {
    unsigned int i;
    for (i = 0; i < sizeof(all_tasks); i++) {
        BaseType_t rtn;
        rtn = xTaskCreate(all_tasks[i].task, NULL, configMINIMAL_STACK_SIZE, NULL,
                          all_tasks[i].priority, &all_tasks[i].handle);
        if (rtn != pdPASS) {
            LOG("Failed to create task");
            return -1;
        }
    }
    return 0;
}

void setup() {
    Serial.begin(115200);
    LOG("Initializing...");
    if (init_tasks())
        goto err;
    vTaskStartScheduler();
err:
    LOG("Initialization failed.");
    while (1);
}

void loop() {
    // nothing
}