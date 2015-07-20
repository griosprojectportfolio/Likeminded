//
//  FlagView.m
//  Voteatlas1
//
//  Created by GrepRuby on 08/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "FlagView.h"

@implementation FlagView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {

    if (self) {

        self = [super initWithFrame:frame];
        [self addKeepMePostView];
    }
    return self;
}

#pragma mark - Method to add view content

- (void)addKeepMePostView {

    UIView *vwBckground = [[UIView alloc]initWithFrame:CGRectMake(10, 40 , self.frame.size.width - 20, 200)];
    vwBckground.backgroundColor = [UIColor whiteColor];
    [self addSubview:vwBckground];

    UILabel *lblKeepMePostHeading = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.frame.size.width - 30, 21)];
    lblKeepMePostHeading.textColor = [UIColor darkGrayColor];
    lblKeepMePostHeading.text = @"Flag Belief";
    lblKeepMePostHeading.font = [UIFont boldSystemFontOfSize:15.0f];
    [vwBckground addSubview:lblKeepMePostHeading];

    UIImageView *imgVwLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, lblKeepMePostHeading.frame.size.height + lblKeepMePostHeading.frame.origin.y + 5 , vwBckground.frame.size.width - 20, 1)];
    imgVwLine1.backgroundColor = [UIColor lightGrayColor];
    [vwBckground addSubview:imgVwLine1];

    UILabel *lblEmailStatusHeading = [[UILabel alloc]initWithFrame:CGRectMake(15, imgVwLine1.frame.size.height + imgVwLine1.frame.origin.y + 5, vwBckground.frame.size.width - 30, 42)];
    lblEmailStatusHeading.numberOfLines = 0;
    lblEmailStatusHeading.textColor = [UIColor darkGrayColor];
    lblEmailStatusHeading.text = @"Reason for flagging this belief (required):";
    [vwBckground addSubview:lblEmailStatusHeading];

    txtVw = [[UITextView alloc]initWithFrame:CGRectMake(15, lblEmailStatusHeading.frame.size.height + lblEmailStatusHeading.frame.origin.y + 5, vwBckground.frame.size.width - 20, 50)];
    txtVw.layer.cornerRadius = 5.0;
    txtVw.delegate = self;
    txtVw.layer.borderWidth = 1.0;
    txtVw.autocorrectionType = NO;
    txtVw.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    [vwBckground addSubview:txtVw];

    toolbar = [[UIToolbar alloc]init];
    if (IS_IPHONE_4_OR_LESS) {
     toolbar.frame = CGRectMake(0, self.frame.size.height - 300, self.frame.size.width, 44);
    } else {
        toolbar.frame = CGRectMake(0, self.frame.size.height - 360, self.frame.size.width, 44);
    }
    [toolbar setHidden:YES];
    toolbar.translucent = NO;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *barBtnDone = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnTapped)];

    [toolbar setItems:[[NSArray alloc] initWithObjects:spacer,barBtnDone,nil]];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [self addSubview:toolbar];

    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame = CGRectMake(vwBckground.frame.size.width - 160, txtVw.frame.size.height + txtVw.frame.origin.y +20, 70, 30);
    [btnSend setTitle:@"Send" forState:UIControlStateNormal];
    btnSend.backgroundColor = [UIColor setCustomSignUpColor];
    [btnSend addTarget:self action:@selector(sendFlagBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [vwBckground addSubview:btnSend];

    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(vwBckground.frame.size.width - 80,  btnSend.frame.origin.y, 70, 30);
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    btnCancel.backgroundColor = [UIColor setCustomSignUpColor];
    [btnCancel addTarget:self action:@selector(hideFlagWithAnimation) forControlEvents:UIControlEventTouchUpInside];
    [vwBckground addSubview:btnCancel];
    [self bringSubviewToFront:toolbar];
}

- (void)doneBtnTapped {

    [self endEditing:YES];
    [toolbar setHidden:YES];
}

#pragma mark - Delegates

- (void)sendFlagBtnTapped {

    if ([self.delegate respondsToSelector:@selector(sendFlag:)]) {
        [self.delegate sendFlag:txtVw.text];
    }
}

- (void)hideFlagWithAnimation {

    if ([self.delegate respondsToSelector:@selector(cancelFlagBtnTapped)]) {
        [self.delegate cancelFlagBtnTapped];
    }
}

#pragma mark - UIText field Delegates
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return [textView resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{

    [toolbar setHidden:NO];

    if (IS_IPHONE_4_OR_LESS) {
        CGRect frame = self.frame;
        frame.origin.y = frame.origin.y-60;
        self.frame = frame;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {

    if (IS_IPHONE_4_OR_LESS) {
        CGRect frame = self.frame;
        frame.origin.y = frame.origin.y+60;
        self.frame = frame;
    }
}

@end
