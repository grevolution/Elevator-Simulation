//
//  ElevatorDelegate.h
//  ElevatorSimulation
//
//  Created by Shan Ul Haq on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Elevator;

@protocol ElevatorDelegate <NSObject>

//whenever the elevator will change its level while moving up/down this mehtod will be called
- (void)elevatorLevelChanged:(Elevator*)elevator;

//when elevator will start moving this method will be called.
- (void)elevatorStarted:(Elevator*)elevator;

//when elevator will reach to a level to embark a passenger, this method will be called
- (void)elevatorReached:(Elevator*)elevator;

//when elevator will disembark a passenger, this method will be called.
- (void)elevatorPassengerDisembarked:(Elevator*)elevator;

//when the main start is called
- (void)elevatorStartCalled:(Elevator*)elevator;

//when the main pause is called
- (void)elevatorPauseCalled:(Elevator*)elevator;

//when the main reset is called
- (void)elevatorResetCalled:(Elevator*)elevator;


@end
