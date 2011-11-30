//
//  Util.m
//  ElevatorSimulation
//
//  Created by Shan Ul Haq on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Util.h"

@implementation Util

// both numbers inclusive
+ (int) randBetween:(int)x and:(int)y;
{
	return (arc4random() % (y-x+1)) + x;
}


@end
