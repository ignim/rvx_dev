// Written by: Øyvind Nydal Dahl
// Company: XeThru / Novelda
// July 2018

// SERIAL PORTS:
// These definitions work for Arduino Mega, but must be changed for other Arduinos.
//  * Note: Using Serial as SerialRadar seems to give a few CRC errors. I'm not seeing this 
//    using Serial1, Serial2, or Serial3. Could probably be solved by changing baud rate)
// 
#include <stdint.h>
#include <string.h>
#include <stdbool.h>


#define SerialRadar Serial1		// Used for communication with the radar
#define SerialDebug Serial		// Used for printing debug information

// Pin definitions
//#define RESET_PIN 2
//#define RADAR_RX_PIN 18

//typedef unsigned int uint32_t;


//
// The following values can be found in XeThru Module Communication Protocol:
//  https://www.xethru.com/community/resources/xethru-module-communication-protocol.130/
//
#define XT_START 0x7d
#define XT_STOP 0x7e
#define XT_ESCAPE 0x7f

#define XTS_ID_SLEEP_STATUS                             (uint32_t)0x2375a16c
#define XTS_ID_RESP_STATUS                              (uint32_t)0x2375fe26
#define XTS_ID_RESPIRATION_MOVINGLIST                   (uint32_t)0x610a3b00
#define XTS_ID_RESPIRATION_DETECTIONLIST                (uint32_t)0x610a3b02
#define XTS_ID_APP_RESPIRATION_2                        (uint32_t)0x064e57ad
#define XTS_ID_DETECTION_ZONE                           (uint32_t)0x96a10a1c
#define XTS_ID_SENSITIVITY                              (uint32_t)0x10a5112b

// Profile codes
#define XTS_VAL_RESP_STATE_BREATHING      0x00 // Valid RPM sensing
#define XTS_VAL_RESP_STATE_MOVEMENT       0x01 // Detects motion, but can not identify breath
#define XTS_VAL_RESP_STATE_MOVEMENT_TRACKING  0x02 // Detects motion, possible breathing soon
#define XTS_VAL_RESP_STATE_NO_MOVEMENT      0x03 // No movement detected
#define XTS_VAL_RESP_STATE_INITIALIZING     0x04 // Initializing sensor
#define XTS_VAL_RESP_STATE_ERROR        0x05 // Sensor has detected some problem. StatusValue indicates problem.
#define XTS_VAL_RESP_STATE_UNKNOWN        0x06 // Undefined state.

#define XTS_SPR_APPDATA 0x50
#define XTS_SPR_SYSTEM 0x30

#define XTS_SPC_APPCOMMAND 0x10
#define XTS_SPC_MOD_SETMODE 0x20
#define XTS_SPC_MOD_LOADAPP 0x21
#define XTS_SPC_MOD_RESET 0x22
#define XTS_SPC_MOD_SETCOM 0x23
#define XTS_SPC_MOD_SETLEDCONTROL 0x24
#define XTS_SPC_MOD_NOISEMAP 0x25

// Output control
#define XTID_OUTPUT_CONTROL_DISABLE    (0)
#define XTID_OUTPUT_CONTROL_ENABLE     (1)

// Sensor mode IDs
#define XTS_SM_RUN                  (0x01)
#define XTS_SM_NORMAL               (0x10)
#define XTS_SM_IDLE                 (0x11)
#define XTS_SM_MANUAL               (0x12)
#define XTS_SM_STOP                 (0x13)

#define XTS_SPR_ACK 0x10
#define XTS_SPR_ERROR 0x20

#define XTS_SPRS_BOOTING (uint32_t)0x00000010
#define XTS_SPRS_READY (uint32_t)0x00000011

#define XTS_SPCA_SET 0x10
#define XTS_SPCN_SETCONTROL 0x10
#define XTS_SPCO_SETCONTROL 0x10
#define XTS_SPC_OUTPUT 0x41

#define TX_BUF_LENGTH 64
#define RX_BUF_LENGTH 64


unsigned char send_buf[TX_BUF_LENGTH];  // Buffer for sending data to radar. 
unsigned char recv_buf[RX_BUF_LENGTH];  // Buffer for receiving data from radar.
//const char * states[7] = { "Breathing", "Movement", "Movement tracking", "No movement", "Initializing", "", "Unknown" };
          
// Struct to hold respiration message from radar
typedef struct {
  uint32_t state_code;
  float rpm;
  float distance;
  uint32_t signal_quality;
  float movement_slow;
  float movement_fast;
} RespirationMessage;


// ##################
// USER UART0
// ##################
void uwb_uart_init();
void uwb_uart_write(char *ch, int size);
char uwb_uart_read();
char uwb_uart_get();
int  uwb_uart_available();

//#########################################
int get_respiration_data(RespirationMessage * resp_msg);

void stop_module(); 

// Set sensitivity
void set_sensitivity(uint32_t sensitivity); 

// Set detection zone
void set_detection_zone(float zone_start, float zone_end); 


  
// Run profile
void run_profile(); 

// Load profile
void load_profile(uint32_t profile);

void configure_noisemap(); 

void enable_output_message(uint32_t message); 

void disable_output_message(uint32_t message); 


// This method waits indefinitely for the XTS_SPRS_READY message from the radar
void wait_for_ready_message();

// This method checks if an ACK was received from the radar
void get_ack();


/*
 * Adds CRC, Escaping and Stop byte to the
 * send_buf and sends it over the SerialRadar.
 */
void send_command(int len); 
  
  
/* 
 * Receive data from radar module
 *  -Data is stored in the global array recv_buf[]
 *  -On success it returns number of bytes received (without escape bytes
 *  -On error it returns -1
 */
int receive_data();

