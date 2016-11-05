//
//  AppDelegate.h
//  KerhMan
//
//  Created by Frederik Riedel on 04/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kehrmaschine.h"
#import "KerhMan-Swift.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property Kehrmaschine* kehrmaschine;
@property SSH* ssh;
@end

