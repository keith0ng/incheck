//
//  ScannedProductViewController.h
//  Incheck
//
//  Created by John Russel Usi on 9/2/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScannedProductViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *quantityField;

- (void)initWithProduct:(NSString *)productString;

@end
