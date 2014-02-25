// Created by Jordi Giménez on Feb-2014.
// Copyright (c) 2014 NSBarcelona. All rights reserved.
// Apache 2 license. See LICENSE.txt

#import "BCNBeaconConstants.h"
#import "BCNBeaconReceiver.h"
#import <CoreLocation/CoreLocation.h>

@interface BCNBeaconReceiver()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *monitoringRegion;
@property (strong, nonatomic) CLLocationManager* locationManager;

@property (strong, nonatomic, readwrite) NSArray* visibleBeacons;

@end

@implementation BCNBeaconReceiver


-(void)start
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startMonitoringForRegion:self.monitoringRegion];
    [self.locationManager startRangingBeaconsInRegion:self.monitoringRegion];
}

-(void)stop
{
    [self.locationManager stopRangingBeaconsInRegion:self.monitoringRegion];
    [self.locationManager stopMonitoringForRegion:self.monitoringRegion];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    NSLog(@"Beacons found: %@", beacons);
    [self.delegate beaconReceiver:self didSeeBeacons:beacons];
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Monitoring failed: %@", error);
}

#pragma mark - Lazy instatiation

-(CLBeaconRegion *)monitoringRegion
{
    if(_monitoringRegion == nil) {
        // makes a region for this demo with the constants provided
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BCNBeaconUUID];
        _monitoringRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                               identifier:BCNBeaconIdentifier];
    }
    return _monitoringRegion;
}

@end
