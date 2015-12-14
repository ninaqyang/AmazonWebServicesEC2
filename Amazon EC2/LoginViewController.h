//
//  LoginViewController.h
//  UIKitDynamics
//
//  Created by Nina Yang on 10/29/15.
//  Copyright © 2015 Nina Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *loginIncorrectLabel;

- (IBAction)enterLoginInfo:(id)sender;
- (void)checkLoginWithRequest;

@end
