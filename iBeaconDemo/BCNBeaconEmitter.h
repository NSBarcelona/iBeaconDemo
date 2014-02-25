// Created by Jordi Giménez on Feb-2014.
// Copyright (c) 2014 NSBarcelona. All rights reserved.
// Apache 2 license. See LICENSE.txt

#import <Foundation/Foundation.h>

@interface BCNBeaconEmitter : NSObject

-(void)start;
-(void)stop;

@property (nonatomic) UInt16 myMajor;
@property (nonatomic) UInt16 myMinor;

@end
