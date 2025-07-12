#ifndef PERIPHERAL_API_H
#define PERIPHERAL_API_H

extern void PrintString(char *str);
extern void WriteDataPortIO(int value);
extern void EnablePortIOBits(int value);
extern void ConfigPortIOBitsDirection(int value);
extern void ReadDataPortIO(int* buffer);
extern void SetTimerCounter(int value);
extern void SetPortIOInterrupt(int value);
extern void SetPICMask(int value);
extern void SetHandler(int n, void* handler);

#endif
