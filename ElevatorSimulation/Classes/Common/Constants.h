//
//  Constants.h
//  ElevatorSimulation
//
//  Created by Shan Ul Haq on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//min and max levels
#define MIN_LEVEL 1
#define MAX_LEVEL 4

//ticker interval in seconds
#define TICKER_INTERVAL 5

//convert int value to string
#define INT2STR(val) [NSString stringWithFormat:@"%i", val]

//used for safe release of an object
#define safeRelease(val) if(val){ [val release], val = nil; }

typedef enum{
    kDirectionUp    = 1,
    kDirectionDown  = 2,
    kDirectionNone  = 3
} kElevatorDirection;

typedef enum{
    kStarted    = 1,
    kPaused     = 2,
    kStopped    = 3
} kElevatorsStatus;