//
//  ForgotPasswordViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 19/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,strong)IBOutlet UIButton *btnOK;
@property(nonatomic,strong)AppApi *api;

@property(nonatomic,strong)IBOutlet CustomTextField *txtEmailID;
-(IBAction)okButtonTapped:(id)sender;

@end
