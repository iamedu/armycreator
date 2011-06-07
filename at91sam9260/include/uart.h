#ifndef _UART_H
#define _UART_H

#import <armyc/ARMDevice.h>
#import <armyc/ARMCore.h>

@interface Uart : ARMDevice {
}

-(id)initWithBase:(UWord)b withCore:(ARMCore *)c;

@end

#endif

