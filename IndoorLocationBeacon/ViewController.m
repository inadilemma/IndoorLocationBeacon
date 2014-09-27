//
//  ViewController.m
//  IndoorLocationBeacon
//
//  Created by KH Mahmudul Alam on 27/09/2014.
//  Copyright (c) 2014 Mahmud. All rights reserved.
//

#import "ViewController.h"
#import "CommonConfig.h"

@interface ViewController ()

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;


@property (weak, nonatomic) IBOutlet UILabel *lastSeenNode;
@property (weak, nonatomic) IBOutlet UILabel *lastSeenProcimity;
@property (weak, nonatomic) IBOutlet UILabel *lastSeenAccuracy;
@property (weak, nonatomic) IBOutlet UILabel *lastSeenRSSI;

@property (weak, nonatomic) IBOutlet UILabel *distanceAnchor1;
@property (weak, nonatomic) IBOutlet UILabel *distanceAnchor2;
@property (weak, nonatomic) IBOutlet UILabel *distanceAnchor3;
@property (weak, nonatomic) IBOutlet UILabel *distanceAnchor4;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    [self initRegions];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]])
    {
        [manager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}



- (void)initRegions
{
    
    for (NSString* beaconId in [IndoorLocationManager sharedLocationManager].anchorBeaconIDs) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:beaconId];
        NSString *readableName = [[IndoorLocationManager sharedLocationManager] nameForBeaconID:beaconId];
        
        CLBeaconRegion  *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:readableName];
        [self.locationManager startMonitoringForRegion:beaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Beacon Found");
    if ([region isKindOfClass:[CLBeaconRegion class]])
    {
        [manager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
    if ([region isKindOfClass:[CLBeaconRegion class]])
    {
        [manager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}



-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    CLBeacon *beacon = [beacons lastObject];
    
    [[IndoorLocationManager sharedLocationManager] locationManager:manager didRangeBeacons:beacons inRegion:region];

    self.lastSeenAccuracy.text = [NSString stringWithFormat:@"Accuracy: %f", beacon.accuracy];
    if (beacon.proximity == CLProximityUnknown) {
        self.lastSeenProcimity.text = @"Proximity : Unknown";
    } else if (beacon.proximity == CLProximityImmediate) {
        self.lastSeenProcimity.text = @"Proximity : Immediate";
    } else if (beacon.proximity == CLProximityNear) {
        self.lastSeenProcimity.text = @"Proximity : Near";
    } else if (beacon.proximity == CLProximityFar) {
        self.lastSeenProcimity.text = @"Proximity : Far";
    }
    self.lastSeenNode.text = [[IndoorLocationManager sharedLocationManager] nameForBeaconID:beacon.proximityUUID.UUIDString];
    self.lastSeenRSSI.text = [NSString stringWithFormat:@"%li", (long)beacon.rssi];
    
    [self updateDistanceLabels];
}

- (void)updateDistanceLabels
{
    NSArray* anchorIds = [IndoorLocationManager sharedLocationManager].anchorBeaconIDs;
    
    self.distanceAnchor1.text = [[IndoorLocationManager sharedLocationManager] distanceLabelFromAnchor:anchorIds[0]];
    self.distanceAnchor2.text = [[IndoorLocationManager sharedLocationManager] distanceLabelFromAnchor:anchorIds[1]];
    self.distanceAnchor3.text = [[IndoorLocationManager sharedLocationManager] distanceLabelFromAnchor:anchorIds[2]];
    self.distanceAnchor4.text = [[IndoorLocationManager sharedLocationManager] distanceLabelFromAnchor:anchorIds[3]];
}


@end
