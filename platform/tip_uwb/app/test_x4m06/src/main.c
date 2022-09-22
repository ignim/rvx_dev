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
#include "x4m06.h"


int main() {
  printf("X4M06 Rrespiration Test !\n");

  // If the RX-pin of the radar is low during reset or power-up, it goes into bootloader mode.
  // We don't want that, that's why we first set the RADAR_RX_PIN to high, then reset the module.
  //pinMode(RADAR_RX_PIN, OUTPUT);
  //digitalWrite(RADAR_RX_PIN, HIGH);


  uwb_uart_init2();
  printf("1.uart_init\n");

  // After the module resets, the XTS_SPRS_BOOTING message is sent. Then, after the 
  // module booting sequence is completed and the module is ready to accept further
  // commands, the XTS_SPRS_READY command is issued. Let's wait for this.
  wait_for_ready_message2();
  printf("2.wait_ready_message\n");

  // The X4M03 module only supports X4Driver Level commands.
  set_pulses_per_step(10);
  set_downconversion(false);
  set_iterations(15);
  set_dac_min(949);
  set_dac_max(1100);
  set_dac_step(1);
  set_prf_div(16);
  set_frame_offset(0.2);
  set_frame_area(0.0, 1.0);
  printf("3.set parameter\n");


  // Setting the fps to something higher than 0 will make the radar start sending data
  set_fps(1);
  printf("4.set fps\n");


  // For every loop we check to see if we have received any respiration data
  while(1) {
    //printf("5.looping\n");
    receive_float_data_msg();
  }

  return 0;
}


