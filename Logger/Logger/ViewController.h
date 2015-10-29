//
//  ViewController.h
//  Logger
//
//  Created by Nikhil Kulkarni on 10/27/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) CMMotionManager *motionManager;

@end

