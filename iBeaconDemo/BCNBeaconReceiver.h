// Created by Jordi Giménez on Feb-2014.
// Copyright (c) 2014 NSBarcelona. All rights reserved.
// Apache 2 license. See LICENSE.txt

#import <Foundation/Foundation.h>

@protocol BCNBeaconReceiverDelegate;

@interface BCNBeaconReceiver : NSObject

-(void)start;
-(void)stop;

@property (weak, nonatomic) id<BCNBeaconReceiverDelegate> delegate;

@end

@protocol BCNBeaconReceiverDelegate <NSObject>

-(void)beaconReceiver:(BCNBeaconReceiver*)beaconReceiver didSeeBeacons:(NSArray*)beacons;

@end
