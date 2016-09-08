//
//  QRGenerateViewController.h
//  Incheck
//
//  Created by John Russel Usi on 9/3/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"

@interface QRGenerateViewController : UIViewController <BEMCheckBoxDelegate>

- (void)setupQRCodeFromString:(NSString *)qrString withAdminMessage:(NSString *)adminMessage;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageContainer;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UIView *doneButton;

@end
