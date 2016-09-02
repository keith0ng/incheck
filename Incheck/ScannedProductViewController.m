//
//  ScannedProductViewController.m
//  Incheck
//
//  Created by John Russel Usi on 9/2/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "ScannedProductViewController.h"

@interface ScannedProductViewController ()

@property (strong, nonatomic) NSString *productCode;

@end

@implementation ScannedProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initWithProduct:(NSString *)productString {

    self.productCode = productString;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.productCodeLabel.text = self.productCode;
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
