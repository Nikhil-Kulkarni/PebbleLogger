//
//  AppDelegate.h
//  Logger
//
//  Created by Nikhil Kulkarni on 10/27/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PebbleKit/PebbleKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, PBPebbleCentralDelegate, PBWatchDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PBWatch *connectedWatch;


@end

