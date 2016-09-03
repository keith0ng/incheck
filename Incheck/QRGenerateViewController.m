//
//  QRGenerateViewController.m
//  Incheck
//
//  Created by John Russel Usi on 9/3/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "QRGenerateViewController.h"
#import "UIImage+MDQRCode.h"
#import "CartViewController.h"

@interface QRGenerateViewController () 

@end

@implementation QRGenerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    if (checkBox.on) {
        [self.doneButton setHidden:NO];
    }
}

- (void)setupQRCodeFromString:(NSString *)qrString withAdminMessage:(NSString *)adminMessage{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *qrImage = [UIImage mdQRCodeForString:qrString size:29 fillColor:[UIColor brownColor]];
        [self.qrImageContainer setImage:qrImage];
        self.urlLabel.text = qrString;
        self.messageLabel.text = adminMessage;
    });
    
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    UITabBarController *parentTabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    CartViewController *cartViewController = [[parentTabBarController viewControllers] objectAtIndex:1];
    [cartViewController clearCart];

}

@end
