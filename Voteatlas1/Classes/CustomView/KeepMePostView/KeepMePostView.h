//
//  KeepMePostView.h
//  Voteatlas1
//
//  Created by GrepRuby on 08/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol keepMePostedDelegate <NSObject>

- (void)cancelBtnTapped;
- (void)sendKeepMePosted:(NSInteger)duration;

@end

@interface KeepMePostView : UIView {

    UIButton *btnDays;
    UIButton *btnweek;
    UIButton *btnMonth;

    NSInteger duration;
}

@property (unsafe_unretained)id <keepMePostedDelegate>delegate;

@end
