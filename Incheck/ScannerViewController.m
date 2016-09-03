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
#import "CartViewController.h"
@interface ScannerViewController ()

@property (strong, nonatomic) MTBBarcodeScanner *barcodeScanner;
@property (strong, nonatomic) IBOutlet UIView *scannerView;
@property (strong, nonatomic) NSMutableArray *productsArray;
//@property (strong, nonatomic)

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
    
    self.barcodeScanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.scannerView];
    [self.barcodeScanner setAllowTapToFocus:YES];
//    [self restartScanner];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self restartScanner];
}

- (void)restartScanner {
    __block BOOL didFoundItem = NO;
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            [self.barcodeScanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                [self.barcodeScanner stopScanning];
                NSLog(@"Found code: %@", code.stringValue);
                
                for (ProductModel *product in self.productsArray)
                {
                    if ([product.productCode isEqualToString:code.stringValue])
                    {
                        didFoundItem = YES;
                        ScannedProductViewController *scannedView = [[ScannedProductViewController alloc] init];
                        
                        UITabBarController *parentTabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                        CartViewController *cartViewController = [[parentTabBarController viewControllers] objectAtIndex:1];

                        if (![cartViewController.cartItemsArray containsObject:product])
                        {
                            [scannedView setupForScanner:product];
                        }
                        else
                        {
                            [scannedView setupForCart:product];
                        }
                        
                        
                        [self presentViewController:scannedView animated:YES completion:nil];
                    }
                }
                
                if (didFoundItem == NO)
                {
//                    [self showAlertWithTitle:@"Error!" message:@"Item not found!"];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ooops!" message:@"Item not found!" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self restartScanner];
                    }];
                    
                    [alertController addAction:okayAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
            
        } else {
            // The user denied access to the camera
        }
    }];

}

- (void)showAlertWithTitle:(NSString *)titleString message:(NSString *)messageString {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleString
                                                    message:messageString
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
