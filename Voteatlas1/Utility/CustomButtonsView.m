//
//  CustomButtonsView.m
//  Voteatlas1
//
//  Created by GrepRuby on 25/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "CustomButtonsView.h"

@implementation CustomButtonsView
@synthesize delegate, btnShare, imgVwlockSupport, btnNotes, isDetailVw;

- (void)instantiateAppApi {
    self.api = [AppApi sharedClient];
}

- (void)setFrameOfButtons:(NSInteger)extraSpace additionSpace:(NSInteger)space {

    if(IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
        btnLike.frame = CGRectMake(5,  btnLike.frame.origin.y,  btnLike.frame.size.width,  btnLike.frame.size.height);
        btnUnlike.frame = CGRectMake(45+extraSpace,  btnUnlike.frame.origin.y,  btnUnlike.frame.size.width,  btnUnlike.frame.size.height);
        btnArchive.frame = CGRectMake( 89+extraSpace+space,  btnArchive.frame.origin.y,  btnArchive.frame.size.width,  btnArchive.frame.size.height);

        btnShare.frame = CGRectMake( 134+extraSpace+space,  btnShare.frame.origin.y,  btnShare.frame.size.width,  btnShare.frame.size.height);
        btnMap.frame = CGRectMake(175+extraSpace,  btnMap.frame.origin.y,  btnMap.frame.size.width,  btnMap.frame.size.height);
        self.btnNotes.frame = CGRectMake(223,  self.btnNotes.frame.origin.y,  self.btnNotes.frame.size.width,  self.btnNotes.frame.size.height);

        imgVwlockOppose.frame = CGRectMake(60+extraSpace+space,  imgVwlockOppose.frame.origin.y,  imgVwlockOppose.frame.size.width,  imgVwlockOppose.frame.size.height);
        int xAxis = 0;
        if (isDetailVw == YES) {
            xAxis = 11;
        }
        imgVwlockSupport.frame = CGRectMake(xAxis,  imgVwlockSupport.frame.origin.y,  imgVwlockSupport.frame.size.width,  imgVwlockSupport.frame.size.height);
    }
}

- (void)assignValuetoButton:(NSDictionary *)dictDiscompose {

    [btnArchive setImage:[UIImage imageNamed:@"7_unselect.png"] forState:UIControlStateNormal];
    [btnUnlike setImage:[UIImage imageNamed:@"5_unselect.png"]forState:UIControlStateNormal];
    [btnLike setImage:[UIImage imageNamed:@"4_unselect.png"]forState:UIControlStateNormal];
    imgVwlockOppose.hidden = YES;
    imgVwlockSupport.hidden = YES;

    if (dictDiscompose.count == 0) {
        return;
    }

    if (![[dictDiscompose valueForKey:@"is_filed_in"] isKindOfClass:[NSNull class]]) {
        if ([[dictDiscompose valueForKey:@"is_filed_in"]boolValue] == 1) { //to show file it or not
            [btnArchive setImage:[UIImage imageNamed:@"6.png"] forState:UIControlStateNormal];
        }
    } else {
        [btnArchive setImage:[UIImage imageNamed:@"6_unselect.png"] forState:UIControlStateNormal];
    }

    BOOL isSuppose;
    if (![[dictDiscompose valueForKey:@"is_supported"] isKindOfClass:[NSNull class]]) {
         isSuppose = [[dictDiscompose valueForKey:@"is_supported"]boolValue];
    }
    if (isSuppose == true) {

        if (![[dictDiscompose valueForKey:@"is_trashed"] isKindOfClass:[NSNull class]]) {
            if ([[dictDiscompose valueForKey:@"is_trashed"]boolValue] == 1) {
                [btnArchive setImage:[UIImage imageNamed:@"7_unselect.png"] forState:UIControlStateNormal];
                return;
            }
        }

        [btnLike setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
        imgVwlockSupport.hidden = NO;

        if (![[dictDiscompose valueForKey:@"is_public"] isKindOfClass:[NSNull class]]) {

            BOOL isPublic = [[dictDiscompose valueForKey:@"is_public"]boolValue];
            if (isPublic == 1) {
                imgVwlockSupport.image = [UIImage imageNamed:@"unlock.png"];
            } else {
                imgVwlockSupport.image = [UIImage imageNamed:@"lock.png"];
            }
        } else {
            imgVwlockSupport.image = [UIImage imageNamed:@"lock.png"];
        }
    } else {
        if (![[dictDiscompose valueForKey:@"is_trashed"] isKindOfClass:[NSNull class]]) {
            if ([[dictDiscompose valueForKey:@"is_trashed"]boolValue] == 1) {
                    [btnArchive setImage:[UIImage imageNamed:@"7_unselect.png"] forState:UIControlStateNormal];
                    return;
            }
        }

        [btnUnlike setImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
        imgVwlockOppose.hidden = NO;

        if (![[dictDiscompose valueForKey:@"is_public"] isKindOfClass:[NSNull class]]) {

            BOOL isPublic = [[dictDiscompose valueForKey:@"is_public"] boolValue];
            if (isPublic == 1) {
                imgVwlockOppose.image = [UIImage imageNamed:@"unlock.png"];
            } else {
                imgVwlockOppose.image = [UIImage imageNamed:@"lock.png"];
            }
        } else {
            imgVwlockOppose.image = [UIImage imageNamed:@"lock.png"];
        }
    }
}

#pragma mark - Suppose btn tapped

- (IBAction)likeBtnTapped:(id)sender {

    if ([btnLike.imageView.image isEqual:[UIImage imageNamed:@"4.png"]]) {

        if ([imgVwlockSupport.image isEqual:[UIImage imageNamed:@"lock.png"]]) {
            [self getApiCallToSupport:@"unlock"];
        } else if ([imgVwlockSupport.image isEqual:[UIImage imageNamed:@"unlock.png"]]){
            [self getApiCallToSupport:@"transIt"];
        }
    } else {

        [self getApiCallToSupport:@"lock"];
    }
}

- (void)getApiCallToSupport:(NSString*)typeOfLock {

    NSDictionary *param;
    if ([typeOfLock isEqualToString:@"lock"]) {
        param = @{@"is_supported": [NSNumber numberWithBool:true]};
    } else if ([typeOfLock isEqualToString:@"unlock"]) {
        param = @{ @"is_public": [NSNumber numberWithBool:true]};
    } else {
        param = @{@"is_trashed":[NSNumber numberWithBool:true]};
    }

    dispatch_queue_t queue = dispatch_queue_create("get belief", NULL);
    dispatch_async(queue, ^ {
        NSDictionary *dictBeliefDiscompose = @{@"belief_disposition" :param, @"id":[NSNumber numberWithInteger:self.tag]};
        [self.api callPostUrlWithHeader:dictBeliefDiscompose method:@"/api/v1/all_list_dispose" success:^(AFHTTPRequestOperation *task, id responseObject) {

            dispatch_async (dispatch_get_main_queue(), ^{
                NSLog(@"success");
                [self changeSupposeIcon];
                if ([self.delegate respondsToSelector:@selector(supportBtnTapped)]) {
                    [self.delegate supportBtnTapped];
                }
            });
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            NSLog(@"fail %@", task.responseString);

        }];
    });
}

- (void)changeSupposeIcon {

    if ([btnLike.imageView.image isEqual:[UIImage imageNamed:@"4.png"]]) {

        if ([imgVwlockSupport.image isEqual:[UIImage imageNamed:@"lock.png"]]) {

            imgVwlockSupport.image = [UIImage imageNamed:@"unlock.png"];
        } else if ([imgVwlockSupport.image isEqual:[UIImage imageNamed:@"unlock.png"]]){

            imgVwlockSupport.hidden = YES;
            [btnLike setImage:[UIImage imageNamed:@"4_unselect.png"] forState:UIControlStateNormal];
            [btnArchive setImage:[UIImage imageNamed:@"7_unselect"] forState:UIControlStateNormal];
        }
    } else {

        [btnArchive setImage:[UIImage imageNamed:@"6_unselect.png"] forState:UIControlStateNormal];
        [btnLike setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
            // [imgVwlockSupport.image isEqual:[UIImage imageNamed:@"lock.png"]];
        [btnUnlike setImage:[UIImage imageNamed:@"5_unselect.png"] forState:UIControlStateNormal];
        imgVwlockOppose.hidden = YES;
        imgVwlockSupport.hidden = NO;
        imgVwlockSupport.image = [UIImage imageNamed:@"lock.png"];
    }
}

#pragma mark - Oppose btn tapped

- (IBAction)unlikeBtnTapped:(id)sender {

    if ([btnUnlike.imageView.image isEqual:[UIImage imageNamed:@"5.png"]]) {

        if ([imgVwlockOppose.image isEqual:[UIImage imageNamed:@"lock.png"]]) {
            [self opposeApiCall:@"unlock"];
        } else if ([imgVwlockOppose.image isEqual:[UIImage imageNamed:@"unlock.png"]]){
            [self opposeApiCall:@"transh"];
        }
    } else {
        [self opposeApiCall:@"lock"];
    }
}

- (void)opposeApiCall:(NSString*)typeOfLock{

    NSDictionary *param;
    if ([typeOfLock isEqualToString:@"lock"]) {
        param = @{@"is_supported": [NSNumber numberWithBool:false]};
    } else if ([typeOfLock isEqualToString:@"unlock"]) {
        param = @{@"is_public": [NSNumber numberWithBool:true]};
    } else {
        param = @{@"is_trashed":[NSNumber numberWithBool:true]};
    }
    dispatch_queue_t queue = dispatch_queue_create("get belief", NULL);
    dispatch_async(queue, ^ {

        NSDictionary *dictBeliefDiscompose = @{@"belief_disposition" :param, @"id":[NSNumber numberWithInteger:self.tag]};
        [self.api callPostUrlWithHeader:dictBeliefDiscompose method:@"/api/v1/all_list_dispose" success:^(AFHTTPRequestOperation *task, id responseObject) {
            dispatch_async (dispatch_get_main_queue(), ^{
                NSLog(@"success");
                [self changeIconOfOppose];
                if ([self.delegate respondsToSelector:@selector(opposeBtnTapped)]) {
                    [self.delegate opposeBtnTapped];
                }
            });

        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            NSLog(@"fail");
            
        }];
    });
}

- (void)changeIconOfOppose {

    if ([btnUnlike.imageView.image isEqual:[UIImage imageNamed:@"5.png"]]) {

        if ([imgVwlockOppose.image isEqual:[UIImage imageNamed:@"lock.png"]]) {

            imgVwlockOppose.image = [UIImage imageNamed:@"unlock.png"];
        } else if ([imgVwlockOppose.image isEqual:[UIImage imageNamed:@"unlock.png"]]){

            imgVwlockOppose.hidden = YES;
            [btnUnlike setImage:[UIImage imageNamed:@"5_unselect.png"] forState:UIControlStateNormal];
            [btnArchive setImage:[UIImage imageNamed:@"7_unselect.png"] forState:UIControlStateNormal];
        }
    } else {
        [btnArchive setImage:[UIImage imageNamed:@"6_unselect.png"] forState:UIControlStateNormal];
        [btnUnlike setImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
        [btnLike setImage:[UIImage imageNamed:@"4_unselect.png"] forState:UIControlStateNormal];
        imgVwlockSupport.hidden = YES;
        imgVwlockOppose.hidden = NO;
        imgVwlockOppose.image = [UIImage imageNamed:@"lock.png"];
    }
}

#pragma mark - File it btn tapped

- (IBAction)downloadOrTranshBtnTapped:(id)sender {
    if ([btnArchive.imageView.image isEqual:[UIImage imageNamed:@"7_unselect.png"]]){
        return;
    }
    [self getApiCallToFileIt];//call api
    }

- (void)getApiCallToFileIt {

    NSDictionary *param = @{@"belief_id":[NSNumber numberWithInteger:self.tag]};
    dispatch_queue_t queue = dispatch_queue_create("get belief", NULL);
    dispatch_async(queue, ^ {
    [self.api callPostUrlWithHeader:param method:@"/api/v1/file_in_belief" success:^(AFHTTPRequestOperation *task, id responseObject) {
        dispatch_async (dispatch_get_main_queue(), ^{
            [self changeIconOfFileIt];
        });
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        NSLog(@"fail %@", task.responseString);
    }];
    });
}

- (void)changeIconOfFileIt {
    if ([btnArchive.imageView.image isEqual:[UIImage imageNamed:@"6_unselect.png"]]) {
        [btnArchive setImage:[UIImage imageNamed:@"6.png"] forState:UIControlStateNormal];
    } else {
        [btnArchive setImage:[UIImage imageNamed:@"6_unselect.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)shareBtnTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shareBtnTapped)]) {
        [self.delegate shareBtnTapped];
    }
}

- (IBAction)mapBtnTapped:(id)sender {
    [btnMap setImage:[UIImage imageNamed:@"9.png"] forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(mapBtnTapped)]) {
        [self.delegate mapBtnTapped];
    }
}

- (IBAction)keepMePostedBtnTapped:(id)sender {
        //[self.btnNotes setImage:[UIImage imageNamed:@"12.png"] forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(keepmePostedBtnTapped)]) {
        [self.delegate keepmePostedBtnTapped];
    }
}

@end
