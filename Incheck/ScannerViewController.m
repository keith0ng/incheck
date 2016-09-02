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
#import "ICAPIRequestManager.h"
#import "ProductModel.h"

@interface ScannerViewController ()

@property (strong, nonatomic) IBOutlet UIView *scannerView;
@property (strong, nonatomic) NSMutableArray *productsArray;

@end

@implementation ScannerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.productsArray = [NSMutableArray array];
    
    ICAPIRequestManager *manager = [ICAPIRequestManager sharedManager];
    [manager apiGETProductListRequestWithFinishedBlock:^(NSDictionary *returnParameters, NSError *error)
     {
         if (returnParameters)
         {
//             NSLog(@"Return %@", returnParameters);
             NSArray *products = returnParameters;
             
             for (NSDictionary *productDictionary in products)
             {
                 ProductModel *product = [[ProductModel alloc] initWithDictionary:productDictionary];
                 [self.productsArray addObject:product];
             }
             
             NSLog(@"Products %@", self.productsArray);
         }
         else
         {
             NSLog(@"Error %@", error);
         }
    }];
    
    MTBBarcodeScanner *scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.scannerView];
    [scanner setAllowTapToFocus:YES];    
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            [scanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                [scanner stopScanning];
                NSLog(@"Found code: %@", code.stringValue);
                
                for (ProductModel *product in self.productsArray)
                {
                    if ([product.productCode isEqualToString:code.stringValue])
                    {
                        ScannedProductViewController *scannedView = [[ScannedProductViewController alloc] init];
                        [scannedView initWithProductModel:product];
                        [self presentViewController:scannedView animated:YES completion:nil];
                    }
                }
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
