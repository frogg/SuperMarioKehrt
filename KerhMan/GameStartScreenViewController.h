//
//  GameStartScreenViewController.h
//  KerhMan
//
//  Created by Frederik Riedel on 05/11/2016.
//  Copyright © 2016 Frogg GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface GameStartScreenViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *selectLuigi;
@property (strong, nonatomic) IBOutlet UIButton *selectMario;
@property (strong, nonatomic) IBOutlet UIButton *selectPeach;

@end
