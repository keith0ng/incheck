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

@interface CartViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CartViewController

- (void)viewDidLoad {
    self.cartTableView.delegate = self;
    self.cartTableView.dataSource = self;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScannedProductViewController *scannedView = [[ScannedProductViewController alloc] init];
    [scannedView initWithProduct:@"1234"];
    [self presentViewController:scannedView animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell"];
    
    if (cell == nil) {
        cell = [CartCell loadCell];
        [cell setTintColor:[UIColor whiteColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

@end
