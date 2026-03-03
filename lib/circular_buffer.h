#ifndef CIRCULAR_BUFFER_H
#define CIRCULAR_BUFFER_H

#include <stdint.h>
#include <stdbool.h>

// Custom Bare-Metal Assert
// If expr is false, trap the CPU in an infinite loop
#define assert(expr) do { if (!(expr)) { while(1); } } while (0)

#define CIRC_BUF_MAX_LEN 1024

typedef struct circular_buf_s
{
    uint8_t array[CIRC_BUF_MAX_LEN];
    uint16_t head;
    uint16_t tail;
    uint16_t desired_len;
} circular_buf_t;

typedef enum
{
    CIRC_BUF_SUCCESS = 0,
    CIRC_BUF_ERR_TOO_LARGE,
    CIRC_BUF_ERR_ZERO_LEN,
    CIRC_BUF_ERR_NOT_PWR2,
    CIRC_BUF_ERR_BUF_FULL,
    CIRC_BUF_ERR_BUF_EMPTY
} circ_buf_status_t;

// Function Prototypes
circ_buf_status_t circular_buf_init(circular_buf_t *cb, uint16_t desired_len);
bool circular_buf_empty(circular_buf_t *cb);
bool circular_buf_full(circular_buf_t *cb);
circ_buf_status_t circular_buf_enqueue(circular_buf_t *cb, uint8_t write_data);
circ_buf_status_t circular_buf_dequeue(circular_buf_t *cb, uint8_t *read_data);

#endif // CIRCULAR_BUFFER_H
