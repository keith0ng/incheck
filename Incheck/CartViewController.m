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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

@end
