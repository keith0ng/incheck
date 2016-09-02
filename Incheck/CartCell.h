//
//  CartCell.h
//  Incheck
//
//  Created by John Russel Usi on 9/2/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface CartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (nonatomic, strong) ProductModel *productModel;
+ (CartCell *)loadCell;
- (void)setupCell;
@end
