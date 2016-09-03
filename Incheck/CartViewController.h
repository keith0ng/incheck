//
//  CartViewController.h
//  Incheck
//
//  Created by John Russel Usi on 9/2/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *cartTableView;
@property (nonatomic, strong) NSMutableArray *cartItemsArray;
@property (nonatomic, assign) CGFloat totalAmount;
@property (nonatomic, assign) NSUInteger totalItems;
@property (weak, nonatomic) IBOutlet UILabel *totalItemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

- (void)clearCart;

@end
