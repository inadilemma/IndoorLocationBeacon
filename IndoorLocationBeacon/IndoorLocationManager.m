//
//  IndoorLocationManager.m
//  IndoorLocationBeacon
//
//  Created by KH Mahmudul Alam on 27/09/2014.
//  Copyright (c) 2014 Mahmud. All rights reserved.
//

#import "IndoorLocationManager.h"
#import "CommonConfig.h"


@interface IndoorLocationManager()

@property (nonatomic) NSMutableDictionary*  lastSeenBeaconByAnchor;
@property (nonatomic) NSDictionary*         referenceLocationByAnchor;
@property (nonatomic) NSDictionary*         readableNameAnchor;

@end

@implementation IndoorLocationManager

+ (instancetype)sharedLocationManager
{
    static IndoorLocationManager *locationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationManager = [[IndoorLocationManager alloc] init];
    });
    return locationManager;
}

- (NSArray *)anchorBeaconIDs
{
    if (!_anchorBeaconIDs) {
        _anchorBeaconIDs = @[kFirstAnchorNodeBeaconID, kSecondAnchorNodeBeaconID, kThirdAnchorNodeBeaconID, kFourthAnchorNodeBeaconID];
    }
    return _anchorBeaconIDs;
}

- (NSMutableDictionary *)lastSeenBeaconByAnchor
{
    if (!_lastSeenBeaconByAnchor) {
        _lastSeenBeaconByAnchor = [[NSMutableDictionary alloc] init];
    }
    return _lastSeenBeaconByAnchor;
}


- (NSDictionary *)referenceLocationByAnchor
{
    if (!_referenceLocationByAnchor) {
        _referenceLocationByAnchor = @{kFirstAnchorNodeBeaconID:[NSValue valueWithCGPoint:(CGPoint){0, 0}],
                                       kSecondAnchorNodeBeaconID:[NSValue valueWithCGPoint:(CGPoint){1, 0}],
                                       kThirdAnchorNodeBeaconID:[NSValue valueWithCGPoint:(CGPoint){1, 1}],
                                       kFourthAnchorNodeBeaconID:[NSValue valueWithCGPoint:(CGPoint){0, 1}]};
    }
    return _lastSeenBeaconByAnchor;
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    CLBeacon *beacon = [beacons lastObject];
    
    if (beacon && [self.anchorBeaconIDs containsObject:beacon.proximityUUID.UUIDString])
    {
        self.lastSeenBeaconByAnchor[beacon.proximityUUID.UUIDString] = beacon;
    }
}


- (NSDictionary *)readableNameAnchor
{
    if (!_readableNameAnchor) {
        _readableNameAnchor = @{kFirstAnchorNodeBeaconID:@"Anchor1",
                                       kSecondAnchorNodeBeaconID:@"Anchor2",
                                       kThirdAnchorNodeBeaconID:@"Anchor3",
                                       kFourthAnchorNodeBeaconID:@"Anchor4"};
    }
    return _readableNameAnchor;
}

- (NSString *)nameForBeaconID:(NSString *)beaconID
{
    return self.readableNameAnchor[beaconID] ? self.readableNameAnchor[beaconID] : @"Unrecognized";
}

- (CGPoint)calculateLocation
{
    CGPoint objectLocation;
    // The exact location can be calculated from the distance from three anchor location as we have the reference co-ordinates for those three anchors. Simple triangulation will give the desired result.

    
    return objectLocation;
}

- (NSString *)distanceLabelFromAnchor:(NSString *)anchorId
{
    if ([self.anchorBeaconIDs containsObject:anchorId] && self.lastSeenBeaconByAnchor[anchorId] != nil)
    {
        CLBeacon *beacon = self.lastSeenBeaconByAnchor[anchorId];
        float   distance = beacon.accuracy*SCALE_FACTOR;
        return [NSString stringWithFormat:@"%f", distance];
    }
    return @"---";
}


@end
