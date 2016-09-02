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
@property (nonatomic, strong) NSMutableArray *cartItemsArray;
@end

@implementation CartViewController

- (void)viewDidLoad {
    self.cartTableView.delegate = self;
    self.cartTableView.dataSource = self;
    
    NSDictionary *products = @{@"name": @"ridges",
                               @"barcode": @"4800194115421",
                               @"category": @"Chips",
                               @"price": @"25"};
    
    ProductModel *productModel = [[ProductModel alloc] initWithDictionary:products];
    self.cartItemsArray = [NSMutableArray array];
    
    [self.cartItemsArray addObject:productModel];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductModel *model = [self.cartItemsArray objectAtIndex:indexPath.row];
    ScannedProductViewController *scannedView = [[ScannedProductViewController alloc] init];
    [scannedView initWithProductModel:model];
//    scannedView.productModel = [self.cartItemsArray objectAtIndex:indexPath.row];
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
