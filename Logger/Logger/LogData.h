//
//  LogData.h
//  Logger
//
//  Created by Nikhil Kulkarni on 10/28/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

#ifndef LogData_h
#define LogData_h


#endif /* LogData_h */

#import "AccelData.h"

@interface LogData : NSObject

@property (readonly) uint32_t packetId;
@property (readonly) uint64_t timestamp;
@property (readonly) BOOL connectionStatus;
@property (readonly) uint8_t chargePercent;
@property (readonly) AccelData *accelData;
@property (readonly) uint32_t crc32Pebble;
@property (readonly) uint32_t crc32Phone;

- (instancetype)initWithBytes:(const UInt8 *const)bytes andLength:(NSUInteger)length;
- (void)log;

@end