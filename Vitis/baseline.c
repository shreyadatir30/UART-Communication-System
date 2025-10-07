/******************************************************************************
 * Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
 * SPDX-License-Identifier: MIT
 ******************************************************************************/
/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */
// main.c — Vitis bare-metal PS-UART1 → EMIO → RTL loopback test
#include "platform.h" // init_platform(), cleanup_platform()
#include "sleep.h"
#include "xil_printf.h"
#include "xparameters.h" // for XPAR_XUARTPS_1_BASEADDR
#include "xstatus.h"
#include "xuartps.h"

// The driver provides a table of configurations—one entry per UART instance.
// Index 0 is PS-UART0 (MIO), Index 1 is  PS-UART1 (EMIO)
extern XUartPs_Config XUartPs_ConfigTable[];

// Choose UART0 by its table index and base address macro
#define UART_INSTANCE 0
#define UART_BASEADDR XPAR_XUARTPS_0_BASEADDR
#define UART_BAUDRATE 115200

static XUartPs UartInst;

int main(void) {
  int status;
  u8 txByte = 0x55;
  u8 rxByte;
  int recvCount;

  init_platform();

  XUartPs_Config *config = &XUartPs_ConfigTable[UART_INSTANCE];

  //  Initializing the driver, overriding the BaseAddress
  status = XUartPs_CfgInitialize(&UartInst, config, UART_BASEADDR);
  if (status != XST_SUCCESS) {
    xil_printf("ERROR: UART init failed (%d)\n", status);
    cleanup_platform();
    return XST_FAILURE;
  }

  // Setting the baud rate to match the RTL UART
  XUartPs_SetBaudRate(&UartInst, UART_BAUDRATE);

  xil_printf("UART1 EMIO loopback test starting\n");

  // test loop: send a byte, wait, receive it back, verify if it matches
  for (int i = 0; i < 5; ++i) {

    xil_printf("Iteration %d: sending 0x%02X\n", i, txByte);
    while (XUartPs_IsTransmitFull(UART_BASEADDR)) { /* spin */
    }
    status = XUartPs_Send(&UartInst, &txByte, 1);

    usleep(1000);

    recvCount = XUartPs_Recv(&UartInst, &rxByte, 1);
    xil_printf("Iteration %d: received 0x%02X (count=%d)\n", i, rxByte,
               recvCount);

    if (recvCount == 1 && rxByte == (u8)~txByte) {
      xil_printf("  PASS(inverted)\n");
    } else {
      xil_printf("  FAIL\n");
    }

    txByte ^= 0xFF;
    sleep(1);
  }

  return 0;
}
