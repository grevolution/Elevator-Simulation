//
//  Passenger.h
//  ElevatorSimulation
//
//  Created by Shan Ul Haq on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Passenger : NSObject
{
    int currentLevel_;
    int destinationLevel_;
    BOOL isLocked_;
}

@property(nonatomic) int currentLevel;
@property(nonatomic) int destinationLevel;
@property(nonatomic) BOOL isLocked;

@end
