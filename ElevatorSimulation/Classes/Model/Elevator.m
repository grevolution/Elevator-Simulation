//
//  Elevator.m
//  ElevatorSimulation
//
//  Created by Shan Ul Haq on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Elevator.h"

@implementation Elevator

@synthesize currentLevel = currentLevel_;
@synthesize currentPassenger = currentPassenger_;
@synthesize isWaiting = isWaiting_;
@synthesize isIdle = isIdle_;
@synthesize delegate = delegate_;
@synthesize elevatorId = elevatorId_;
@synthesize currentDirection = currentDirection_;
@synthesize isStarted = isStarted_;

- (id)initWithElevatorId:(NSString*)elevatorId
{
    if((self = [super init])){
        currentLevel_ = 1; // by default the level is 1
        currentPassenger_ = 0; // 0 means currently there is no passenger.
        isIdle_ = YES; //currently doing nothing
        elevatorId_ = [elevatorId copy];
        currentDirection_ = kDirectionNone;
    }
    return self;
}

//starts the elevator after it is paused.
- (void)start;
{
    if(timer_)
    {
        [timer_ invalidate];
        safeRelease(timer_);
    }
    
    //we have to check if the elevator was in which state?
    //1- idle
    if(isIdle_)
    {
        //we have to do nothing
    }
    
    //2- waiting
    if(isWaiting_)
    {
        // we have to do nothing
    }
    
    //3- elevator is moving empty to get a passenger
    if(!isIdle_ && reqLevel_!=0 && currentPassenger_ == 0)
    {
        [self moveElevatorToLevel:reqLevel_];
    }
    //4- moving with passenger
    if(!isIdle_ && reqLevel_!=0 && currentPassenger_ != 0 && reqLevel_ != currentLevel_)
    {
        [self moveElevatorToLevel:reqLevel_];
    }
    
    //5- disembarking passenger
    if(!isIdle_ && reqLevel_!=0 && reqLevel_ == currentPassenger_ && currentPassenger_ == currentLevel_)
    {
        //there was a passenger in the elevator. have to disemabrk him.
        timer_ = [[NSTimer scheduledTimerWithTimeInterval:(TICKER_INTERVAL*2) target:self selector:@selector(disembark:) userInfo:nil repeats:YES] retain];        
    }
    
    isStarted_ = YES;
    [delegate_ elevatorStartCalled:self];
}

//pauses the elevator.
- (void)pause;
{
    if(timer_)
    {
        [timer_ invalidate];
        [timer_ release], timer_ = nil;
    }
    
    isStarted_ = NO;
    [delegate_ elevatorPauseCalled:self];
}

//resets the elevator to base condition.
- (void)reset;
{
    if(timer_)
    {
        [timer_ invalidate];
        [timer_ release], timer_ = nil;
    }
    currentLevel_ = 1;
    currentPassenger_ = 0;
    isIdle_ = YES;
    currentDirection_ = kDirectionNone;
    isWaiting_ = NO;
    isStarted_ = NO;
    [delegate_ elevatorResetCalled:self];    
}

//called to move an elevator to the required level.
- (void)moveElevatorToLevel:(int)level;
{
    reqLevel_ = level;
    if(currentLevel_ == level){
        reqLevel_ = 0;
        currentPassenger_ = 0;
        isWaiting_ = YES;
        currentDirection_ = kDirectionNone;
        [delegate_ elevatorReached:self];
        return;
    }
    if(timer_){
        //invalidate the current timer
        [timer_ invalidate];
        [timer_ release], timer_ = nil;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%i",level],@"level", nil];
    
    if(currentLevel_ < level)
    {
        currentDirection_ = kDirectionUp;
        timer_ = [[NSTimer scheduledTimerWithTimeInterval:TICKER_INTERVAL target:self selector:@selector(moveUp:) userInfo:params repeats:YES] retain];        
    } else 
    {
        currentDirection_ = kDirectionDown;
        timer_ = [[NSTimer scheduledTimerWithTimeInterval:TICKER_INTERVAL target:self selector:@selector(moveDown:) userInfo:params repeats:YES] retain];                
    }
    isIdle_ = NO;
    isWaiting_ = NO;
    [delegate_ elevatorStarted:self];
}

- (void)embarkPassenger:(int)passenger
{
    currentPassenger_ = passenger;
    [self moveElevatorToLevel:passenger];
}

- (void)moveUp:(NSTimer*)timer
{
    int requiredLevel = [[timer.userInfo objectForKey:@"level"] intValue];
    if(currentLevel_ < requiredLevel )
    {
        currentLevel_++;
        [delegate_ elevatorLevelChanged:self];
    }
    
    if(currentLevel_ == requiredLevel)
    {
        [timer_ invalidate];
        [timer_ release], timer_ = nil;
        currentDirection_ = kDirectionNone;
        if(currentPassenger_ !=0)
        {
            //there was a passenger in the elevator. have to disemabrk him.
            timer_ = [[NSTimer scheduledTimerWithTimeInterval:(TICKER_INTERVAL*2) target:self selector:@selector(disembark:) userInfo:nil repeats:YES] retain];
        } else
        {
            isIdle_ = YES;
            isWaiting_ = YES;
            reqLevel_ = 0;
            [delegate_ elevatorReached:self];
        }
    }   
}

- (void)disembark:(NSTimer*)timer
{
    currentPassenger_ = 0;
    [timer_ invalidate];
    [timer_ release], timer_ = nil;    
    
    isIdle_ = YES;
    [delegate_ elevatorPassengerDisembarked:self];    
}

- (void)moveDown:(NSTimer*)timer
{
    int requiredLevel = [[timer.userInfo objectForKey:@"level"] intValue];
    if(currentLevel_ > requiredLevel )
    {
        currentLevel_--;
        [delegate_ elevatorLevelChanged:self];
    }
    
    if(currentLevel_ == requiredLevel)
    {
        [timer_ invalidate];
        [timer_ release], timer_ = nil;
        currentDirection_ = kDirectionNone;
        if(currentPassenger_ !=0)
        {
            //there was a passenger in the elevator. have to disemabrk him.
            timer_ = [[NSTimer scheduledTimerWithTimeInterval:(TICKER_INTERVAL*2) target:self selector:@selector(disembark:) userInfo:nil repeats:YES] retain];
        } else
        {
            isIdle_ = YES; 
            isWaiting_ = YES;
            reqLevel_ = 0;
            [delegate_ elevatorReached:self];
        }        
    }    
}


//tells whether the elevator is empty or not.
- (BOOL)isEmpty;
{
    return (currentPassenger_ == 0);
}


- (void)dealloc
{
    delegate_ = nil;
    safeRelease(elevatorId_);
    [super dealloc];
}

@end
