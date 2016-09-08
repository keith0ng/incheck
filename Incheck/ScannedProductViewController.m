//
//  ScannedProductViewController.m
//  Incheck
//
//  Created by John Russel Usi on 9/2/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "ScannedProductViewController.h"
#import "CartViewController.h"

@interface ScannedProductViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *addToCartButton;
@property (weak, nonatomic) IBOutlet UIView *updateItemButton;
@property (weak, nonatomic) IBOutlet UIView *cancelAddButton;
@property (weak, nonatomic) IBOutlet UIView *cancelUpdateButton;

@property (strong, nonatomic) NSString *productCode;

@end

@implementation ScannedProductViewController

- (void)viewDidLoad {
    self.quantityField.delegate = self;
    [super viewDidLoad];
}

- (void)setupForScanner:(ProductModel *)productModel {
    self.productModel = productModel;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cancelUpdateButton setHidden:YES];
        [self.cancelAddButton setHidden:NO];
        self.quantityField.text = [NSString stringWithFormat:@"%ld", productModel.productQuantity];
        self.productNameLabel.text = productModel.productName;
        self.productCodeLabel.text = productModel.productCode;
        self.productPriceLabel.text = [NSString stringWithFormat:@"%.2f", productModel.totalPrice];
    });
}

- (void)setupForCart:(ProductModel *)productModel {
    self.productModel = productModel;
    
    UITabBarController *parentTabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    CartViewController *cartViewController = [[parentTabBarController viewControllers] objectAtIndex:1];
    
    cartViewController.totalItems -= productModel.productQuantity;
    cartViewController.totalAmount -= productModel.totalPrice;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cancelUpdateButton setHidden:NO];
        [self.cancelAddButton setHidden:YES];
        [self.addToCartButton setHidden:YES];
        [self.updateItemButton setHidden:NO];
        self.quantityField.text = [NSString stringWithFormat:@"%ld", productModel.productQuantity];
        self.productNameLabel.text = productModel.productName;
        self.productCodeLabel.text = productModel.productCode;
        self.productPriceLabel.text = [NSString stringWithFormat:@"%.2f", productModel.totalPrice];
    });
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSUInteger multiplier = [textField.text integerValue];
    CGFloat multipliedPrice = self.productModel.productPerPiece * multiplier;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.productPriceLabel.text = [NSString stringWithFormat:@"%.2f", multipliedPrice];
    });
    self.productModel.productQuantity = [self.quantityField.text integerValue];
    self.productModel.totalPrice = multipliedPrice;
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissViewWithUpdate:(id)sender {
    UITabBarController *parentTabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    CartViewController *cartViewController = [[parentTabBarController viewControllers] objectAtIndex:1];
    cartViewController.totalAmount += self.productModel.totalPrice;
    cartViewController.totalItems += self.productModel.productQuantity;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addProductToCart:(id)sender {
    UITabBarController *parentTabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    CartViewController *cartViewController = [[parentTabBarController viewControllers] objectAtIndex:1];
    cartViewController.totalAmount += self.productModel.totalPrice;
    cartViewController.totalItems += self.productModel.productQuantity;
    [cartViewController.cartItemsArray addObject:self.productModel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)updateProduct:(id)sender {
    UITabBarController *parentTabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    CartViewController *cartViewController = [[parentTabBarController viewControllers] objectAtIndex:1];
    cartViewController.totalAmount += self.productModel.totalPrice;
    cartViewController.totalItems += self.productModel.productQuantity;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
