//
//  LoginViewController.m
//  UIKitDynamics
//
//  Created by Nina Yang on 10/29/15.
//  Copyright © 2015 Nina Yang. All rights reserved.
//

#import "LoginViewController.h"
#import "GameViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginIncorrectLabel.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.password.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"game"]) {
        NSLog(@"Pushing to game view controller");
    }
}

#pragma mark - Login Check

- (IBAction)enterLoginInfo:(id)sender {
    [self checkLoginWithRequest];
}
     
- (void)checkLoginWithRequest {
    NSURLSession *checkLoginSession = [NSURLSession sharedSession];
    NSString *url = [NSString stringWithFormat:@"loginCheckURL"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    
    NSString *loginInfo = [NSString stringWithFormat:@"username=%@&password=%@", self.username.text, self.password.text];
    NSData *data = [loginInfo dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    
    NSURLSessionUploadTask *uploadTask = [checkLoginSession uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", response);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (!error) {
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                if (httpResp.statusCode == 200) {
                    NSString *responseString = [[response valueForKey:@"URL"]absoluteString];
                    NSLog(@"%@", responseString);
                
                    if ([responseString isEqualToString:@"loginSuccessfulURL"]) {
                        NSLog(@"Login info correct!");
                        self.loginIncorrectLabel.hidden = YES;
                        [self performSegueWithIdentifier:@"game" sender:nil];
                    }
                    else if ([responseString isEqualToString:@"loginFailedURL"]) {
                        NSLog(@"Login info incorrect");
                        self.loginIncorrectLabel.hidden = NO;
                    }
                }
                else {
                    NSLog(@"Error due to status code: %li", (long)httpResp.statusCode);
                }
            }
            else {
                NSLog(@"Error: %@", error);
            }
        });
    }];
    
    [uploadTask resume];
}

@end
