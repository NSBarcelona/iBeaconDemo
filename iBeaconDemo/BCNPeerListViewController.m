// Created by Jordi Giménez on Feb-2014.
// Copyright (c) 2014 NSBarcelona. All rights reserved.
// Apache 2 license. See LICENSE.txt

#import "BCNPeerListViewController.h"
#import "BCNBeaconEmitter.h"
#import "BCNBeaconReceiver.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@interface BCNPeerListViewController ()<BCNBeaconReceiverDelegate>

@property (strong, nonatomic) NSArray* peers; // of CLBeacon

@property (strong, nonatomic) BCNBeaconEmitter* beaconEmitter;
@property (strong, nonatomic) BCNBeaconReceiver* beaconReceiver;

@end

@implementation BCNPeerListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // make an ID for this device (shown as title)
    UInt16 major = arc4random();
    UInt16 minor = arc4random();
    self.title = [self userIdForMajor:major minor:minor];

    // set up beacon emitter, so that others see us
    self.beaconEmitter = [BCNBeaconEmitter new];
    self.beaconEmitter.myMajor = major;
    self.beaconEmitter.myMinor = minor;
    [self.beaconEmitter start];
    
    // setu up beacon receiver, so that we see others
    self.beaconReceiver = [BCNBeaconReceiver new];
    self.beaconReceiver.delegate = self;
    [self.beaconReceiver start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.peers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    CLBeacon* peer = [self.peers objectAtIndex:indexPath.row];
    NSString* peerId = [self userIdForMajor:peer.major.intValue minor:peer.minor.intValue];
    NSString* proximity = [self stringForProximity:peer.proximity];
    cell.textLabel.text = peerId;
    cell.detailTextLabel.text = proximity;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // do something useful
}

#pragma mark - NSBPeerControllerDelegate
-(void)beaconReceiver:(BCNBeaconReceiver *)beaconReceiver didSeeBeacons:(NSArray *)beacons
{
    self.peers = beacons;
    [self.tableView reloadData];
}

#pragma mark - Util
-(NSString*)userIdForMajor:(UInt16)major minor:(UInt16)minor
{
    return [NSString stringWithFormat:@"%04x %04x", major, minor];
}

-(NSString*)stringForProximity:(CLProximity)proximity
{
    switch (proximity) {
        case CLProximityImmediate:
            return @"Immediate";
        case CLProximityNear:
            return @"Near";
        case CLProximityFar:
            return @"Far";
        case CLProximityUnknown:
            return @"Unknown";
    }
}

-(void)dealloc
{
    [self.beaconReceiver stop];
    [self.beaconEmitter stop];
}

@end
