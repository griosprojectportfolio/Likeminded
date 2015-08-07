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
  if (IS_IPHONE_6 || IS_IPHONE_6P) {
    [self.customVwOfBtns setFrameOfButtons:20 additionSpace:20];
  } else {
    [self.customVwOfBtns setFrameOfButtons:0 additionSpace:0];
  }

    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.contentView addSubview:effectView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setValueInTableVw:(Belief*)belief withVwController:(TableViewController*)vwController forRow:(NSInteger)row withCellWidth:(CGFloat)width withLaguagleId:(NSNumber*)languageId {

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

    [self setCordinateOfObject:belief withScreenWidth:width];
    [self.btnProfilPic addTarget:self action:@selector(profileBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    if (self.imgProfilPic.image != nil) {
      self.imgProfilPic.image = nil;
    }
    self.imgProfilPic.image = [UIImage imageNamed:@"user-selected"];

    if (belief.isShowAuther == YES) {
      if (![belief.profileImg isKindOfClass:[NSNull class]] && belief.profileImg != nil) {
        [self setProfileImage:belief.profileImg];
      }
    } else {
      self.imgProfilPic.image = [UIImage imageNamed:@"user-selected"];
    }
    if (belief.hasVideo == YES || belief.hasYouTubeUrl == YES) {
        if (![belief.thumbImage_Url isEqual:[NSNull null]] && belief.thumbImage_Url.length != 0) {
            [self.displayImage sd_setImageWithURL:[NSURL URLWithString:belief.thumbImage_Url] placeholderImage:nil];
        }
        btnPlay.hidden = NO;
        [btnPlay setImage:[UIImage imageNamed:@"play-btn"] forState:UIControlStateNormal];
        [self.contentView bringSubviewToFront:btnPlay];
    } else if (![belief.imageUrl isEqual:[NSNull class]] && belief.imageUrl.length != 0) {
        //btnPlay.hidden = NO;
      [self.displayImage sd_setImageWithURL:[NSURL URLWithString:belief.imageUrl] placeholderImage:nil];
    }

    [btnPlay addTarget:self action:@selector(videoBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    btnDiscloser.frame = CGRectMake(width - 30, btnDiscloser.frame.origin.y, 30, 40);
    [btnDiscloser addTarget:self action:@selector(navigateToCommentBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    btnFlag.hidden = YES;

    btnTranslation.frame = CGRectMake(width - 50, self.displayImage.frame.origin.y - 27, 30,25);
    [btnTranslation addTarget:self action:@selector(translateBtnTapped) forControlEvents:UIControlEventTouchUpInside];
     btnTranslation.backgroundColor = [UIColor setCustomColorOfTextField];
//   // [btnTranslation setImage:[UIImage imageNamed:@"10"] forState:UIControlStateNormal];
//    [btnTranslation setBackgroundImage: [UIImage imageNamed:@"10"]forState:UIControlStateNormal];
    btnTranslation.layer.cornerRadius = 5.0;
    btnTranslation.hidden = NO;

    if ([belief.languageId isEqualToNumber:languageId]) {
        btnTranslation.hidden = YES;
    }else{
      btnTranslation.hidden = NO;
    }
    btnPlay.tintColor = [UIColor setCustomColorOfTextField];
    if ([self.objBelief.thumbImage_Url isKindOfClass:[NSNull class]] && ![belief.imageUrl isEqual:[NSNull class]]) {
        self.displayImage.image = [UIImage imageNamed:@"video_thumb"];
    }
 
  //********Sagar*************
  if(self.objBelief.videoUrl.length == 0 && self.objBelief.youtubeUrl.length == 0){
    
  if(self.objBelief.imageUrl.length == 0){
    self.imgViewContent.hidden = false;
   self.imgViewContent.image = [UIImage imageNamed:@"no_image"];
  }else{
    self.imgViewContent.hidden = false;
    [self.imgViewContent sd_setImageWithURL:[NSURL URLWithString:self.objBelief.imageUrl] placeholderImage:nil];
  }
  }else{
    self.imgViewContent.hidden = true;
  }
  //***********

    if ([self.objBelief.thumbImage_Url isKindOfClass:[NSNull class]]) {
        if (belief.imageUrl.length == 0) {
            self.displayImage.image = [UIImage imageNamed:@"video_thumb"];
          
        }
    }

    if (belief.imageUrl.length != 0) {
    } else if (belief.videoUrl.length != 0) {
        return;
    } else if (belief.youtubeUrl.length != 0) {
        return;
    }
    [self.contentView bringSubviewToFront:self.customVwOfBtns];
}

- (void)setCordinateOfObject:(Belief*)belief withScreenWidth:(CGFloat)width {

    NSString *strStatement = [belief.statement stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGRect rect =[strStatement boundingRectWithSize:CGSizeMake((width - 140), 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    if (self.displayImage.image != nil) {
        self.displayImage.image = nil;
    }

    btnLink.hidden = YES;

    self.lblStatement.numberOfLines = 0;
    CGFloat yAxis;

    [self.contentView bringSubviewToFront:btnLink];
    [btnLink addTarget:self action:@selector(linkBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    if (rect.size.height > 60) {

        self.lblStatement.frame = CGRectMake(self.lblStatement.frame.origin.x, self.lblStatement.frame.origin.y, (width - 140), rect.size.height+5);
        self.lblStatement.text = strStatement;
        yAxis = self.lblStatement.frame.origin.y + self.lblStatement.frame.size.height;

        if (belief.weblink.length != 0) {
            CGRect rectLink = [ConstantClass sizeOfString:belief.weblink withSize:CGSizeMake(width - 140, 100)];
            lblLink.frame = CGRectMake(self.lblStatement.frame.origin.x, yAxis + 2 , width - 140, rectLink.size.height);
            yAxis = lblLink.frame.origin.y + lblLink.frame.size.height;
            lblLink.hidden = NO;
            btnLink.frame = CGRectMake(lblLink.frame.origin.x, lblLink.frame.origin.y , lblLink.frame.size.width, rectLink.size.height+5);
            btnLink.hidden = NO;
        }
            //set image
        self.displayImage.frame = CGRectMake(self.displayImage.frame.origin.x, yAxis + 10, width - 35, 175);
    } else {

        self.lblStatement.text = strStatement;
        CGRect rectLink = [ConstantClass sizeOfString:strStatement withSize:CGSizeMake(width - 140, 200)];
        self.lblStatement.frame = CGRectMake(self.lblStatement.frame.origin.x, self.lblStatement.frame.origin.y,(width - 140), rectLink.size.height);
        yAxis = self.lblStatement.frame.origin.y + self.lblStatement.frame.size.height;

        if (belief.weblink.length != 0) {
            CGRect rectLink = [ConstantClass sizeOfString:belief.weblink withSize:CGSizeMake(width - 140, 100)];
            lblLink.frame = CGRectMake(self.lblStatement.frame.origin.x, yAxis + 5 , width - 140, rectLink.size.height);
            lblLink.hidden = NO;
            yAxis = lblLink.frame.origin.y + lblLink.frame.size.height;
            btnLink.frame = CGRectMake(lblLink.frame.origin.x, lblLink.frame.origin.y , lblLink.frame.size.width, rectLink.size.height+5);
            btnLink.hidden = NO;
        }
        if (yAxis > self.lblStatement.frame.origin.y+73){
        } else {
            yAxis = self.lblStatement.frame.origin.y+73;
        }
        self.displayImage.frame = CGRectMake(self.displayImage.frame.origin.x, yAxis , width - 35, 175);
    }

    lblLink.text = belief.weblink;
    btnPlay.frame = CGRectMake(self.displayImage.frame.origin.x, self.displayImage.frame.origin.y, self.displayImage.frame.size.width, self.displayImage.frame.size.height - 40);

    effectView.frame = CGRectMake (10, (self.displayImage.frame.size.height + self.displayImage.frame.origin.y)+1, self.displayImage.frame.size.width, self.customVwOfBtns.frame.size.height);
    self.customVwOfBtns.frame = CGRectMake(20, (self.displayImage.frame.size.height + self.displayImage.frame.origin.y)+1 , self.displayImage.frame.size.width,self.customVwOfBtns.frame.size.height);
    self.customVwOfBtns.backgroundColor = [UIColor clearColor];
    [self.contentView bringSubviewToFront:self.customVwOfBtns];

    lblLine.frame = CGRectMake(0, (self.customVwOfBtns.frame.size.height + self.customVwOfBtns.frame.origin.y) + 3, width, 2);
    lblLine.backgroundColor = [UIColor setCustomColorOfTextField];
}

- (void)setProfileImage:(NSString *)profileImg {

  dispatch_queue_t postImageQueue = dispatch_queue_create("Download image", nil);
  dispatch_async(postImageQueue, ^{
    dispatch_async(dispatch_get_main_queue(), ^{
      UIImageView *imgVw = [[UIImageView alloc]init];
      [imgVw sd_setImageWithURL:[NSURL URLWithString:profileImg] placeholderImage:nil];
      self.imgProfilPic.image = [ConstantClass maskImage:imgVw.image withMask:[UIImage imageNamed:@"mask.png"]];;
    });
  });
}

-(void)alertMassegeBtns{
  [self.delegate alertMassegeBtn];
}

- (void)profileBtnTapped:(id)sender {
  
    if ([self.delegate respondsToSelector:@selector(profileBtnTapped:)]){
        [self.delegate profileBtnTapped:self.objBelief];
    }
  
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
  
    if ([self.delegate respondsToSelector:@selector(mapbtnTapped:withCellTag:)]){
        [self.delegate mapbtnTapped:self.objBelief withCellTag:self.tag];
    }
  
}

- (void)keepmePostedBtnTapped {
  
    if ([self.delegate respondsToSelector:@selector(keepmePostedBtnTapped:withTag:)]){
        [self.delegate keepmePostedBtnTapped:self.objBelief withTag:self.tag];
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

- (void)videoBtnTapped {
    if ([self.delegate respondsToSelector:@selector(videoBtnTapped:)]){
        [self.delegate videoBtnTapped:self.objBelief];
    }
  }

- (void)navigateToCommentBtnTapped {
  
    if ([self.delegate respondsToSelector:@selector(navigateToCommentBtnTapped:)]){
        [self.delegate navigateToCommentBtnTapped:self.objBelief];
    }
  
}

- (void)fileItBtnTapped {
  
  if ([self.delegate respondsToSelector:@selector(fileItBtnTapped:)]){
    [self.delegate fileItBtnTapped:self.tag];
  }
  
}

- (void)linkBtnTapped {
  
  if ([self.delegate respondsToSelector:@selector(linkBtnTapped:)]){
    [self.delegate linkBtnTapped:self.objBelief];
  }
  
}

- (void)flageBtnTapped:(id)sender {

}

@end
