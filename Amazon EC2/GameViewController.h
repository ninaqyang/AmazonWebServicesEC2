//
//  ViewController.h
//  UIKitDynamics
//
//  Created by Nina Yang on 10/7/15.
//  Copyright (c) 2015 Nina Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GameViewController : UIViewController <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIImageView *circle;
@property (nonatomic, strong) UIImageView *rectangle;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIAttachmentBehavior *attach;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIDynamicItemBehavior *rectangleDynamic;
@property (nonatomic, strong) UIDynamicItemBehavior *circleDynamic;

@property (weak, nonatomic) IBOutlet UILabel *label;

- (IBAction)startGame:(id)sender;
- (IBAction)restartGame:(id)sender;

@end

