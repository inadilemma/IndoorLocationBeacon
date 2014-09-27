//
//  IndoorLocationManager.h
//  IndoorLocationBeacon
//
//  Created by KH Mahmudul Alam on 27/09/2014.
//  Copyright (c) 2014 Mahmud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface IndoorLocationManager : NSObject
+ (instancetype)sharedLocationManager;

@property (nonatomic, strong) NSArray* anchorBeaconIDs;


-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;
- (NSString *)nameForBeaconID:(NSString *)beaconID;
- (NSString *)distanceLabelFromAnchor:(NSString *)anchorId;

@end
