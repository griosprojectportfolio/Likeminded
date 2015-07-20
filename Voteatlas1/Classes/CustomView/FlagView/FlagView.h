//
//  FlagView.h
//  Voteatlas1
//
//  Created by GrepRuby on 08/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FlagDelegate <NSObject>

- (void)cancelFlagBtnTapped;
- (void)sendFlag:(NSString *)strFlagStatus;

@end

@interface FlagView : UIView <UITextViewDelegate>{
    UITextView *txtVw;
    UIToolbar *toolbar;
}

@property (unsafe_unretained)id <FlagDelegate>delegate;


@end
