//
//  DataLogger.m
//  Logger
//
//  Created by Nikhil Kulkarni on 10/28/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataLogger.h"
#import <PebbleKit/PebbleKit.h>
#import "AppDelegate.h"
#import "LogData.h"


NSString *const TricorderDataUpdatedNotification = @"tricorderUpdated";

@interface DataLogger()

@property NSMutableArray* packetIds;

@end

@implementation DataLogger

+ (instancetype) getLogger {
    static DataLogger* dataLogger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataLogger = [[self alloc] init];
    });
    return dataLogger;
}

- (instancetype)init {
    NSLog(@"Init");
    if (self = [super init]) {
        _recordedData = [[NSMutableArray alloc] init];
        _packetIds = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)connectionStatus {
    NSLog(@"%@", self.latestData.connectionStatus ? @"Connected" : @"Disconnected");
    return self.latestData.connectionStatus ? @"Connected" : @"Disconnected";
}

- (uint32_t)latestPacketId {
    return self.latestData.packetId;
}

- (NSString *)latestPacketTime {
    if (_recordedData.count == 0) {
        return @"N/A";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, h:mm:ss.SSS"];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.latestData.timestamp / 1000]];
}

- (NSUInteger)numberOfLogs {
    return _recordedData.count;
}
//
- (LogData *)latestData {
    return _recordedData.firstObject;
}

- (void)resetData {
    _crcMismatches = 0;
    _duplicatePackets = 0;
    _outOfOrderPackets = 0;
    _missingPackets = 0;
    [_recordedData removeAllObjects];
    [_packetIds removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TricorderDataUpdatedNotification object:self];
}

#pragma mark - PBDataLoggingServiceDelegate

- (BOOL)dataLoggingService:(PBDataLoggingService *)service
             hasByteArrays:(const UInt8 *const)bytes
             numberOfItems:(UInt16)numberOfItems
     forDataLoggingSession:(PBDataLoggingSessionMetadata *)session {
    for (NSUInteger i = 0; i < numberOfItems; i++) {
        const uint8_t *logBytes = &bytes[i * session.itemSize];
        
        LogData *data = [[LogData alloc] initWithBytes:logBytes andLength:session.itemSize];
        [data log];
        
        if (data.packetId == 1) {
            [self resetData];
        }
        
        if (data.crc32Pebble != data.crc32Phone) {
            _crcMismatches++;
        }
        
        if (data.packetId < self.latestPacketId) {
            _outOfOrderPackets++;
        }
        
        if ([_packetIds containsObject:@(data.packetId)]) {
            _duplicatePackets++;
        }
        
        [_packetIds addObject:@(data.packetId)];
        
        [_recordedData insertObject:data atIndex:0];
    }
    NSLog(@"Logging Data");
    _missingPackets = [[_packetIds valueForKeyPath:@"@max.self"] intValue] - (_recordedData.count - _duplicatePackets);
    
    return YES;
}

- (void)dataLoggingService:(PBDataLoggingService *)service
          sessionDidFinish:(PBDataLoggingSessionMetadata *)session {
    [[NSNotificationCenter defaultCenter] postNotificationName:TricorderDataUpdatedNotification object:self];
}



@end
