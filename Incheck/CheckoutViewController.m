//
//  CheckoutViewController.m
//  Incheck
//
//  Created by Russel Usi on 9/3/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "CheckoutViewController.h"

@interface CheckoutViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CheckoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://10.3.20.50:5000/transaction/confirmation/success"]];
    [request addValue:@"Basic cGstaWFpb0JDMnBiWTZkM0JWUlNlYnNKeGdoU0hlSkRXNG42bmF2STd0WWRyTjo=" forHTTPHeaderField:@"Authorization"];
    [self.webView loadRequest:request];
}

@end
