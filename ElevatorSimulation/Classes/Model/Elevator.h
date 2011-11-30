//
//  Elevator.h
//  ElevatorSimulation
//
//  Created by Shan Ul Haq on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElevatorDelegate.h"
#import "Constants.h"

@interface Elevator : NSObject {
    //defines what is the current level of elevator.
    int currentLevel_;
    
    //defines the current passenge.
    int currentPassenger_;
    
    //tells whether the elevator is in waiting state or not
    BOOL isWaiting_;
    
    BOOL isIdle_;
    
    //timer that will handle the ticker movement of the elevator
    NSTimer *timer_;
    
    id<ElevatorDelegate> delegate_;
    
    NSString *elevatorId_;
    
    kElevatorDirection currentDirection_;
    
    BOOL isStarted_;
    
    //temp required level to reach to, used for resuming operations after pause.
    int reqLevel_;
}

@property(nonatomic, readonly) int currentLevel;
@property(nonatomic, readonly) int currentPassenger;
@property(nonatomic) BOOL isWaiting;
@property(nonatomic, readonly) BOOL isIdle;
@property(nonatomic, assign) id<ElevatorDelegate> delegate;
@property(nonatomic, copy) NSString* elevatorId;
@property(nonatomic) kElevatorDirection currentDirection;
@property(nonatomic) BOOL isStarted;


- (id)initWithElevatorId:(NSString*)elevatorId;

//starts the elevator after it is paused.
- (void)start;

//pauses the elevator.
- (void)pause;

//resets the elevator to base condition.
- (void)reset;

//called to move an elevator to the required level.
- (void)moveElevatorToLevel:(int)level;

- (void)embarkPassenger:(int)passenger;

//tells whether this elevator is currently waiting for a passenger or not.
- (BOOL)isWaiting;

//tells whether the elevator is idle or not.
- (BOOL)isIdle;

//tells whether the elevator is empty or not.
- (BOOL)isEmpty;

@end
