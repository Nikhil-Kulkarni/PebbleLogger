//
//  LogsTableViewController.m
//  Tricorder
//
//  Created by Neal on 7/2/15.
//  Copyright (c) 2015 Pebble Technology. All rights reserved.
//

#import "ViewController.h"

#import "DataLogger.h"
#import "LogData.h"
#import <CoreMotion/CoreMotion.h>

@implementation ViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TricorderDataUpdatedNotification object:[DataLogger getLogger] queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [self.tableView reloadData];
                                                  }];
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .025;
    self.motionManager.gyroUpdateInterval = .2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
//                                                 NSLog(@"X: %f, Y: %f, Z: %f, Timestamp: %f", 100*accelerometerData.acceleration.x, 100*accelerometerData.acceleration.y, 100*accelerometerData.acceleration.z, accelerometerData.timestamp);
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TricorderDataUpdatedNotification object:[DataLogger getLogger]];
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DataLogger.getLogger.numberOfLogs;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"LogsTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LogData *data = DataLogger.getLogger.recordedData[indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, h:mm:ss:SSS"];
    
    cell.textLabel.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:data.timestamp / 1000]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Packet %u", data.packetId];
    
    return cell;
}

#pragma mark - Reset Data

- (IBAction)resetDataButton:(id)sender {
    [DataLogger.getLogger resetData];
    [self.tableView reloadData];
}

@end