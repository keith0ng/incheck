//
//  CartCell.m
//  Incheck
//
//  Created by John Russel Usi on 9/2/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "CartCell.h"

@implementation CartCell

+ (UITableViewCell *)loadCell {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CartCell" owner:self options:nil];
    return (UITableViewCell *)[nib objectAtIndex:0];
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
