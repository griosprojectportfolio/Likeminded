//
//  KeepMePostView.m
//  Voteatlas1
//
//  Created by GrepRuby on 08/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "KeepMePostView.h"

@implementation KeepMePostView

- (id)initWithFrame:(CGRect)frame {

    if (self) {

        self = [super initWithFrame:frame];
        [self addKeepMePostView];
    }
    return self;
}

#pragma mark - Method to add view content
- (void)addKeepMePostView {

    UIView *vwBckground = [[UIView alloc]initWithFrame:CGRectMake(10, 40 , self.frame.size.width - 20, 250)];
    vwBckground.backgroundColor = [UIColor whiteColor];
    [self addSubview:vwBckground];

    UILabel *lblKeepMePostHeading = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.frame.size.width - 20, 21)];
    lblKeepMePostHeading.textColor = [UIColor darkGrayColor];
    lblKeepMePostHeading.text = @"Keep Me Posted";
    lblKeepMePostHeading.font = [UIFont boldSystemFontOfSize:15.0f];
    [vwBckground addSubview:lblKeepMePostHeading];

    UIImageView *imgVwLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, lblKeepMePostHeading.frame.size.height + lblKeepMePostHeading.frame.origin.y + 5 , vwBckground.frame.size.width - 20, 1)];
    imgVwLine1.backgroundColor = [UIColor lightGrayColor];
    [vwBckground addSubview:imgVwLine1];

    UILabel *lblEmailStatusHeading = [[UILabel alloc]initWithFrame:CGRectMake(15, imgVwLine1.frame.size.height + imgVwLine1.frame.origin.y + 5, vwBckground.frame.size.width - 30, 21)];
    lblEmailStatusHeading.textColor = [UIColor darkGrayColor];
    lblEmailStatusHeading.text = @"E-mail me status every:";
    lblEmailStatusHeading.font = [UIFont systemFontOfSize:13.0f];
    [vwBckground addSubview:lblEmailStatusHeading];

    int yAxis = lblEmailStatusHeading.frame.size.height + lblEmailStatusHeading.frame.origin.y + 5;
    btnDays = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDays.frame = CGRectMake(15, yAxis, 22, 22);
    btnDays.tag = 1;
    [btnDays addTarget:self action:@selector(radioBtnOfKepMePosted:) forControlEvents:UIControlEventTouchUpInside];
    [btnDays setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
    [vwBckground addSubview:btnDays];

    UILabel *lblDays = [[UILabel alloc]initWithFrame:CGRectMake(btnDays.frame.origin.x + btnDays.frame.size.width + 5, btnDays.frame.origin.y, 200, 22)];
    lblDays.textColor = [UIColor darkGrayColor];
    lblDays.text = @"Day";
    lblDays.font = [UIFont systemFontOfSize:13.0f];
    [vwBckground addSubview:lblDays];

    btnweek = [UIButton buttonWithType:UIButtonTypeCustom];
    btnweek.frame = CGRectMake(15, yAxis+35, 22, 22);
    [btnweek addTarget:self action:@selector(radioBtnOfKepMePosted:) forControlEvents:UIControlEventTouchUpInside];
    btnweek.tag = 2;
    [btnweek setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
    [vwBckground addSubview:btnweek];

    UILabel *lblWeek = [[UILabel alloc]initWithFrame:CGRectMake(btnweek.frame.origin.x + btnweek.frame.size.width + 5, btnweek.frame.origin.y, 200, 22)];
    lblWeek.textColor = [UIColor darkGrayColor];
    lblWeek.text = @"Week (on Mondays)";
    lblWeek.font = [UIFont systemFontOfSize:13.0f];
    [vwBckground addSubview:lblWeek];

    btnMonth = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMonth.frame = CGRectMake(15, yAxis+70, 22, 22);
    btnMonth.tag = 3;
    [btnMonth addTarget:self action:@selector(radioBtnOfKepMePosted:) forControlEvents:UIControlEventTouchUpInside];
    [btnMonth setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
    [vwBckground addSubview:btnMonth];

    UILabel *lblMonth = [[UILabel alloc]initWithFrame:CGRectMake(btnMonth.frame.origin.x + btnMonth.frame.size.width + 5, btnMonth.frame.origin.y, 200, 22)];
    lblMonth.textColor = [UIColor darkGrayColor];
    lblMonth.text = @"Month (the 1st of every Month)";
    lblMonth.font = [UIFont systemFontOfSize:13.0f];
    [vwBckground addSubview:lblMonth];

    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame = CGRectMake(vwBckground.frame.size.width - 160, btnMonth.frame.size.height + btnMonth.frame.origin.y +20, 70, 30);
    [btnSend setTitle:@"send" forState:UIControlStateNormal];
    btnSend.backgroundColor = [UIColor setCustomSignUpColor];
    [btnSend addTarget:self action:@selector(sendKeepMePostedBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [vwBckground addSubview:btnSend];

    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(vwBckground.frame.size.width - 80,  btnSend.frame.origin.y, 70, 30);
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    btnCancel.backgroundColor = [UIColor setCustomSignUpColor];
    [btnCancel addTarget:self action:@selector(hideKeepMePostViewWithAnimation) forControlEvents:UIControlEventTouchUpInside];
    [vwBckground addSubview:btnCancel];
}

#pragma mark - Radio btn tapped
- (void)radioBtnOfKepMePosted:(id)sender {
    UIButton*btn = (UIButton*)sender;
    duration = btn.tag;

    switch (duration) {
        case 1:
            [btnDays setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
            [btnweek setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
            [btnMonth setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
            break;
        case 2:
            [btnDays setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
            [btnweek setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
            [btnMonth setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
            break;
        case 3:
            [btnDays setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
            [btnweek setImage:[UIImage imageNamed:@"radio_unselected"] forState:UIControlStateNormal];
            [btnMonth setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateNormal];
            break;

        default:
            break;
    }
}

#pragma mark - Delegates
- (void)sendKeepMePostedBtnTapped {
    if ([self.delegate respondsToSelector:@selector(sendKeepMePosted:)]) {
        [self.delegate sendKeepMePosted:duration];
    }
}

- (void)hideKeepMePostViewWithAnimation {
    if ([self.delegate respondsToSelector:@selector(cancelBtnTapped)]) {
        [self.delegate cancelBtnTapped];
    }
}

@end
