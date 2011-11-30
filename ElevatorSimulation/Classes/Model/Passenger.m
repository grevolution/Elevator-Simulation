//
//  Passenger.m
//  ElevatorSimulation
//
//  Created by Shan Ul Haq on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Passenger.h"

@implementation Passenger

@synthesize currentLevel = currentLevel_;
@synthesize destinationLevel = destinationLevel_;
@synthesize isLocked = isLocked_;

-(void)dealloc
{
    [super dealloc];
}

@end
