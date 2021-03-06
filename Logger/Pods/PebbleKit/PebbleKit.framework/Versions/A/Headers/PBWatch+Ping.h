//
//  PBWatch+Ping.h
//  PebbleKit
//
//  Created by Martijn The on 9/14/12.
//  Copyright (c) 2012 Pebble Technology. All rights reserved.
//

#import <PebbleKit/PBWatch.h>

NS_ASSUME_NONNULL_BEGIN

@interface PBWatch (Ping)

/**
 * Sends a ping to the watch.
 *  Must be called from the main thread.
 * @param cookie A number identifying the ping.
 * @param onPong The block handler that will be called when the "pong" reply from the watch has been received.
 * @param watch The watch that sent the "pong" reply, which is "self". It is passed in to avoid retain loops.
 * @param cookie The cookie that was initially passed when calling this method.
 * @param onTimeout The block handler that will be called when the watch failed to reply in time.
 */
- (void)pingWithCookie:(UInt32)cookie onPong:(void(^ __nullable)(PBWatch *watch, UInt32 cookie))onPong onTimeout:(void(^ __nullable)(PBWatch *watch, UInt32 cookie))onTimeout;

@end

NS_ASSUME_NONNULL_END
