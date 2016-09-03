//
//  CartCell.m
//  Incheck
//
//  Created by John Russel Usi on 9/2/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "CartCell.h"

@implementation CartCell

+ (CartCell *)loadCell {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CartCell" owner:self options:nil];
    return (CartCell *)[nib objectAtIndex:0];
}

- (void)setupCell {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.productNameLabel.text = self.productModel.productName;
        self.productPriceLabel.text = [NSString stringWithFormat:@"%.2f", self.productModel.totalPrice];
        self.productQuantityLabel.text = [NSString stringWithFormat:@"x%ld", self.productModel.productQuantity];
    });
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
