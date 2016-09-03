//
//  AppDelegate.h
//  Incheck
//
//  Created by John Russel Usi on 9/2/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICUserModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ICUserModel *user;

@end

