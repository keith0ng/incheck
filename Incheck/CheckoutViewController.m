//
//  CheckoutViewController.m
//  Incheck
//
//  Created by Russel Usi on 9/3/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "CheckoutViewController.h"
#import "CartViewController.h"

@interface CheckoutViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CheckoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.checkoutURL];
    [request addValue:@"Basic cGstaWFpb0JDMnBiWTZkM0JWUlNlYnNKeGdoU0hlSkRXNG42bmF2STd0WWRyTjo=" forHTTPHeaderField:@"Authorization"];
    [self.webView loadRequest:request];
}

- (IBAction)cancelButtonAction:(id)sender
{
    UITabBarController *parentTabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    CartViewController *cartViewController = [[parentTabBarController viewControllers] objectAtIndex:1];
    [cartViewController verifyCheckoutStatus];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
