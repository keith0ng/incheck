//
//  ScannerViewController.m
//  Incheck
//
//  Created by John Russel Usi on 9/2/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "ScannerViewController.h"
#import "ScannedProductViewController.h"
#import "MTBBarcodeScanner.h"

@interface ScannerViewController ()
@property (strong, nonatomic) IBOutlet UIView *scannerView;

@end

@implementation ScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MTBBarcodeScanner *scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.scannerView];
    [scanner setAllowTapToFocus:YES];    
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            [scanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                [scanner stopScanning];
                NSLog(@"Found code: %@", code.stringValue);
                
                
                ScannedProductViewController *scannedView = [[ScannedProductViewController alloc] init];
//                [scannedView initWithProductModel:code.stringValue];
                [self presentViewController:scannedView animated:YES completion:nil];
                
            }];
            
        } else {
            // The user denied access to the camera
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
