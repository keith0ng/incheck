//
//  RegisterViewController.m
//  Incheck
//
//  Created by John Russel Usi on 9/3/16.
//  Copyright © 2016 kkb. All rights reserved.
//

#import "RegisterViewController.h"
#import "ICUserModel.h"
#import "ICPayMayaRequestManager.h"

@interface RegisterViewController ()

@property (nonatomic, strong) ICUserModel *user;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.user = [[ICUserModel alloc] init];
}

- (void)getDataFromFields
{
    self.user.lastName = self.lastNameField.text;
    self.user.firstName = self.firstNameField.text;
    self.user.middleName = self.middleNameField.text;
    self.user.birthday = self.birthdateField.text;
    self.user.sex = self.sexField.text;
    self.user.phone = self.phoneField.text;
    self.user.email = self.emailField.text;
    self.user.address1 = self.address1Field.text;
    self.user.address2 = self.address2Field.text;
    self.user.city = self.cityField.text;
    self.user.state = self.provinceField.text;
    self.user.zipcode = self.zipCodeField.text;
    self.user.countryCode = self.countryField.text;
}

- (IBAction)registerUser:(id)sender
{
    ICPayMayaRequestManager *manager = [ICPayMayaRequestManager sharedManager];
    [self getDataFromFields];
    [manager createPaymayaUserWithUserModel:self.user finishedBlock:^(NSDictionary *returnParameters, NSError *error)
    {
        if (returnParameters)
        {
            self.user.paymayaId = [returnParameters objectForKey:@"id"];
        }
    }];
}

@end
