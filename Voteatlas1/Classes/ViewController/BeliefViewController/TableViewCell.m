//
//  TableViewCell.m
//  Voteatlas
//
//  Created by GrepRuby1 on 16/12/14.
//  Copyright (c) 2014 Voteatlas. All rights reserved.
//

#import "TableViewCell.h"
#import "HCYoutubeParser.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"

@implementation TableViewCell 
@synthesize delegate;

#define iPhone_6 120

- (void)awakeFromNib {

  self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    [self.customVwOfBtns setFrameOfButtons:0 additionSpace:0];

    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    [self.displayImage addSubview:effectView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setValueInTableVw:(Belief*)belief withVwController:(TableViewController*)vwController forRow:(NSInteger)row withCellWidth:(CGFloat)width withLaguagleId:(NSNumber*)languageId {
        //  self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    if (self.objBelief != nil) {
        self.objBelief = nil;
    }

    self.tag = row;
    self.objBelief = belief;
    btnPlay.hidden = YES;
    self.customVwOfBtns.tag = belief.beliefId;
    [self.customVwOfBtns instantiateAppApi];
    [self.customVwOfBtns assignValuetoButton:belief.dictDisposition];
    self.customVwOfBtns.delegate = self;

    self.lblStatement.numberOfLines = 0;

    NSString *strSuppose = belief.statement;
    CGRect rect =[strSuppose boundingRectWithSize:CGSizeMake((width - 140), 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    if (self.displayImage.image != nil) {
        self.displayImage.image = nil;
    }

    self.lblStatement.numberOfLines = 0;
    if (rect.size.height > 60) {

        self.lblStatement.frame = CGRectMake(self.lblStatement.frame.origin.x, self.lblStatement.frame.origin.y, (width - 140), rect.size.height+5);
        self.lblStatement.text = strSuppose;

        //set image
        self.displayImage.frame = CGRectMake(self.displayImage.frame.origin.x, self.lblStatement.frame.origin.y + self.lblStatement.frame.size.height + 10, width - 35, 175);
    } else {
        self.lblStatement.text = strSuppose;
        self.lblStatement.frame = CGRectMake(self.lblStatement.frame.origin.x, self.lblStatement.frame.origin.y,(width - 140), 63);
        self.displayImage.frame = CGRectMake(self.displayImage.frame.origin.x, self.lblStatement.frame.origin.y+73 , width - 35, 175);
    }

    btnPlay.frame = CGRectMake(self.displayImage.frame.origin.x, self.displayImage.frame.origin.y, self.displayImage.frame.size.width, self.displayImage.frame.size.height - 20);

        // self.imgProfilPic.image = [UIImage imageNamed:@""];

    self.customVwOfBtns.frame = CGRectMake(20, (self.displayImage.frame.size.height + self.displayImage.frame.origin.y) - self.customVwOfBtns.frame.size.height , self.displayImage.frame.size.width,self.customVwOfBtns.frame.size.height);
    self.customVwOfBtns.backgroundColor = [UIColor clearColor];


    effectView.frame = CGRectMake (0, self.displayImage.frame.size.height - self.customVwOfBtns.frame.size.height , self.customVwOfBtns.frame.size.width, self.customVwOfBtns.frame.size.height);

    if (![belief.thumbImage_Url isEqual:[NSNull null]] && belief.thumbImage_Url.length != 0) {
        [self.displayImage sd_setImageWithURL:[NSURL URLWithString:belief.thumbImage_Url] placeholderImage:nil];
        btnPlay.hidden = NO;
        [btnPlay setImage:[UIImage imageNamed:@"play-btn"] forState:UIControlStateNormal];
            // [self.contentView bringSubviewToFront:btnPlay];
        btnPlay.userInteractionEnabled = NO;
        [self.contentView bringSubviewToFront:btnPlay];
    } else if (![belief.imageUrl isEqual:[NSNull class]] && belief.imageUrl.length != 0) {
        [self.displayImage sd_setImageWithURL:[NSURL URLWithString:belief.imageUrl] placeholderImage:nil];
    }

    imgVwDiscloser.frame = CGRectMake(width - 20, imgVwDiscloser.frame.origin.y, 16, 16);
    btnFlag.frame = CGRectMake(width - 80, self.displayImage.frame.origin.y - 27, 30, 25);
    [btnFlag addTarget:self action:@selector(flagBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    btnFlag.backgroundColor = [UIColor setCustomColorOfTextField];
    btnFlag.layer.cornerRadius = 5.0;

    btnTranslation.frame = CGRectMake(width - 45, self.displayImage.frame.origin.y - 27, 30, 25);
    [btnTranslation addTarget:self action:@selector(translateBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    btnTranslation.backgroundColor = [UIColor setCustomColorOfTextField];
    btnTranslation.layer.cornerRadius = 5.0;
    btnTranslation.hidden = NO;

    NSLog(@"%@", self.objBelief.thumbImage_Url);
    if ([belief.languageId isEqualToNumber:languageId]) {
        btnTranslation.hidden = YES;
    }
    btnPlay.tintColor = [UIColor setCustomColorOfTextField];

    if ([self.objBelief.thumbImage_Url isKindOfClass:[NSNull class]] && ![belief.imageUrl isEqual:[NSNull class]]) {
        self.displayImage.image = [UIImage imageNamed:@"download1"];
    }

    if ([self.objBelief.thumbImage_Url isKindOfClass:[NSNull class]]) {
        if (belief.imageUrl.length == 0) {
            self.displayImage.image = [UIImage imageNamed:@"download1"];
        }
    }

    NSString *mediaUrl;
    if (belief.imageUrl.length != 0) {
        mediaUrl = belief.imageUrl;
    } else if (belief.videoUrl.length != 0) {
        mediaUrl = belief.videoUrl;
        return;
    } else if (belief.youtubeUrl.length != 0) {
        mediaUrl = belief.youtubeUrl;
        return;
    }
    [self.contentView bringSubviewToFront:self.customVwOfBtns];

}

- (void)translateBtnTapped {
    if ([self.delegate respondsToSelector:@selector(translatebtnTapped:)]){
        [self.delegate translatebtnTapped:self.objBelief];
    }
}

#pragma mark - Custom Button Delegates
- (void)shareBtnTapped {
    if ([self.delegate respondsToSelector:@selector(sharebtnTapped:)]){
        [self.delegate sharebtnTapped:self.objBelief];
    }
}

- (void)mapBtnTapped {
    if ([self.delegate respondsToSelector:@selector(mapbtnTapped:)]){
        [self.delegate mapbtnTapped:self.objBelief];
    }
}

- (void)keepmePostedBtnTapped {
    if ([self.delegate respondsToSelector:@selector(keepmePostedBtnTapped:withTag:)]){
        [self.delegate keepmePostedBtnTapped:self.objBelief withTag:self.tag];
    }
}

- (void)flagBtnTapped {
    if ([self.delegate respondsToSelector:@selector(flagBtnTapped:)]){
        [self.delegate flagBtnTapped:self.objBelief];
    }
}

- (void)supportBtnTapped {
    if ([self.delegate respondsToSelector:@selector(supportOpposeBtnTapped)]){
        [self.delegate supportOpposeBtnTapped];
    }
}

- (void)opposeBtnTapped {
    if ([self.delegate respondsToSelector:@selector(supportOpposeBtnTapped)]){
        [self.delegate supportOpposeBtnTapped];
    }
}

@end
