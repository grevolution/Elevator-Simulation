//
//  MainUIController.h
//  ElevatorSimulation
//
//  Created by Shan Ul Haq on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class Elevator;
@class ElevatorUI;
@class Passenger;

@interface ElevatorsUIController : UIViewController
{
    UIButton *startButton_;
    UIButton *pauseButton_;
    UIButton *stopButton_;
    
    UIButton *btnPassengerCreate1_;
    UIButton *btnPassengerCreate2_;
    UIButton *btnPassengerCreate3_;
    UIButton *btnPassengerCreate4_;
    NSDictionary *btnPassengerCreate_;
    
    UIButton *btnEmbarkPassenger1_;
    UIButton *btnEmbarkPassenger2_;
    UIButton *btnEmbarkPassenger3_;
    UIButton *btnEmbarkPassenger4_;
    NSDictionary *btnEmbarkPassenger_;
    
    ElevatorUI *elevatorView1_;
    ElevatorUI *elevatorView2_;
    ElevatorUI *elevatorView3_;
    
    NSMutableDictionary *elevators_;
    NSMutableDictionary *passengers_;
    
    NSTimer *mainTimer_;
    
    int currentTickerCount_;
    
    UILabel *tickerLabel_;
    
    kElevatorsStatus currentStatus_;
}

@property(nonatomic, retain) IBOutlet UIButton *startButton;
@property(nonatomic, retain) IBOutlet UIButton *pauseButton;
@property(nonatomic, retain) IBOutlet UIButton *stopButton;

@property(nonatomic, retain) IBOutlet UIButton *btnPassengerCreate1;
@property(nonatomic, retain) IBOutlet UIButton *btnPassengerCreate2;
@property(nonatomic, retain) IBOutlet UIButton *btnPassengerCreate3;
@property(nonatomic, retain) IBOutlet UIButton *btnPassengerCreate4;

@property(nonatomic, retain) IBOutlet UIButton *btnEmbarkPassenger1;
@property(nonatomic, retain) IBOutlet UIButton *btnEmbarkPassenger2;
@property(nonatomic, retain) IBOutlet UIButton *btnEmbarkPassenger3;
@property(nonatomic, retain) IBOutlet UIButton *btnEmbarkPassenger4;

@property(nonatomic, retain) IBOutlet UILabel *tickerLabel;

- (void)createNewPassenger:(int)level withDestination:(int)destination;
- (void)removePassengerAtLevel:(int)level;
- (BOOL)isPassengerAvailableAtLevel:(int)level;
- (void)checkIdleElevatorsAndMoveToLevel:(int)level;
- (void)checkWaitingPassengersAndMoveElevator:(Elevator*)elevator;
- (BOOL)embarkPassenger:(Passenger*)passenger;

@end
