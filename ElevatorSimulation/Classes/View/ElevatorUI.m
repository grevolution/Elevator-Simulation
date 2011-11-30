//
//  ElevatorUI.m
//  ElevatorSimulation
//
//  Created by Shan Ul Haq on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ElevatorUI.h"
#import "Elevator.h"
#import "ElevatorsUIController.h"

#define VIEW_WIDTH 80
#define VIEW_HEIGHT 380

@implementation ElevatorUI

@synthesize elevatorView = elevatorView_;
@synthesize passengerLabel = passengerLabel_;
@synthesize directionView  = directionView_;

- (id)initWithParent:(ElevatorsUIController*)parent
{
    self = [super init];
    if (self) 
    {
       self = [[[NSBundle mainBundle] loadNibNamed:@"ElevatorUI" owner:self options:nil] objectAtIndex:0];
        parentRef_ = [parent retain];
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark ElevatorDelegate Methods

- (void)elevatorLevelChanged:(Elevator*)elevator;
{
    NSLog(@"%@ up at level %i", elevator.elevatorId, elevator.currentLevel);
    [self updateUI:elevator];
}

- (void)elevatorStarted:(Elevator*)elevator;
{
    NSLog(@"%@ started", elevator.elevatorId);
    [self updateUI:elevator];
}

- (void)elevatorReached:(Elevator*)elevator;
{
    NSLog(@"%@ reached at level %i", elevator.elevatorId, elevator.currentLevel);
    [self updateUI:elevator];
    
    if(![parentRef_ isPassengerAvailableAtLevel:elevator.currentLevel])
    {
        elevator.isWaiting = NO;
        
        //current passenger was removed before elevator reached. now check for any waiting passengers and go there.
        [parentRef_ checkWaitingPassengersAndMoveElevator:elevator];
    }
    
}

- (void)elevatorPassengerDisembarked:(Elevator*)elevator;
{
    NSLog(@"%@ disembarked passenger", elevator.elevatorId);
    [self updateUI:elevator];
    
    //current passenger is disemarked. now check for any waiting passengers and go there.
    [parentRef_ checkWaitingPassengersAndMoveElevator:elevator];
}

//when the main start is called
- (void)elevatorStartCalled:(Elevator*)elevator;
{
    NSLog(@"%@ main start called", elevator.elevatorId);
    [self updateUI:elevator];    
}

//when the main pause is called
- (void)elevatorPauseCalled:(Elevator*)elevator;
{
    NSLog(@"%@ main pause called", elevator.elevatorId);
    [self updateUI:elevator];    
}

//when the main reset is called
- (void)elevatorResetCalled:(Elevator*)elevator;
{
    NSLog(@"%@ main reset called", elevator.elevatorId);
    [self updateUI:elevator];    
}

- (void)updateUI:(Elevator*)elevator
{
    //if passenger is there set label
    if(elevator.currentPassenger != 0)
    {
        [self.passengerLabel setHidden:NO];
        [self.passengerLabel setText:INT2STR(elevator.currentPassenger)];
    } else {
        [self.passengerLabel setHidden:YES];
        [self.passengerLabel setText:@""];
    }
    
    if(elevator.isWaiting){
        [statusLabel_ setHidden:NO];
        [statusLabel_ setText:@"W"];
    } else if(elevator.isIdle){
        [statusLabel_ setHidden:NO];
        [statusLabel_ setText:@"I"];        
    } else {
        [statusLabel_ setHidden:YES];
        [statusLabel_ setText:@""];        
    }
    
    //update the direction image.
    if(elevator.currentDirection == kDirectionUp){
        [self.directionView setImage:[UIImage imageNamed:@"up.png"]];
    } else if(elevator.currentDirection == kDirectionDown){
        [self.directionView setImage:[UIImage imageNamed:@"down.png"]];
    } else {
        [self.directionView setImage:nil];
    }
    
    //update the current position of the elevator based on current level.
    int offset = 60;
    int bottomPad = ( 5 - elevator.currentLevel ) * 5 ;
    int topPad = ( 4 - elevator.currentLevel ) * 5 ;
    int y = offset + bottomPad + ( (4 - elevator.currentLevel) * 70 ) + topPad;
    int x = self.elevatorView.frame.origin.x;
    int width = 70;
    int height = 70;
    [self.elevatorView setFrame:CGRectMake(x, y, width, height)];
}

#pragma mark end

- (void)dealloc
{
    safeRelease(elevatorView_);
    safeRelease(passengerLabel_);
    safeRelease(directionView_);
    safeRelease(parentRef_);
    [super dealloc];
}

@end
