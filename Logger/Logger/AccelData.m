//
//  AccelData.m
//  Tricorder
//
//  Created by Neal on 6/30/15.
//  Copyright (c) 2015 Pebble Technology. All rights reserved.
//

#import "AccelData.h"

static NSUInteger const AccelDataLength = 15;

@implementation AccelData

- (instancetype)initWithData:(NSData *)data {
    if (self = [super init]) {
        if ([data length] != AccelDataLength) {
            NSLog(@"AccelData size mismatch: got %lu but expected %lu", (unsigned long)[data length], (unsigned long)AccelDataLength);
            return nil;
        }

        const void *subdataBytes;
        NSRange range = {0, 0};

        range.location += range.length;
        range.length = 2;
        subdataBytes = [[data subdataWithRange:range] bytes];

        _x = CFSwapInt16LittleToHost(*(uint16_t*)subdataBytes);
        NSLog(@"%hd", _x);

        range.location += range.length;
        range.length = 2;
        subdataBytes = [[data subdataWithRange:range] bytes];

        _y = CFSwapInt16LittleToHost(*(uint16_t*)subdataBytes);
        NSLog(@"%hd", _y);

        range.location += range.length;
        range.length = 2;
        subdataBytes = [[data subdataWithRange:range] bytes];

        _z = CFSwapInt16LittleToHost(*(uint16_t*)subdataBytes);
        NSLog(@"%hd", _z);

        range.location += range.length;
        range.length = 1;
        subdataBytes = [[data subdataWithRange:range] bytes];

        _didVibrate = CFSwapInt16LittleToHost(*(uint16_t*)subdataBytes);

        range.location += range.length;
        range.length = 8;
        subdataBytes = [[data subdataWithRange:range] bytes];

        _timestamp = CFSwapInt64LittleToHost(*(uint64_t*)subdataBytes);
        NSLog(@"%llu", _timestamp);
        
        // Write data to iPhone documents directory
        NSString *dataString = [NSString stringWithFormat:@"X: %hd, Y: %hd, Z: %hd, Timestamp: %llu", _x, _y, _z, _timestamp];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName = [NSString stringWithFormat:@"%@/tempfile", documentsDirectory];
        [dataString writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }

    return self;
}

@end
