//
//  ScannedProductViewController.m
//  Incheck
//
//  Created by John Russel Usi on 9/2/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "ScannedProductViewController.h"

@interface ScannedProductViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSString *productCode;

@end

@implementation ScannedProductViewController

- (void)viewDidLoad {
    self.quantityField.delegate = self;
    [super viewDidLoad];
}

- (void)initWithProductModel:(ProductModel *)productModel {
    self.productModel = productModel;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.productNameLabel.text = productModel.productName;
        self.productCodeLabel.text = productModel.productCode;
        self.productPriceLabel.text = [NSString stringWithFormat:@"%.2f", productModel.productPrice];
    });
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGFloat originalPrice = self.productModel.productPrice;
    NSUInteger multiplier = [textField.text integerValue];
    CGFloat multipliedPrice = originalPrice * multiplier;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.productPriceLabel.text = [NSString stringWithFormat:@"%.2f", multipliedPrice];
    });
    
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
