#include "circular_buffer.h"


circ_buf_status_t circular_buf_init(circular_buf_t *cb, uint16_t desired_len)
{
    assert(cb);

    /* filter-out lengths > max len */
    if(desired_len > CIRC_BUF_MAX_LEN)
    {
//        printf("Cannot allow Buffer-Overflow!\n");
        return CIRC_BUF_ERR_TOO_LARGE;
    }

    /* filter-out length == 0 */
    if(desired_len == 0)
    {
//        printf("Cannot allow buffer length = 0\n");
        return CIRC_BUF_ERR_ZERO_LEN;
    }

    /* filter-out length != power-of-2 */
    if(((desired_len & (desired_len - 1)) != 0))
    {
//        printf("Cannot allow a buffer length that is not a power-of-2 \n");
        return CIRC_BUF_ERR_NOT_PWR2;
    }

    cb->head = 0;
    cb->tail = 0;
    cb->desired_len = desired_len;

    return CIRC_BUF_SUCCESS;
}

/* buf is empty when head == tail */
bool circular_buf_empty(circular_buf_t *cb)
{
    assert(cb);

    if(cb->head == cb->tail)
    {
        return true;
    }
    return false;
}

/* buf is full when tail == (head+1) % max_len */
bool circular_buf_full(circular_buf_t *cb)
{
    assert(cb);

    if(cb->tail == ((cb->head + 1) & (cb->desired_len - 1)))
    {
        return true;
    }
    return false;
}


circ_buf_status_t circular_buf_enqueue(circular_buf_t *cb, uint8_t write_data)
{
    assert(cb);

    if(circular_buf_full(cb))
    {
        return CIRC_BUF_ERR_BUF_FULL;
    }

    cb->array[cb->head] = write_data;

    cb->head = ((cb->head + 1) & (cb->desired_len - 1));

    return CIRC_BUF_SUCCESS;
}

circ_buf_status_t circular_buf_dequeue(circular_buf_t *cb, uint8_t *read_data)
{
    assert(cb);
    assert(read_data);

    if(circular_buf_empty(cb))
    {
        return CIRC_BUF_ERR_BUF_EMPTY;
    }

    *read_data = cb->array[cb->tail];

    cb->tail = ((cb->tail + 1) & (cb->desired_len - 1));

    return CIRC_BUF_SUCCESS;
}
