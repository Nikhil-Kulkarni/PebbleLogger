//
//  DataLogger.h
//  Logger
//
//  Created by Nikhil Kulkarni on 10/28/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PebbleKit/PebbleKit.h>


extern NSString *const TricorderDataUpdatedNotification;

@interface DataLogger : NSObject<PBDataLoggingServiceDelegate>

@property (readonly) NSMutableArray* recordedData;
@property (readonly) NSInteger crcMismatches;
@property (readonly) NSInteger duplicatePackets;
@property (readonly) NSInteger outOfOrderPackets;
@property (readonly) NSInteger missingPackets;

+ (instancetype)getLogger;

- (NSString *)connectionStatus;
- (uint32_t)latestPacketId;
- (NSString *)latestPacketTime;
- (NSUInteger)numberOfLogs;
- (void)resetData;

@end
