// Written by: Øyvind Nydal Dahl
// Company: XeThru / Novelda
// July 2018

#include "platform_info.h"
#include "ervp_printf.h"
#include "ervp_multicore_synch.h"
#include "ervp_external_peri_group_memorymap_offset.h"
#include "ervp_mmio_util.h"

#include "ervp_uart_define.h"
#include "ervp_uart.h"
#include "ervp_delay.h"
#include "ervp_user_gpio.h"

#include "x4m202.h"

#define UART_ID_OF_UWB            (UART_INDEX_FOR_READYMADE)
#define UART_RATE_UWB                     (115200)



static inline void uwb_rstnn(unsigned int value)
{
  user_gpio_set_output(GPIO_INDEX_FOR_UWB_RESET, value);
}

void uwb_uart_init()
{
  uwb_rstnn(0);
  delay_ms(100);
  uwb_rstnn(1);

  uart_config(UART_ID_OF_UWB, UART_RATE_UWB);
}


void uwb_uart_write(char *ch, int size)
{
  int i;
  for(i=0; i<size; i++)
  {
    uart_putc(UART_ID_OF_UWB, ch[i]);
  }
}

char uwb_uart_read()
{
  return uart_getc(UART_ID_OF_UWB); 
}


char uwb_uart_get()
{
  return  uart_read_rx_buffer(UART_ID_OF_UWB);
}

void uwb_uart_put(char ch)
{
  uart_putc(UART_ID_OF_UWB, ch);

}


int  uwb_uart_available()
{
  return uart_check_rx_data_ready(UART_ID_OF_UWB);
}


int get_respiration_data(RespirationMessage * resp_msg) {

  //int __receive_data;

  //__receive_data = receive_data();
  //
  //printf("__receive_data = %d\n", __receive_data);


  //printf("before receive_data\n");
  if (receive_data() < 1) // fills recv_buf[] with data.
    //if (__receive_data < 1)
    return 0;

  // Respiration Sleep message format:
  //
  // <Start> + <XTS_SPR_APPDATA> + [XTS_ID_SLEEP_STATUS(i)] + [Counter(i)]
  // + [StateCode(i)] + [RespirationsPerMinute(f)] + [Distance(f)]
  // + [SignalQuality(i)] + [MovementSlow(f)] + [MovementFast(f)]
  //

  // Check that it's a sleep message (XTS_ID_SLEEP_STATUS)
  uint32_t xts_id = *((uint32_t*)&recv_buf[2]);
  if (xts_id != XTS_ID_SLEEP_STATUS) 
    return 0;

  //printf("extract\n"); 
  // Extract the respiration message data:
  resp_msg->state_code = *((uint32_t*)&recv_buf[10]);
  resp_msg->rpm = *((float*)&recv_buf[14]);
  resp_msg->distance = *((float*)&recv_buf[18]);
  resp_msg->signal_quality = *((uint32_t*)&recv_buf[22]);
  resp_msg->movement_slow = *((float*)&recv_buf[26]);
  resp_msg->movement_fast = *((float*)&recv_buf[30]);

  //printf("resp_msg\n");

  // Return OK
  return 1;
}


// Stop module from running
void stop_module() 
{
  // Empty the buffer before stopping the radar profile:
  //while (SerialRadar.available())
  //  SerialRadar.read();
  uwb_uart_read();

  // Fill send buffer
  send_buf[0] = XT_START;
  send_buf[1] = XTS_SPC_MOD_SETMODE;
  send_buf[2] = XTS_SM_STOP;

  // Send the command
  send_command(3);

  // Get ACK response from radar
  get_ack();
}


// Set sensitivity
void set_sensitivity(uint32_t sensitivity) 
{
  //Fill send buffer
  send_buf[0] = XT_START;
  send_buf[1] = XTS_SPC_APPCOMMAND;
  send_buf[2] = XTS_SPCA_SET;
  send_buf[3] = XTS_ID_SENSITIVITY & 0xff;
  send_buf[4] = (XTS_ID_SENSITIVITY >> 8) & 0xff;
  send_buf[5] = (XTS_ID_SENSITIVITY >> 16) & 0xff;  
  send_buf[6] = (XTS_ID_SENSITIVITY >> 24) & 0xff;
  send_buf[7] = sensitivity & 0xff;
  send_buf[8] = (sensitivity >> 8) & 0xff;
  send_buf[9] = (sensitivity >> 16) & 0xff;  
  send_buf[10] = (sensitivity >> 24) & 0xff;

  //Send the command
  send_command(11);

  // Get ACK response from radar
  get_ack();
}



// Set detection zone
void set_detection_zone(float zone_start, float zone_end) 
{
  //Fill send buffer
  send_buf[0] = XT_START;
  send_buf[1] = XTS_SPC_APPCOMMAND;
  send_buf[2] = XTS_SPCA_SET;
  send_buf[3] = XTS_ID_DETECTION_ZONE & 0xff;
  send_buf[4] = (XTS_ID_DETECTION_ZONE >> 8) & 0xff;
  send_buf[5] = (XTS_ID_DETECTION_ZONE >> 16) & 0xff;  
  send_buf[6] = (XTS_ID_DETECTION_ZONE >> 24) & 0xff;

  // Copy the bytes of the floats to send buffer
  memcpy(send_buf+7, &zone_start, 4);
  memcpy(send_buf+11, &zone_end, 4);

  //Send the command
  send_command(15);

  // Get ACK response from radar
  get_ack();
}



// Run profile
void run_profile() 
{
  //Fill send buffer
  send_buf[0] = XT_START;
  send_buf[1] = XTS_SPC_MOD_SETMODE;
  send_buf[2] = XTS_SM_RUN;

  //Send the command
  send_command(3);

  // Get ACK response from radar
  get_ack();
}


// Load profile
void load_profile(uint32_t profile)
{
  //Fill send buffer
  send_buf[0] = XT_START;
  send_buf[1] = XTS_SPC_MOD_LOADAPP;
  send_buf[2] = profile & 0xff;
  send_buf[3] = (profile >> 8) & 0xff;
  send_buf[4] = (profile >> 16) & 0xff;  
  send_buf[5] = (profile >> 24) & 0xff;

  //Send the command
  send_command(6);

  // Get ACK response from radar
  get_ack();
}

void configure_noisemap() 
{
  // send_buf[3] Configuration:
  //
  // Bit 0: FORCE INITIALIZE NOISEMAP ON RESET
  // Bit 1: ADAPTIVE NOISEMAP ON
  // Bit 2: USE DEFAULT NOISEMAP
  // 

  //Fill send buffer
  send_buf[0] = XT_START;
  send_buf[1] = XTS_SPC_MOD_NOISEMAP;
  send_buf[2] = XTS_SPCN_SETCONTROL;
  send_buf[3] = 0x06; // 0x06: Use default noisemap and adaptive noisemap
  send_buf[4] = 0x00;
  send_buf[5] = 0x00;
  send_buf[6] = 0x00;

  //Send the command
  send_command(7);

  // Get ACK response from radar
  get_ack();
}


void enable_output_message(uint32_t message) 
{
  //Fill send buffer
  send_buf[0] = XT_START;
  send_buf[1] = XTS_SPC_OUTPUT;
  send_buf[2] = XTS_SPCO_SETCONTROL;
  send_buf[3] = message & 0xff;
  send_buf[4] = (message >> 8) & 0xff;
  send_buf[5] = (message >> 16) & 0xff;
  send_buf[6] = (message >> 24) & 0xff;
  send_buf[7] = XTID_OUTPUT_CONTROL_ENABLE & 0xff;
  send_buf[8] = (XTID_OUTPUT_CONTROL_ENABLE >> 8) & 0xff;
  send_buf[9] = (XTID_OUTPUT_CONTROL_ENABLE >> 16) & 0xff;
  send_buf[10] = (XTID_OUTPUT_CONTROL_ENABLE >> 24) & 0xff;

  //Send the command
  send_command(11);

  // Get ACK response from radar
  get_ack();
}


void disable_output_message(uint32_t message) 
{
  //Fill send buffer
  send_buf[0] = XT_START;
  send_buf[1] = XTS_SPC_OUTPUT;
  send_buf[2] = XTS_SPCO_SETCONTROL;
  send_buf[3] = message & 0xff;
  send_buf[4] = (message >> 8) & 0xff;
  send_buf[5] = (message >> 16) & 0xff;
  send_buf[6] = (message >> 24) & 0xff;
  send_buf[7] = XTID_OUTPUT_CONTROL_DISABLE & 0xff;
  send_buf[8] = (XTID_OUTPUT_CONTROL_DISABLE >> 8) & 0xff;
  send_buf[9] = (XTID_OUTPUT_CONTROL_DISABLE >> 16) & 0xff;
  send_buf[10] = (XTID_OUTPUT_CONTROL_DISABLE >> 24) & 0xff;

  //Send the command
  send_command(11);

  // Get ACK response from radar
  get_ack();
}




// This method waits indefinitely for the XTS_SPRS_READY message from the radar
void wait_for_ready_message()
{
  printf("Waiting for XTS_SPRS_READY...\n");
  while (true) {
    if (receive_data() < 1)
      continue;

    if (recv_buf[1] != XTS_SPR_SYSTEM)
      continue;

    //uint32_t response_code = (uint32_t)recv_buf[2] | ((uint32_t)recv_buf[3] << 8) | ((uint32_t)recv_buf[4] << 16) | ((uint32_t)recv_buf[5] << 24);
    uint32_t response_code = *((uint32_t*)&recv_buf[2]);
    if (response_code == XTS_SPRS_READY) {
      printf("Received XTS_SPRS_READY!\n");
      return;
    }
    else if (response_code == XTS_SPRS_BOOTING)
      printf("Radar is booting...\n");
  }
}

// This method checks if an ACK was received from the radar
void get_ack()
{
  int len = receive_data();

  if (len == 0)
    printf("No response from radar\n");
  else if (len < 0)
    printf("Error in response from radar\n");
  else if (recv_buf[1] != XTS_SPR_ACK)  // Check response for ACK
    printf("Did not receive ACK!\n");
}


/*
 * Adds CRC, Escaping and Stop byte to the
 * send_buf and sends it over the SerialRadar.
 */
void send_command(int len) 
{ 
  unsigned char crc = 0;

  // Calculate CRC
  for (int i = 0; i < len; i++)
    crc ^= send_buf[i];

  // Add CRC to send buffer
  send_buf[len] = crc;
  len++;

  // Go through send buffer and add escape characters where needed
  for (int i = 1; i < len; i++) {
    if (send_buf[i] == XT_START || send_buf[i] == XT_STOP || send_buf[i] == XT_ESCAPE)
    {
      // Shift following bytes one place up
      for (int u=len; u > i; u--)
        send_buf[u] = send_buf[u-1];

      // Add escape byte at old byte location
      send_buf[i] = XT_ESCAPE;

      // Increase length by one
      len++;

      // Increase counter so we don't process it again
      i++;
    }
  } 

  // Send data (including CRC) and XT_STOP
  //SerialRadar.write(send_buf, len);
  //SerialRadar.write(XT_STOP);
  uwb_uart_write((char *)send_buf, len);

  //  char xt_stop_temp = XT_STOP;

  //uwb_uart_put(&xt_stop_temp, 1);
  uwb_uart_put(XT_STOP);


  // Print out sent data for debugging:
  printf("Sent: ");  
  for (int i = 0; i < len; i++) {
    printf("%x",send_buf[i]);
    printf(" ");
  }
  printf("%x\n",XT_STOP);
}

//#define XT_START 0x7d
//#define XT_STOP 0x7e
//#define XT_ESCAPE 0x7f 

/* 
 * Receive data from radar module
 *  -Data is stored in the global array recv_buf[]
 *  -On success it returns number of bytes received (without escape bytes
 *  -On error it returns -1
 */
int receive_data() {

  int recv_len = 0;  //Number of bytes received

  // Wait 500 ms if nothing is available yet
  //if (!SerialRadar.available())
  if (!uwb_uart_available())
    delay_ms(500);
  //printf("1. recv_avail\n");

  // Wait for start character
  while (uwb_uart_available())
  {
    //printf("2. recv_avail\n");
    //unsigned char c = SerialRadar.read();  // Get one byte from radar
    unsigned char c = uwb_uart_read(); 
    //printf("%x\n", c);

    // If we receive an ESCAPE character, the next byte is never the real start character
    if (c == XT_ESCAPE) // 0x7f
    {
      // Wait for next byte and skip it.
      //while (!SerialRadar.available());
      //SerialRadar.read();
      while (!uwb_uart_available());
      uwb_uart_read();
      //printf("3. recv_avail\n");
    }
    else if (c == XT_START)  // 0x7d
    {
      // If it's the start character we fill the first character of the buffer and move on
      recv_buf[0] = c;
      recv_len = 1;
      break;
    }

    // Wait 10 ms if nothing is available yet
    if (!uwb_uart_available()) {
      delay_ms(10);
    }
  }

  // Wait 10 ms if nothing is available yet
  if (!uwb_uart_available()) {
    delay_ms(10);
  }

  // Start receiving the rest of the bytes
  while (uwb_uart_available())
  {
    // read a byte
    //unsigned char c = SerialRadar.read(); // Get one byte from radar
    unsigned char c = uwb_uart_read();

    // is it an escape byte?
    if (c == XT_ESCAPE) // 0x7f
    {
      // If it's an escape character next character in buffer is data and not special character:
      //while (!SerialRadar.available());
      //c = SerialRadar.read();
      while (!uwb_uart_available());
      c = uwb_uart_read();

    }
    // is it the stop byte?
    else if (c == XT_STOP) {  // 0x7e
      // Fill response buffer, and increase counter
      recv_buf[recv_len++] = c;
      break;  //Exit this loop 
    }

    if (recv_len >= RX_BUF_LENGTH) {
      printf("BUFFER OVERFLOW!\n");
      return -1;
    }

    // Fill response buffer, and increase counter
    recv_buf[recv_len++] = c;



    // Wait 10 ms if nothing is available yet
    //if (!SerialRadar.available())
    if (!uwb_uart_available()) {
      delay_ms(10);
    }
  }

  // Print received data
#if 0
  printf("Received: ");
  for (int i = 0; i < recv_len; i++) {
    //printf("recv_len:%x\n",recv_len);

    printf("%x",recv_buf[i]);
    printf(" ");
  }
  printf(" \n");
#endif

  // If nothing was received, return 0.
  if (recv_len==0)
    return 0;

  // If stop character was not received, return with error.
  if (recv_buf[recv_len-1] != XT_STOP)
    return -1;


  //
  // Calculate CRC
  //
  unsigned char crc = 0;

  // CRC is calculated without the crc itself and the stop byte, hence the -2 in the counter
  for (int i = 0; i < recv_len-2; i++) 
    crc ^= recv_buf[i];

  // Check if calculated CRC matches the recieved
  if (crc == recv_buf[recv_len-2]) 
  {
    //printf("recv_len = %d\n",recv_len);
    return recv_len;  // Return length of received data (without escape bytes) upon success
  }
  else 
  {
    printf("CRC mismatch: ");
    printf("%x",crc);
    printf(" != ");
    printf("%x\n",recv_buf[recv_len-2]);
    return -1; // Return -1 upon crc failure
  }

}




