// ****************************************************************************
// Copyright SoC Design Research Group, All rights reserved.
// Electronics and Telecommunications Research Institute (ETRI)
// 
// THESE DOCUMENTS CONTAIN CONFIDENTIAL INFORMATION AND KNOWLEDGE
// WHICH IS THE PROPERTY OF ETRI. NO PART OF THIS PUBLICATION IS
// TO BE USED FOR ANY OTHER PURPOSE, AND THESE ARE NOT TO BE
// REPRODUCED, COPIED, DISCLOSED, TRANSMITTED, STORED IN A RETRIEVAL
// SYSTEM OR TRANSLATED INTO ANY OTHER HUMAN OR COMPUTER LANGUAGE,
// IN ANY FORM, BY ANY MEANS, IN WHOLE OR IN PART, WITHOUT THE
// COMPLETE PRIOR WRITTEN PERMISSION OF ETRI.
// ****************************************************************************
// 2022-03-11
// Sukho Lee (shlee99@etri.re.kr)
// ****************************************************************************

#include "platform_info.h"
#include "ervp_printf.h"
#include "ervp_delay.h"
#include "ervp_multicore_synch.h"
#include "x4m202.h"

const char * states[7] = { "Breathing", "Movement", "Movement tracking", "No movement", "Initializing", "", "Unknown" };

int main() {
  printf("UWB Rrespiration Test !\n");

  // If the RX-pin of the radar is low during reset or power-up, it goes into bootloader mode.
  // We don't want that, that's why we first set the RADAR_RX_PIN to high, then reset the module.
  //pinMode(RADAR_RX_PIN, OUTPUT);
  //digitalWrite(RADAR_RX_PIN, HIGH);


  uwb_uart_init();
  printf("1.uart_init\n");

  // After the module resets, the XTS_SPRS_BOOTING message is sent. Then, after the 
  // module booting sequence is completed and the module is ready to accept further
  // commands, the XTS_SPRS_READY command is issued. Let's wait for this.
  wait_for_ready_message();
  printf("2.wait_ready_message\n");

  // Stop the module, in case it is running
  stop_module();
  printf("3.stop_module\n");



  // Load respiration profile  
  load_profile(XTS_ID_APP_RESPIRATION_2);
  printf("4.load_profile\n");

  // Configure the noisemap
  configure_noisemap();
  printf("5.configure_noise_map\n");

  // Set detection zone
  set_detection_zone(0.4, 2.0);
  printf("6.set_detection_zone\n");

  // Set sensitivity
  set_sensitivity(9);
  printf("7.set_sensitivity\n");

  // Enable only the Sleep message, disable all others
  enable_output_message(XTS_ID_SLEEP_STATUS);
  disable_output_message(XTS_ID_RESP_STATUS);
  disable_output_message(XTS_ID_RESPIRATION_MOVINGLIST);
  disable_output_message(XTS_ID_RESPIRATION_DETECTIONLIST);
  printf("8.sleep message\n");

  // Run profile - after this the radar will start sending the sleep message we enabled above
  run_profile();
  printf("9.run_profile\n");


  // For every loop we check to see if we have received any respiration data
  while(1) {
    //printf("10.looping\n");

    RespirationMessage msg;
    if (get_respiration_data(&msg)) {
      //Do something with msg...
      printf("State: ");
      printf("%s\n",states[msg.state_code]);
      printf("RPM: ");
      printf("%f\n",msg.rpm, 1);
      printf("Distance: ");
      printf("%f meter\n",msg.distance, 1);
      printf("signal_quality: ");
      printf("%d\n",msg.signal_quality);
      printf("movement_slow: ");
      printf("%f\n",msg.movement_slow, 1);
      printf("movement_fast: ");
      printf("%f\n",msg.movement_fast, 1);
      printf("---\n");

    }
    //printf("10.looping\n");
  }

  return 0;
}


