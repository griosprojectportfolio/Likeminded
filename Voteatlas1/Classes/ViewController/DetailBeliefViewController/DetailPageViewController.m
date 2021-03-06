//
//  DetailPageViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 13/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "DetailPageViewController.h"
#import "CustomButtonsView.h"
#import "SupportCommentViewController.h"
#import "UIImageView+WebCache.h"
#import "MapLocations.h"
#import "ShowImageOrVideoViewController.h"
#import "CalloutAnnotationView.h"
#import "CalloutAnnotation.h"
#import "PinAnnotation.h"
#import "KeepMePostView.h"

@interface DetailPageViewController () <keepMePostedDelegate>{

    UIActivityIndicatorView *activityIndicator;
    NSInteger support;
    NSInteger oppose;
    BOOL isSupport;
    KeepMePostView *vwKeepMwPosted;

    NSURL *_urlToLoad;
    NSString *videoUrl;
}

@end

@implementation DetailPageViewController

#pragma mark - View life cycle
- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];
    self.mapvwBelief.zoomEnabled = YES;
    MKCoordinateSpan span = {.latitudeDelta = 180, .longitudeDelta = 360};
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0.0000f, 0.0000f), span);
    [self.mapvwBelief setRegion:region animated:YES];

    [self.customVwOfBtns instantiateAppApi];
    self.customVwOfBtns.isDetailVw = YES;
    [self.customVwOfBtns setFrameOfButtons:10 additionSpace:10];
    if (IS_IPHONE_5 | IS_IPHONE_4_OR_LESS) {
        self.customVwOfBtns.btnShare.frame = CGRectMake(self.customVwOfBtns.btnShare.frame.origin.x+3, self.customVwOfBtns.btnShare.frame.origin.y, self.customVwOfBtns.btnShare.frame.size.width, self.customVwOfBtns.btnShare.frame.size.height);
    }
    self.customVwOfBtns.delegate = self;
    self.customVwOfBtns.tag = self.objBelief.beliefId;
    [self defaulUISettings];
    [self addActivityIndicator];
    [self showActivityIndicator];

    self.navigationController.navigationBar.titleTextAttributes = @ {NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]};

    self .arrySupportLocation = [[NSMutableArray alloc]init];
    self.arryOpposeLocation = [[NSMutableArray alloc]init];
    self.title = @"Belief Detail";

    [self callBeliefApi];
    [self addKeepMePostView];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @ {NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]};
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.customVwOfBtns];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Default UI settings
/**************************************************************************************************
 Function to set default setting
 **************************************************************************************************/
- (void)defaulUISettings {

    self.view.backgroundColor = [UIColor colorWithPatternImage:[ConstantClass imageAccordingToPhone]];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTapped)];
    btnBack.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setLeftBarButtonItem:btnBack];

    [btnOppose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOppose.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];

    [btnSuppose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSuppose.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        //self.customVwOfBtns.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];

    int increaseHeight = (self.view.frame.size.height - 64)/2 - 40;

    imgVwOfMedia.frame = CGRectMake(20, imgVwOfMedia.frame.origin.y, self.view.frame.size.width - 40, increaseHeight);
    btnPlayOrShowImage.frame = imgVwOfMedia.frame;

    self.customVwOfBtns.frame = CGRectMake(20, (imgVwOfMedia.frame.size.height + imgVwOfMedia.frame.origin.y) - self.customVwOfBtns.frame.size.height , imgVwOfMedia.frame.size.width,self.customVwOfBtns.frame.size.height);

    // create effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake (0, imgVwOfMedia.frame.size.height - self.customVwOfBtns.frame.size.height , self.customVwOfBtns.frame.size.width, self.customVwOfBtns.frame.size.height);
    [imgVwOfMedia addSubview:effectView];

    self.mapvwBelief.frame = CGRectMake(20, imgVwOfMedia.frame.origin.y + imgVwOfMedia.frame.size.height + 10, self.view.frame.size.width - 40, increaseHeight);
}

#pragma mark - Back button tapped
- (void)backBtnTapped {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Call Belief api
/**************************************************************************************************
 Function to call belief api
 **************************************************************************************************/
- (void)callBeliefApi {

    if ([ConstantClass checkNetworkConection] == NO) {
        return;
    }

    NSDictionary *param = @{@"belief":[NSNumber numberWithInteger:self.belief_Id]};

    dispatch_queue_t queue = dispatch_queue_create("belief", NULL);
    dispatch_async(queue, ^ {
        dispatch_async (dispatch_get_main_queue(), ^{

            [self.api callGETUrlWithHeaderAuthentication :param method:@"/api/v1/belief" success:^(AFHTTPRequestOperation *task, id responseObject) {
                NSDictionary *dict = responseObject;
                NSDictionary *response = [[dict objectForKey:@"data"]valueForKey:@"belief"];
                support =  [[[dict objectForKey:@"data"]valueForKey:@"agree"] integerValue];
                oppose =  [[[dict objectForKey:@"data"]valueForKey:@"dis_agree"] integerValue];

                [self.mapvwBelief removeAnnotations:self.mapvwBelief.annotations];
                [self getLocationOfOppose:[[dict objectForKey:@"data"] valueForKey:@"oppose"]];
                [self getLocationOfsuppose:[[dict objectForKey:@"data"] valueForKey:@"support"]];
                self.customVwOfBtns.tag = [[response objectForKey:@"id"] integerValue];

                [self convertDataIntoModelClass:response];
                [self showContent];
                [self hideActivityIndicator];
                
            } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                [self hideActivityIndicator];
            }];
        });
    });
}

#pragma mark - Play button tapped
- (IBAction)playBtnTapped:(id)sender {

    if (self.objBelief.hasImage == YES) {
        ShowImageOrVideoViewController *vcShowImgOrVideo = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayVideo"];
        vcShowImgOrVideo.belief = self.objBelief;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vcShowImgOrVideo];
        [self presentViewController:navController animated:YES completion:nil];
    } else if (self.objBelief.hasYouTubeUrl == YES) {
        [self submitYouTubeURL];
    } else if (self.objBelief.hasVideo == YES){
        [self systemVideoPlay:nil];
    }
}

#pragma mark - Convert data in to model class
- (void)convertDataIntoModelClass:(NSDictionary *)dictBelief {

    self.objBelief = [[Belief alloc]init];
    self.objBelief.beliefId = [[dictBelief valueForKey:@"id"] integerValue];
    self.objBelief.statement = [dictBelief valueForKey:@"text"];
    self.objBelief.hasImage = [[dictBelief valueForKey:@"has_image"] boolValue];
    self.objBelief.hasVideo = [[dictBelief valueForKey:@"has_video"]boolValue];
    self.objBelief.hasYouTubeUrl = [[dictBelief valueForKey:@"has_youtube_video"]boolValue];

    if (self.objBelief.hasVideo == 1) {
        self.objBelief.videoUrl = [dictBelief valueForKey:@"video_url"];
        self.objBelief.thumbImage_Url = [[dictBelief valueForKey:@"video_image"] valueForKey:@"url"];
    }

    if (self.objBelief.hasImage == 1) {
        self.objBelief.imageUrl = [dictBelief valueForKey:@"image_url"];
    }

    if (self.objBelief.hasYouTubeUrl == 1) {
        self.objBelief.youtubeUrl = [dictBelief valueForKey:@"youtube_url"];
        self.objBelief.thumbImage_Url = [dictBelief valueForKey:@"youtube_image"];
    }

    if (![[dictBelief valueForKey:@"get_desposition"] isKindOfClass:[NSNull class]]) {
        self.objBelief.dictDisposition = [dictBelief valueForKey:@"get_desposition"];
    }
}

#pragma mark - Get location of suppose
- (void)getLocationOfsuppose:(NSArray *)arryBeliefSupport {

    for (NSDictionary *dictMap in arryBeliefSupport) {
        MapLocations*objMapLocation = [[MapLocations alloc]init];
        objMapLocation.title = @"support";
        if ([[dictMap objectForKey:@"location"]count] != 0) {
            objMapLocation.latitute = [[[dictMap objectForKey:@"location"]valueForKey:@"latitude"] floatValue];
            objMapLocation.longitute = [[[dictMap objectForKey:@"location"]valueForKey:@"longitude"]floatValue];
            [self.arrySupportLocation addObject:objMapLocation];
        }
    }
    [self addAnotation];
}

#pragma mark - Get location of oppose
- (void)getLocationOfOppose :(NSArray *)arryOppose {

    for (NSDictionary *dictMap in arryOppose) {
        MapLocations*objMapLocation = [[MapLocations alloc]init];
        objMapLocation.title = @"oppose";
        if ([[dictMap objectForKey:@"location"]count] != 0) {
            objMapLocation.latitute = [[[dictMap objectForKey:@"location"]valueForKey:@"latitude"] floatValue];
            objMapLocation.longitute = [[[dictMap objectForKey:@"location"]valueForKey:@"longitude"]floatValue];
            [self.arryOpposeLocation addObject:objMapLocation];
        }
    }
}

#pragma mark - Map show with annotation
- (void)addAnotation {

    NSMutableArray *arryAnnotation = [[NSMutableArray alloc]init];

    for (MapLocations *location in self.arrySupportLocation) {

        CLLocationCoordinate2D coordinate2d;
        coordinate2d.latitude = location.latitute;
        coordinate2d.longitude = location.longitute;

        PinAnnotation* pinAnnotation = [[PinAnnotation alloc] init];
        pinAnnotation.title = location.title;
        pinAnnotation.suppose = [NSString stringWithFormat:@"%ld", (long)support];
        pinAnnotation.oppose = [NSString stringWithFormat:@"%ld", (long)oppose];
        pinAnnotation.coordinate = coordinate2d;

        [arryAnnotation addObject:pinAnnotation];
    }

    for (MapLocations *location in self.arryOpposeLocation) {

        CLLocationCoordinate2D coordinate2d;
        coordinate2d.latitude = location.latitute;
        coordinate2d.longitude = location.longitute;

        PinAnnotation* pinAnnotation = [[PinAnnotation alloc] init];
        pinAnnotation.title = location.title;
        pinAnnotation.suppose = [NSString stringWithFormat:@"%ld", (long)support];
        pinAnnotation.oppose = [NSString stringWithFormat:@"%ld", (long)oppose];
        pinAnnotation.coordinate = coordinate2d;

        [arryAnnotation addObject:pinAnnotation];
    }

    [self.mapvwBelief addAnnotations:arryAnnotation];
}

#pragma mark - MKMapView delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation {

    MKAnnotationView *annotationView;
    NSString *identifier;

    if ([annotation isKindOfClass:[PinAnnotation class]]) {
            // Pin annotation.
        identifier = @"Pin";
        annotationView = (MKPinAnnotationView *)[self.mapvwBelief dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        if ([annotation.title isEqualToString:@"support"]) {
            annotationView.image = [UIImage imageNamed:@"greenPin"];
        } else {
            annotationView.image = [UIImage imageNamed:@"redPin"];
        }

    } else if ([annotation isKindOfClass:[CalloutAnnotation class]]) {
            // Callout annotation.
        identifier = @"Callout";
        annotationView = (CalloutAnnotationView *)[self.mapvwBelief dequeueReusableAnnotationViewWithIdentifier:identifier];

        if (annotationView == nil) {
            annotationView = [[CalloutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }

        CalloutAnnotation *calloutAnnotation = (CalloutAnnotation *)annotation;

        ((CalloutAnnotationView *)annotationView).titleSuppose = calloutAnnotation.suppose;
        ((CalloutAnnotationView *)annotationView).titleOppose = calloutAnnotation.oppose;
        [annotationView setNeedsDisplay];

        [annotationView setCenterOffset:CGPointMake(0, -70)];
            // Move the display position of MapView.
        [UIView animateWithDuration:0.5f
                         animations:^(void) {
                         }];
    }
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {

    if ([view.annotation isKindOfClass:[PinAnnotation class]]) {
            // Selected the pin annotation.
        CalloutAnnotation *calloutAnnotation = [[CalloutAnnotation alloc] init];

        PinAnnotation *pinAnnotation = ((PinAnnotation *)view.annotation);
        calloutAnnotation.suppose = pinAnnotation.suppose;
        calloutAnnotation.oppose = pinAnnotation.oppose;
        calloutAnnotation.coordinate = pinAnnotation.coordinate;
        pinAnnotation.calloutAnnotation = calloutAnnotation;
        [mapView addAnnotation:calloutAnnotation];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[PinAnnotation class]]) {
            // Deselected the pin annotation.
        PinAnnotation *pinAnnotation = ((PinAnnotation *)view.annotation);
        [mapView removeAnnotation:pinAnnotation.calloutAnnotation];
        pinAnnotation.calloutAnnotation = nil;
    }
}

- (void) showContent {
    [self.customVwOfBtns assignValuetoButton:self.objBelief.dictDisposition];
        // NSString *mediaUrl;
    if (self.objBelief.imageUrl.length != 0) {
            // mediaUrl = self.objBelief.imageUrl;

        dispatch_queue_t queue = dispatch_queue_create("belief", NULL);
        dispatch_async(queue, ^ {
            dispatch_async (dispatch_get_main_queue(), ^{
                [imgVwOfMedia sd_setImageWithURL:[NSURL URLWithString:self.objBelief.imageUrl] placeholderImage:nil];
            });
        });
        return;
    } else if (self.objBelief.videoUrl.length != 0) {
            // mediaUrl = self.objBelief.videoUrl;
        [btnPlayOrShowImage setImage:[UIImage imageNamed:@"play-btn"] forState:UIControlStateNormal];
    } else if (self.objBelief.youtubeUrl.length != 0) {
            //  mediaUrl = self.objBelief.youtubeUrl;
        [btnPlayOrShowImage setImage:[UIImage imageNamed:@"play-btn"] forState:UIControlStateNormal];
    }

    if (![self.objBelief.thumbImage_Url isKindOfClass:[NSNull class]]) {
        [imgVwOfMedia sd_setImageWithURL:[NSURL URLWithString:self.objBelief.thumbImage_Url] placeholderImage:nil];
    }

    if (self.objBelief.imageUrl.length == 0 && [self.objBelief.thumbImage_Url isKindOfClass:[NSNull class]] && self.objBelief.hasYouTubeUrl == NO && self.objBelief.hasVideo == NO ) {
        imgVwOfMedia.image = [UIImage imageNamed:@"download1"];
        btnPlayOrShowImage.hidden = YES;
        return;
    }
    if (([self.objBelief.thumbImage_Url isKindOfClass:[NSNull class]] && ![self.objBelief.imageUrl isEqual:[NSNull class]])) {
        imgVwOfMedia.image = [UIImage imageNamed:@"video_thumb"];
            // btnPlayOrShowImage.hidden = YES;
            //  return;
    }

    [self.view bringSubviewToFront:btnPlayOrShowImage];
    btnPlayOrShowImage.hidden = NO;
    btnPlayOrShowImage.tintColor = [UIColor setCustomColorOfTextField];
}

#pragma mark - Delegate of custom button view
- (void)sharebtnTapped:(Belief*)belief {

  [self showActivityIndicator];
  dispatch_queue_t queue = dispatch_queue_create("get image", NULL);
  dispatch_async(queue, ^ {
    dispatch_async(dispatch_get_main_queue(), ^{

      NSString *url;
        UIImage *image = [[UIImage alloc]init];

      if (belief.imageUrl.length != 0){
        url = belief.imageUrl;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        image = [UIImage imageWithData:data];
      }
      NSString *strShare = [NSString stringWithFormat:@"Voteatlas \n %@ \n \n https://likeminded.co\n", belief.statement];
      NSArray *objectsToShare;

      if ([belief.thumbImage_Url isKindOfClass:[NSNull class]]){
        objectsToShare = @[strShare];
      } else {
        if (belief.videoUrl.length != 0) {
          url = belief.thumbImage_Url;
          NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
          UIImage *imageThumb = [UIImage imageWithData:data];
          image = [ConstantClass mergeTwoImage:imageThumb andImage2:[UIImage imageNamed:@"play-btn"]];
        } else if (belief.youtubeUrl.length != 0) {
          url = belief.thumbImage_Url;
          NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
          UIImage *imageThumb = [UIImage imageWithData:data];
          image = [ConstantClass mergeTwoImage:imageThumb andImage2:[UIImage imageNamed:@"play-btn"]];
        }

        NSString *shareUrlSchema = [NSString stringWithFormat:@"voteatlas://belief_id/%li/token/%@", (long)belief.beliefId, [[NSUserDefaults standardUserDefaults]valueForKey:@"auth_token"]];
        strShare = [NSString stringWithFormat:@"Likeminded \n %@ \n %@ \n https://likeminded.co \n", belief.statement , url];

        objectsToShare = @[strShare, image, [NSURL URLWithString:shareUrlSchema]];
      }
      UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
      controller.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypeAirDrop];
      [self presentViewController:controller animated:YES completion:nil];
      [self hideActivityIndicator];
    });
  });
}

- (void)mapBtnTapped {

}

- (void)supportBtnTapped {

    [self callBeliefApi];
}

- (void)opposeBtnTapped {

    [self callBeliefApi];
}

//Send Keep me posted
- (void)keepmePostedBtnTapped {
    [self showKeepMePostVwWithAnimation];
}

- (void)addKeepMePostView {
    vwKeepMwPosted = [[KeepMePostView alloc]initWithFrame:CGRectMake(0, 77, self.view.frame.size.width, self.view.frame.size.height)];
    [vwKeepMwPosted setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    vwKeepMwPosted.delegate = self;
    [vwKeepMwPosted setHidden:YES];
    [self.view addSubview:vwKeepMwPosted];
}

- (void)showKeepMePostVwWithAnimation {
    [self addKeepMePostView];
    [UIView animateWithDuration:0.4 animations:^{
        vwKeepMwPosted.hidden = NO;
    }];
}

#pragma mark - Send Keep me posted Delegates
- (void)cancelBtnTapped {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.4 animations:^{
        [vwKeepMwPosted removeFromSuperview];
    }];
}

- (void)sendKeepMePosted:(NSInteger)duration {
    if (duration == 0) {
        UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select one type" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertVw show];
        return;
    }
    [self cancelBtnTapped];
    if([ConstantClass checkNetworkConection] == NO) {
        return;
    }
    NSDictionary *param = @{@"belief_id":[NSNumber numberWithInteger:self.objBelief.beliefId],
                            @"duration":[NSNumber numberWithInteger:duration]
                            };
    dispatch_queue_t queue = dispatch_queue_create("KeepMePosted", NULL);
    dispatch_async(queue, ^ {
        [self.api callPostUrlWithHeader:param method:@"/api/v1/keep_me_notified" success:^(AFHTTPRequestOperation *task, id responseObject) {
            dispatch_async (dispatch_get_main_queue(), ^{
            [self.customVwOfBtns.btnNotes setImage:[UIImage imageNamed:@"12.png"] forState:UIControlStateNormal];
            });
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        }];
    });
}

- (IBAction)supportCommentBtnTapped:(id)sender  {

  SupportCommentViewController *vcSupposeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SupposeOpposeVC"];

  if (![self.objBelief.dictDisposition isKindOfClass:[NSNull class]]) { //(![belief.dictDisposition isKindOfClass:[NSNull class]]) {
    NSDictionary * dict = self.objBelief.dictDisposition;

    if (dict.count == 0){

      vcSupposeVC.isTrash = 1;
      vcSupposeVC.belief_Id = self.objBelief.beliefId;
    } else {

      if ([[dict valueForKey:@"is_trashed"] isKindOfClass:[NSNull class]]) {
        vcSupposeVC.isTrash = 0;
      } else {
        vcSupposeVC.isTrash = [[dict valueForKey:@"is_trashed"]boolValue];
      }
      vcSupposeVC.isSupport = [[dict valueForKey:@"is_supported"]boolValue];
    }
    vcSupposeVC.belief_Id = self.objBelief.beliefId;
    vcSupposeVC.strTitle = self.objBelief.statement;
  }

  [self.navigationController pushViewController:vcSupposeVC animated:YES];
}

#pragma mark - Add activity indicator
- (void)addActivityIndicator {

    activityIndicator = [[UIActivityIndicatorView alloc]init];
    activityIndicator.frame = CGRectMake((self.view.frame.size.width-35)/2, (self.view.frame.size.height-35)/2, 35, 35);
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:activityIndicator];
    [self.view bringSubviewToFront:activityIndicator];
}

- (void) hideActivityIndicator {

    [activityIndicator setHidden:YES];
    [activityIndicator stopAnimating];
}

- (void) showActivityIndicator {

    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
}

#pragma mark - Play button tapped
- (void)systemVideoPlay:(id)sender {

    self.mpvc = [[MPMoviePlayerViewController alloc] init];
        // [self.view addSubview:self.mpvc.view];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClick:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:nil];

    self.mpvc.moviePlayer.contentURL = [NSURL URLWithString:self.objBelief.videoUrl];
    [self.mpvc.view setFrame:self.view.frame];
    [self.mpvc.moviePlayer setUseApplicationAudioSession:NO];
    self.mpvc.view.hidden = NO;
    [self presentViewController:self.mpvc animated:YES completion:^{
        self.mpvc.moviePlayer.allowsAirPlay = YES;
        [[self.mpvc moviePlayer] setControlStyle:2];
        self.mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        self.mpvc.moviePlayer.shouldAutoplay = YES;
    }];
}

#pragma mark - Play Youtube url
- (void)submitYouTubeURL {

    _urlToLoad = nil;
    NSURL *url = [NSURL URLWithString:self.objBelief.youtubeUrl];
    [HCYoutubeParser thumbnailForYoutubeURL:url thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {

        if (!error) {
            [HCYoutubeParser h264videosWithYoutubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
                NSDictionary *qualities = videoDictionary;
                NSString *URLString = nil;
                if ([qualities objectForKey:@"small"] != nil) {
                    URLString = [qualities objectForKey:@"small"];
                }
                else if ([qualities objectForKey:@"live"] != nil) {
                    URLString = [qualities objectForKey:@"live"];
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find youtube video." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
                    return;
                }
                _urlToLoad = [NSURL URLWithString:URLString];
                    // [self.view addSubview:self.mpvc.view];
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(doneButtonClick:)
                                                             name:MPMoviePlayerWillExitFullscreenNotification
                                                           object:nil];
                self.mpvc = [[MPMoviePlayerViewController alloc] init];
                self.mpvc.moviePlayer.contentURL = _urlToLoad;
                [self.mpvc.view setFrame:self.view.frame];
                self.mpvc.view.hidden = NO;
                [self.mpvc.moviePlayer setUseApplicationAudioSession:NO];
                [self presentViewController:self.mpvc animated:YES completion:^{
                    self.mpvc.moviePlayer.allowsAirPlay = YES;
                    [[self.mpvc moviePlayer] setControlStyle:2];
                    self.mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
                    self.mpvc.moviePlayer.shouldAutoplay = YES;
                }];
            }];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
- (void)doneButtonClick:(NSNotification*)aNotification{

    NSNumber *reason = [aNotification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if ([reason intValue] == MPMovieFinishReasonUserExited) {
        [self.mpvc.moviePlayer stop];
        [self dismissMoviePlayerViewControllerAnimated];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)fileItBtnTapped {

}

@end
