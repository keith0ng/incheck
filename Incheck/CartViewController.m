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
#import "RegisterViewController.h"
#import "CheckoutViewController.h"
#import "AppDelegate.h"

@interface CartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *transactionId;

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
//    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell"];
    
//    if (cell == nil) {
        CartCell *cell = [CartCell loadCell];
        cell.productModel = [self.cartItemsArray objectAtIndex:indexPath.row];
        [cell setupCell];
//    }
    
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ProductModel *pModel = [self.cartItemsArray objectAtIndex:indexPath.row];
        self.totalAmount -= pModel.totalPrice;
        self.totalItems -= pModel.productQuantity;
        pModel.totalPrice = pModel.productPerPiece;
        pModel.productQuantity = 1;
        [self.cartItemsArray removeObjectAtIndex:indexPath.row];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.totalItemsLabel.text = [NSString stringWithFormat:@"Items: %ld", self.totalItems];
            self.totalAmountLabel.text = [NSString stringWithFormat:@"Amount: %.2f", self.totalAmount];
            [self.cartTableView reloadData];
        });
    }
}

- (IBAction)checkoutButtonAction:(id)sender
{
    if (([self.cartItemsArray count] == 0 || self.cartItemsArray == nil)) {
        [self showAlertWithTitle:@"Oops!" message:@"Your cart is empty."];
        return;
    }
    
    [self checkoutItems];
}

- (void)checkoutItems
{
    ICPayMayaRequestManager *manager = [ICPayMayaRequestManager sharedManager];
    ICUserModel *user = ((AppDelegate *)[UIApplication sharedApplication].delegate).user;
    
    [manager checkoutWithItems:self.cartItemsArray forUser:user withTotalAmount:self.totalAmount finishedBlock:^(NSDictionary *returnParameters, NSError *error)
     {
         if (returnParameters)
         {
             self.transactionId = [returnParameters objectForKey:@"checkoutId"];
             CheckoutViewController *checkoutViewController = [[CheckoutViewController alloc] init];
             checkoutViewController.checkoutURL = [NSURL URLWithString:[returnParameters objectForKey:@"redirectUrl"]];
             [self presentViewController:checkoutViewController animated:YES completion:nil];
         }
     }];
}

- (void)verifyCheckoutStatus
{
    ICPayMayaRequestManager *manager = [ICPayMayaRequestManager sharedManager];
    
    [manager getCheckoutDetailsWithId:self.transactionId
                        finishedBlock:^(NSDictionary *returnParameters, NSError *error)
    {
        if (returnParameters)
        {
            if ([[returnParameters objectForKey:@"paymentStatus"] isEqualToString:@"PAYMENT_SUCCESS"])
            {
                [self postTransactionToServer];
            }
            else
            {
                NSLog(@"AN Erro Occured, please pay to the cashier instead");
                [self showAlertWithTitle:@"ERROR!" message:@"Payment unsuccessful. Please proceed to the cashier."];
            }
        }
        else
        {
            NSLog(@"Error %@", error);
        }
    }];
}

- (void)postTransactionToServer
{
    ICAPIRequestManager *manager = [ICAPIRequestManager sharedManager];
    [manager apiPOSTTransactionRequestWithPaymentId:self.transactionId items:self.cartItemsArray totalAmount:self.totalAmount finsihedBlock:^(NSDictionary *returnParameters, NSError *error)
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
             NSLog(@"Error %@", error);
         }
     }];
}

- (void)clearCart {
    if (([self.cartItemsArray count] == 0) || (self.cartItemsArray = nil)) {
        [self showAlertWithTitle:@"Oops!" message:@"Your cart is already empty."];
        return;
    }
    for (ProductModel *pModel in self.cartItemsArray) {
        pModel.totalPrice = pModel.productPerPiece;
        pModel.productQuantity = 1;
    }
    self.totalAmount = 0.0;
    self.totalItems = 0;
    [[self cartItemsArray] removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.totalItemsLabel.text = [NSString stringWithFormat:@"Items: %ld", self.totalItems];
        self.totalAmountLabel.text = [NSString stringWithFormat:@"Amount: %.2f", self.totalAmount];
        [self.cartTableView reloadData];
    });
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
