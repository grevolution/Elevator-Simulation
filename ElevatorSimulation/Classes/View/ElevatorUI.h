//
//  ElevatorUI.h
//  ElevatorSimulation
//
//  Created by Shan Ul Haq on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElevatorDelegate.h"

@class ElevatorsUIController;
@class Elevator;

@interface ElevatorUI : UIView<ElevatorDelegate>
{
    IBOutlet UIView *elevatorView_;
    IBOutlet UILabel *passengerLabel_;
    IBOutlet UIImageView *directionView_;
    IBOutlet UILabel *statusLabel_;
    ElevatorsUIController *parentRef_;
    
}

@property(nonatomic, retain) UIView *elevatorView;
@property(nonatomic, retain) UILabel *passengerLabel;
@property(nonatomic, retain) UIImageView *directionView;

- (id)initWithParent:(ElevatorsUIController*)parent;
- (void)updateUI:(Elevator*)elevator;

@end
