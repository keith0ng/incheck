//
//  CartViewController.m
//  Incheck
//
//  Created by John Russel Usi on 9/2/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "CartViewController.h"
#import "CartCell.h"
#import "ScannedProductViewController.h"
#import "ProductModel.h"
#import "ICAPIRequestManager.h"
#import "QRGenerateViewController.h"
#import "ICPayMayaRequestManager.h"
#import "ICUserModel.h"
#import "CheckoutViewController.h"

@interface CartViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CartViewController

- (void)awakeFromNib {
    self.cartItemsArray = [NSMutableArray array];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cartTableView.delegate = self;
    self.cartTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cartTableView reloadData];
    self.totalItemsLabel.text = [NSString stringWithFormat:@"Items: %ld", self.totalItems];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"Amount: %.2f", self.totalAmount];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductModel *productModel = [self.cartItemsArray objectAtIndex:indexPath.row];
    ScannedProductViewController *scannedView = [[ScannedProductViewController alloc] init];
    [scannedView setupForCart:productModel];
    
    [self presentViewController:scannedView animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell"];
    
    if (cell == nil) {
        cell = [CartCell loadCell];
        cell.productModel = [self.cartItemsArray objectAtIndex:indexPath.row];
        [cell setupCell];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cartItemsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (IBAction)checkoutButtonAction:(id)sender {
    
//    ICAPIRequestManager *manager = [ICAPIRequestManager sharedManager];
//    [manager apiPOSTTransactionRequestWithPaymentId:@"123812" items:self.cartItemsArray totalAmount:self.totalAmount finsihedBlock:^(NSDictionary *returnParameters, NSError *error)
//    {
//        if (returnParameters)
//        {
//            NSLog(@"Return %@", returnParameters);
//        }
//        else
//        {
//            NSLog(@"Error %@", error);
//        }
//    }];
    
    ICUserModel *user = [[ICUserModel alloc] initWithDictionary:@{@"firstName": @"Juan",
                        @"middleName": @"dela",
                        @"lastName": @"Cruz",
                        @"birthday": @"1992-10-06",
                        @"sex": @"m",
                        @"contact": @{
                             @"phone": @"+63(2)1234567890",
                             @"email": @"paymayabuyer1@gmail.com"
                         },
                        @"billingAddress": @{
                             @"line1": @"9F Robinsons Cybergate 3",
                             @"line2": @"Pioneer Street",
                             @"city": @"Mandaluyong City",
                             @"state": @"Metro Manila",
                             @"zipCode": @"1002",
                             @"countryCode": @"PH"
    }}];
    ICPayMayaRequestManager *manager = [ICPayMayaRequestManager sharedManager];
    
    [manager checkoutWithItems:self.cartItemsArray forUser:user withTotalAmount:self.totalAmount finishedBlock:^(NSDictionary *returnParameters, NSError *error)
    {
        if (returnParameters)
        {
            NSString *qrUrl = [returnParameters objectForKey:@"url"];
            NSString *transactionMessage = [returnParameters objectForKey:@"message"];
            QRGenerateViewController *qrGenerator = [[QRGenerateViewController alloc] init];
            [qrGenerator setupQRCodeFromString:qrUrl withAdminMessage:transactionMessage];
            
            [self presentViewController:qrGenerator animated:YES completion:nil];
            
            NSLog(@"Return %@", returnParameters);
        }
        else
        {
            CheckoutViewController *checkout = [[CheckoutViewController alloc] init];
            checkout.checkoutURL = [NSURL URLWithString:[returnParameters objectForKey:@"redirectUrl"]];
            [self presentViewController:checkout animated:YES completion:nil];
        }
    }];
}

@end
