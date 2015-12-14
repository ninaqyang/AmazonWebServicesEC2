//
//  ViewController.m
//  UIKitDynamics
//
//  Created by Nina Yang on 10/7/15.
//  Copyright (c) 2015 Nina Yang. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    self.label.hidden = YES;
    [self createShapes];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(drag:)];
    [self.rectangle addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Make Shapes, Animation

- (void)createShapes {
    UIImage *ball = [UIImage imageNamed:@"ball.png"];
    self.circle = [[UIImageView alloc] initWithImage:ball];
    self.circle.frame = CGRectMake(self.view.frame.size.width / 2 - 25, 70, 50, 50);
    self.circle.layer.cornerRadius = 25;
    self.circle.contentMode = UIViewContentModeScaleAspectFill;
    self.rectangle.layer.masksToBounds = YES;
    [self.view addSubview: self.circle];
    
    UIImage *wood = [UIImage imageNamed:@"wood.jpg"];
    self.rectangle = [[UIImageView alloc] initWithImage:wood];
    self.rectangle.frame = CGRectMake(self.view.frame.size.width / 2 - 60, self.view.frame.size.height - 70, 120, 20);
    self.rectangle.layer.cornerRadius = 5;
    self.rectangle.contentMode = UIViewContentModeScaleAspectFill;
    self.rectangle.layer.masksToBounds = YES;
    [self.view addSubview:self.rectangle];
}

- (void)initAnimation {
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[self.circle]];
    [self.animator addBehavior:gravity];
    
    self.collision = [[UICollisionBehavior alloc]initWithItems:@[self.circle, self.rectangle]];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    self.collision.collisionDelegate = self;
    [self.animator addBehavior:self.collision];
    
    self.circleDynamic = [[UIDynamicItemBehavior alloc]initWithItems:@[self.circle]];
    self.circleDynamic.elasticity = 1;
    self.circleDynamic.friction = 0;
    self.circleDynamic.resistance = 0;
    self.circleDynamic.allowsRotation = YES;
    [self.animator addBehavior:self.circleDynamic];
    
    self.rectangleDynamic = [[UIDynamicItemBehavior alloc]initWithItems:@[self.rectangle]];
    self.rectangleDynamic.allowsRotation = NO;
    self.rectangleDynamic.density = 1000;
    self.rectangleDynamic.resistance = 10;
    [self.animator addBehavior:self.rectangleDynamic];

    self.rectangle.userInteractionEnabled = YES;
    
    // collision boundary bottom
    CGPoint leftEdge = CGPointMake(self.view.frame.origin.x, self.view.frame.size.height);
    CGPoint rightEdge = CGPointMake(self.view.frame.size.width, self.view.frame.size.height);
    [self.collision addBoundaryWithIdentifier:@"bottom" fromPoint:leftEdge toPoint:rightEdge];
}

#pragma mark - Gestures, Collisions

-(void)drag:(UIPanGestureRecognizer *)pan {
    if (UIGestureRecognizerStateChanged == pan.state) {
        CGPoint point = [pan translationInView:pan.view];
        pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y);
        [pan setTranslation:CGPointZero inView:pan.view];
        [self.animator updateItemUsingCurrentState:self.rectangle];
    }
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    NSString *boundary = (NSString*)identifier;
    
    if([boundary isEqual:@"bottom"]) {
        NSLog(@"You Lose!");
        self.label.hidden = NO;
        self.circle.hidden = YES;
        self.rectangle.hidden = YES;
    }
}

#pragma mark - Game Mode

- (IBAction)startGame:(id)sender {
    [self initAnimation];
}

- (IBAction)restartGame:(id)sender {
    [self.animator removeAllBehaviors];
    self.attach = nil;
    self.collision = nil;
    self.rectangleDynamic = nil;
    self.circleDynamic = nil;
    
    self.label.hidden = YES;
    self.circle.hidden = NO;
    self.rectangle.hidden = NO;
    
    self.circle.frame = CGRectMake(self.view.frame.size.width / 2 - 25, 70, 50, 50);
    self.rectangle.frame = CGRectMake(self.view.frame.size.width / 2 - 60, self.view.frame.size.height - 70, 120, 20);
}

@end
