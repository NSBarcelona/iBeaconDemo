// Created by Jordi Giménez on Feb-2014.
// Copyright (c) 2014 NSBarcelona. All rights reserved.
// Apache 2 license. See LICENSE.txt

#import "BCNBeaconConstants.h"
#import "BCNBeaconEmitter.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface BCNBeaconEmitter()<CBPeripheralManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *monitoringRegion;
@property (strong, nonatomic) NSDictionary *beaconData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation BCNBeaconEmitter

-(void)start
{
    // Start the peripheral manager
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}

-(void)stop
{
    [self.peripheralManager stopAdvertising];
}

#pragma makr - Lazy instantiation
-(NSDictionary *)beaconData
{
    if(_beaconData == nil) {
        // Gets this device's data to use as beacon
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BCNBeaconUUID];
        CLBeaconRegion *advertisingRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                                    major:self.myMajor
                                                                                    minor:self.myMinor
                                                                               identifier:BCNBeaconIdentifier];
        
        _beaconData = [advertisingRegion peripheralDataWithMeasuredPower:nil];
    }
    return _beaconData;
}

#pragma mark - CBPeripherialManagerDelegate

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager*)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        // Bluetooth is on
        NSLog(@"Broadcasting");
        
        // Start broadcasting
        [self.peripheralManager startAdvertising:self.beaconData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        // Update our status label
        NSLog(@"Stopped broadcasting");
        
        // Bluetooth isn't on. Stop broadcasting
        [self.peripheralManager stopAdvertising];
    }
    else if (peripheral.state == CBPeripheralManagerStateUnsupported)
    {
        NSLog(@"iBeacons not supported");
    }
}

@end
