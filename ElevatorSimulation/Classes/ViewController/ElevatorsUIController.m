//
//  MainUIController.m
//  ElevatorSimulation
//
//  Created by Shan Ul Haq on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ElevatorsUIController.h"
#import "Elevator.h"
#import "Passenger.h"
#import "ElevatorUI.h"
#import "Util.h"

@implementation ElevatorsUIController

@synthesize startButton = startButton_;
@synthesize pauseButton = pauseButton_;
@synthesize stopButton = stopButton_;

@synthesize btnPassengerCreate1 = btnPassengerCreate1_;
@synthesize btnPassengerCreate2 = btnPassengerCreate2_;
@synthesize btnPassengerCreate3 = btnPassengerCreate3_;
@synthesize btnPassengerCreate4 = btnPassengerCreate4_;

@synthesize btnEmbarkPassenger1 = btnEmbarkPassenger1_;
@synthesize btnEmbarkPassenger2 = btnEmbarkPassenger2_;
@synthesize btnEmbarkPassenger3 = btnEmbarkPassenger3_;
@synthesize btnEmbarkPassenger4 = btnEmbarkPassenger4_;

@synthesize tickerLabel = tickerLabel_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        elevators_ = [[NSMutableDictionary alloc] initWithCapacity:3];
        [elevators_ setObject:[[Elevator alloc] initWithElevatorId:@"Elevator-1"] forKey:INT2STR(1)];
        [elevators_ setObject:[[Elevator alloc] initWithElevatorId:@"Elevator-2"] forKey:INT2STR(2)];
        [elevators_ setObject:[[Elevator alloc] initWithElevatorId:@"Elevator-3"] forKey:INT2STR(3)];
        
        passengers_ = [[NSMutableDictionary alloc] initWithCapacity:4];
        
        currentStatus_ = kStopped;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [btnEmbarkPassenger1_  setHidden:YES];
    [btnEmbarkPassenger2_  setHidden:YES];
    [btnEmbarkPassenger3_  setHidden:YES];
    [btnEmbarkPassenger4_  setHidden:YES];
    
    elevatorView1_ = [[ElevatorUI alloc] initWithParent:self];
    [elevatorView1_ setFrame:CGRectMake(80, 100, 80, 380)];
    [[elevators_ objectForKey:INT2STR(1)] setDelegate:elevatorView1_];
    
    elevatorView2_ = [[ElevatorUI alloc] initWithParent:self];
    [elevatorView2_ setFrame:CGRectMake(160, 100, 80, 380)];
    [[elevators_ objectForKey:INT2STR(2)] setDelegate:elevatorView2_];
    
    elevatorView3_ = [[ElevatorUI alloc] initWithParent:self];
    [elevatorView3_ setFrame:CGRectMake(240, 100, 80, 380)];
    [[elevators_ objectForKey:INT2STR(3)] setDelegate:elevatorView3_];
    
    [self.view addSubview:elevatorView1_];
    [self.view addSubview:elevatorView2_];
    [self.view addSubview:elevatorView3_];    
    
    btnPassengerCreate_ = [[NSDictionary dictionaryWithObjectsAndKeys:
                            btnPassengerCreate1_,@"1",
                            btnPassengerCreate2_,@"2",
                            btnPassengerCreate3_,@"3",
                            btnPassengerCreate4_,@"4", nil] retain];
    
    btnEmbarkPassenger_ = [[NSDictionary dictionaryWithObjectsAndKeys:
                            btnEmbarkPassenger1_,@"1",
                            btnEmbarkPassenger2_,@"2",
                            btnEmbarkPassenger3_,@"3",
                            btnEmbarkPassenger4_,@"4", nil] retain];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)startButtonClick:(id)sender;
{
    NSArray *keys = [elevators_ allKeys];
    for( NSString *key in keys )
    {
        Elevator *elevator = [elevators_ objectForKey:key];
        [elevator start];
    }
    mainTimer_ = [[NSTimer scheduledTimerWithTimeInterval:TICKER_INTERVAL target:self selector:@selector(tick:) userInfo:nil repeats:YES] retain];
    
    currentStatus_ = kStarted;
}

- (void)tick:(NSTimer*)timer
{
    [tickerLabel_ setText:INT2STR(++currentTickerCount_)];
}

- (IBAction)pauseButtonClick:(id)sender;
{
    NSArray *keys = [elevators_ allKeys];
    for( NSString *key in keys )
    {
        Elevator *elevator = [elevators_ objectForKey:key];
        [elevator pause];
    }
    [mainTimer_ invalidate];
    [mainTimer_ release], mainTimer_ = nil;
    
    currentStatus_ = kPaused;
}

- (IBAction)stopButtonClick:(id)sender;
{
    NSArray *keys = [elevators_ allKeys];
    for( NSString *key in keys )
    {
        Elevator *elevator = [elevators_ objectForKey:key];
        [elevator reset];
    }
    
    [btnPassengerCreate1_ setHidden:NO];
    [btnPassengerCreate2_ setHidden:NO];
    [btnPassengerCreate3_ setHidden:NO];
    [btnPassengerCreate4_ setHidden:NO];
    
    [btnEmbarkPassenger1_ setHidden:YES];
    [btnEmbarkPassenger2_ setHidden:YES];
    [btnEmbarkPassenger3_ setHidden:YES];
    [btnEmbarkPassenger4_ setHidden:YES]; 
    
    [mainTimer_ invalidate];
    [mainTimer_ release], mainTimer_ = nil;
    
    currentTickerCount_ = 0;
    [tickerLabel_ setText:INT2STR(currentTickerCount_)];    
    
    currentStatus_ = kStopped;
    
}

- (IBAction)btnClickEmbarkPassenger:(id)sender;
{
    if(currentStatus_ ==kStarted )
    {
        UIButton *btn = (UIButton*)sender;
        int level = [btn tag];
        Passenger *passenger = [passengers_ objectForKey:INT2STR(level)];
        if(passenger)
        {
            BOOL isEmbarked = [self embarkPassenger:passenger];
            if(!isEmbarked){
                [self removePassengerAtLevel:passenger.currentLevel];
            }
            [[btnEmbarkPassenger_ objectForKey:INT2STR(level)] setHidden:YES];
            [[btnPassengerCreate_ objectForKey:INT2STR(level)] setHidden:NO];
        }        
    } else 
    {
        //have to show a dialog
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Elevators Not Started" 
                                                        message:@"Elevators are stopped right now. Please click Start." 
                                                       delegate:nil 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)btnClickPassengerCreate:(id)sender;
{
    if(currentStatus_ == kStarted)
    {
        UIButton *btn = (UIButton*)sender;
        int level = [btn tag];
        int passenger = 0;
        while(true)
        {
            passenger = [Util randBetween:1 and:4];        
            if(passenger != level)
            {
                break;
            }
        }
        if(passenger != 0)
        {
            //got a passenger        
            [[btnEmbarkPassenger_ objectForKey:INT2STR(level)] setHidden:NO];
            [[btnEmbarkPassenger_ objectForKey:INT2STR(level)] setTitle:INT2STR(passenger) forState:UIControlStateNormal];
            [[btnEmbarkPassenger_ objectForKey:INT2STR(level)] setTitle:INT2STR(passenger) forState:UIControlStateSelected];
            [[btnPassengerCreate_ objectForKey:INT2STR(level)] setHidden:YES];
            [self createNewPassenger:level withDestination:passenger];        
        }        
    } else
    {
        //have to show a dialog.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Elevators Not Started" 
                                                        message:@"Elevators are stopped right now. Please click Start." 
                                                       delegate:nil 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];        
    }
}

#pragma mark -
#pragma mark controller methods

- (void)createNewPassenger:(int)level withDestination:(int)destination
{
    //on the said level we will create a new pessenger.
    Passenger *passenger = [[Passenger alloc] init];
    passenger.currentLevel = level;
    passenger.destinationLevel = destination;
    passenger.isLocked = NO;
    
    [passengers_ setObject:passenger forKey:INT2STR(level)];
    safeRelease(passenger);
    
    //check the idle elevators and start any of idle towards the passenger.
    [self checkIdleElevatorsAndMoveToLevel:level];
}

- (void)removePassengerAtLevel:(int)level;
{
    [passengers_ removeObjectForKey:INT2STR(level)];
}

- (BOOL) isPassengerAvailableAtLevel:(int)level
{
    return ([passengers_ objectForKey:INT2STR(level)] != nil);
}

- (void)checkIdleElevatorsAndMoveToLevel:(int)level
{
    NSArray *keys = [elevators_ allKeys];
    for( NSString *key in keys )
    {
        Elevator *elevator = [elevators_ objectForKey:key];
        if(elevator.isIdle && !elevator.isWaiting){
            Passenger *passenger = [passengers_ objectForKey:INT2STR(level)];
            passenger.isLocked = YES;
            [elevator moveElevatorToLevel:level];
            break;
        }
    }
}

- (BOOL)embarkPassenger:(Passenger*)passenger
{
    BOOL isEmbarked = NO;
    NSArray *keys = [elevators_ allKeys];
    for( NSString *key in keys )
    {
        Elevator *elevator = [elevators_ objectForKey:key];
        if(elevator.isWaiting && elevator.currentLevel == passenger.currentLevel){
            //this is the elevator that is waiting for the passenger
            [elevator embarkPassenger:passenger.destinationLevel];
            isEmbarked = YES;
            break;
        }
    }
    return isEmbarked;
}


- (void)checkWaitingPassengersAndMoveElevator:(Elevator*)elevator
{
    NSArray *keys = [passengers_ allKeys];
    for( NSString *key in keys)
    {
        Passenger *passenger = [passengers_ objectForKey:key];
        if(!passenger.isLocked){
            [elevator moveElevatorToLevel:passenger.currentLevel];            
            passenger.isLocked = YES;
            break;
        }
    }
}


- (void)dealloc
{    
    safeRelease(btnPassengerCreate_);
    safeRelease(btnEmbarkPassenger_);
    
    safeRelease(btnPassengerCreate1_);
    safeRelease(btnPassengerCreate2_);
    safeRelease(btnPassengerCreate3_);
    safeRelease(btnPassengerCreate4_);
    
    safeRelease(btnEmbarkPassenger1_);
    safeRelease(btnEmbarkPassenger2_);
    safeRelease(btnEmbarkPassenger3_);
    safeRelease(btnEmbarkPassenger4_);
    
    safeRelease(tickerLabel_);
    
    safeRelease(startButton_);
    safeRelease(pauseButton_);
    safeRelease(stopButton_);
    
    safeRelease(elevators_);
    safeRelease(passengers_);
    
    [super dealloc];
}

@end
