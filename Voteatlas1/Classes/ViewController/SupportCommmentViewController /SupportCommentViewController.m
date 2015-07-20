//
//  SupportCommentViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 31/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "SupportCommentViewController.h"
#import "SupportOpposeCell.h"
#import "Comment.h"
#import "User.h"

#define WIDTH 120

@interface SupportCommentViewController () <UITableViewDataSource, UITableViewDelegate> {
    UIView *view;
    NSString *userName;
    UIView *vwOverlay;
    UIActivityIndicatorView *activityIndicator;
}

@property (readonly, nonatomic) UIView *container;

@property (nonatomic, strong) NSMutableArray *arryCommentSuppose;
@property (nonatomic, strong) NSMutableArray *arryCommentOppose;
@property (nonatomic, strong) NSMutableArray *arrayComment;
@property (readonly, nonatomic) PHFComposeBarView *composeBarView;
@property (readonly, nonatomic) UITextView *textView;
@property (nonatomic,readonly) UITableView *tbleVwComment;
@property (nonatomic) int toolBarYOrigin;

@end

CGRect const kInitialViewFrame = { 0.0f, 0.0f, 320.0f, 480.0f};

@implementation SupportCommentViewController

#pragma mark - View life cycle
- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = YES;

    if ([self.strSupposeOrOppose isEqualToString:@"Supporter"]){
        self.title = @"Support Comment";
    } else {
        self.title = @"Opppose Comment";
    }
    self.tbleVwComment.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillToggle:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillToggle:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    self.arryCommentOppose = [[NSMutableArray alloc]init];
    self.arryCommentSuppose = [[NSMutableArray alloc]init];
    self.arrayComment = [[NSMutableArray alloc]init];

    NSArray *arrFetchedData =[User MR_findAll];
    User *user  = [arrFetchedData objectAtIndex:0];
    userName = user.name;

    [self addActivityIndicator];
    [self startAnimation];

    [self commentApiCall];
    [self defaulUISettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark -  Set default UI
- (void)defaulUISettings {
    if (IS_IPHONE_4_OR_LESS) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG4.png"]];
    } else if (IS_IPHONE_5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG5.png"]];
    } else if (IS_IPHONE_6) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG6.png"]];
    } else if (IS_IPHONE_6P) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG6Pluse.png"]];
    }

    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTapped)];
    btnBack.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setLeftBarButtonItem:btnBack];
}

#pragma mark - Comment api call
- (void)commentApiCall {

    if ([ConstantClass checkNetworkConection] == NO) {
        return;
    }
    NSDictionary *param = @{@"topic_key":[NSNumber numberWithInteger:self.belief_Id]};
    [self.api callGETUrl:param method:@"/api/v1/comment" success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"%@",responseObject);

        NSDictionary *dictResponse = [responseObject objectForKey:@"comment"];

        if ([self.strSupposeOrOppose isEqualToString:@"Opposer"]) {
            if ([[dictResponse valueForKey:@"opposer_comments"] count] != 0) {

                NSArray *arryOppose = [dictResponse valueForKey:@"opposer_comments"];
                for (NSDictionary *dict in arryOppose) {
                    Comment *objComment = [[Comment alloc]init];
                    objComment.name = userName;
                    objComment.comment = [dict valueForKey:@"content"];
                    [self.arryCommentOppose addObject:objComment];
                    _tbleVwComment.frame = CGRectMake(0, 0, 375, 600);
                }
            }

            if (self.isSupport == 0 && self.isTrash == 0) {
                self.arrayComment = self.arryCommentOppose;
                [self.tbleVwComment reloadData];

                CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
                _tbleVwComment.frame = frame;
                [[self composeBarView] setHidden:NO];
            }
        } else {
            if ([[dictResponse valueForKey:@"supporter_comments"] count] != 0) {

                NSArray *arrySuppose = [dictResponse valueForKey:@"supporter_comments"];
                for (NSDictionary *dict in arrySuppose) {
                    Comment *objComment = [[Comment alloc]init];
                    objComment.name = userName;
                    objComment.comment = [dict valueForKey:@"content"];
                    [self.arryCommentSuppose addObject:objComment];
                    [_container addSubview:[self composeBarView]];

                    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
                    _tbleVwComment.frame = frame;
                }
            }

            if (self.isSupport == 1 && self.isTrash == 0) {
                self.arrayComment = self.arryCommentSuppose;
                [[self composeBarView] setHidden:NO];
                CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
                _tbleVwComment.frame = frame;
                [_tbleVwComment reloadData];
            }
        }

        if (self.arrayComment.count == 0) {
            self.tbleVwComment.hidden = YES;
            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Comments." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertVw show];
        }

        [self stopAnimation];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        NSLog(@"%@",task.responseString);
    }];
}

#pragma mark - UITable view Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayComment.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = @"comment";
    SupportOpposeCell *cell;
    cell = (SupportOpposeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *arryObjects;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (cell == nil) {
        arryObjects = [[NSBundle mainBundle]loadNibNamed:@"SupportOpposeCell" owner:nil options:nil];
        cell = [arryObjects objectAtIndex:0];
    }

    Comment *objComment = [self.arrayComment objectAtIndex:indexPath.row];
    [cell setValueOfCommentsInTableVw:objComment];
    return cell;
}

#pragma mark - UITable view Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    Comment *objComment = [self.arrayComment objectAtIndex:indexPath.row];
    NSString *strSuppose = objComment.comment;
    CGRect rect =[strSuppose boundingRectWithSize:CGSizeMake(WIDTH, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil];
    return (rect.size.height + 28);
}

#pragma mark - Load view to add comment view
- (void)loadView {

    view = [[UIView alloc] initWithFrame:kInitialViewFrame];
    [view setBackgroundColor:[UIColor clearColor]];

    UIView *container = [self container];
    [container addSubview:[self textView]];
    [container addSubview:[self addTableVw:container.frame]];
    [container addSubview:[self composeBarView]];
    [[self composeBarView] setHidden:YES];
    [view addSubview:container];
    [self setView:view];
}

@synthesize tbleVwComment = _tbleVwComment;
- (UITableView *) addTableVw:(CGRect)frame {

    CGRect rect = kInitialViewFrame;

    if(IS_IPHONE_6) {
        rect = CGRectMake(0, 0, 375, 560);
    }
    _tbleVwComment = [[UITableView alloc]init];
    _tbleVwComment.delegate = self;
    _tbleVwComment.dataSource = self;
    _tbleVwComment.backgroundColor = [UIColor clearColor];
    _tbleVwComment.separatorColor = [UIColor darkGrayColor];
    return _tbleVwComment;
}

#pragma mark - UIKeyboard Notification
- (void)keyboardWillToggle:(NSNotification *)notification {

    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval duration;
    UIViewAnimationCurve animationCurve;
    CGRect startFrame;
    CGRect endFrame;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]    getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]        getValue:&startFrame];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]          getValue:&endFrame];

    NSInteger signCorrection = 1;
    if (startFrame.origin.y < 0 || startFrame.origin.x < 0 || endFrame.origin.y < 0 || endFrame.origin.x < 0)
        signCorrection = -1;

    CGFloat widthChange  = (endFrame.origin.x - startFrame.origin.x) * signCorrection;
    CGFloat heightChange = (endFrame.origin.y - startFrame.origin.y) * signCorrection;

    CGFloat sizeChange = UIInterfaceOrientationIsLandscape([self interfaceOrientation]) ? widthChange : heightChange;

    CGRect newContainerFrame = [[self container] frame];
    newContainerFrame.size.height += sizeChange;

    if (sizeChange < 0) {
        [self setFrameOfTableVwAccordingToKeyboard:CGRectMake(self.tbleVwComment.frame.origin.x,self.tbleVwComment.frame.origin.y, self.tbleVwComment.frame.size.width, self.tbleVwComment.frame.size.height - 256)];
      }
    [UIView animateWithDuration:duration
                          delay:0
                        options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [[self container] setFrame:newContainerFrame];
                     }
                     completion:NULL];
}

- (void)setFrameOfTableVwAccordingToKeyboard:(CGRect)frame {

      [UIView animateWithDuration:0.3 animations:^{
          _tbleVwComment.frame = frame;

          if (self.arrayComment.count > 0) {
              NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.arrayComment.count -1  inSection:0];
              [_tbleVwComment scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
          }
      }];
}

    // Delegate to get text to comment
- (void)composeBarViewDidPressButton:(PHFComposeBarView *)composeBarView {

    NSString *content = [NSString stringWithFormat:@"%@", [composeBarView text]];
    NSLog(@"%@", content);
    [composeBarView setText:@"" animated:YES];
    [composeBarView resignFirstResponder];
    _tbleVwComment.frame = CGRectMake(self.tbleVwComment.frame.origin.x,self.tbleVwComment.frame.origin.y, self.tbleVwComment.frame.size.width, self.tbleVwComment.frame.size.height + 256);

    Comment *objComment = [[Comment alloc]init];
    objComment.name = userName;
    objComment.comment = content;
    [self.arrayComment addObject:objComment];
    [_tbleVwComment reloadData];

    [self sendCommnetApiCall:content];
}

#pragma mark - Send comment
- (void)sendCommnetApiCall:(NSString *)commentContent {

    if ([ConstantClass checkNetworkConection] == NO) {
        return;
    }

    NSDictionary *param = @{@"topic_key":[NSNumber numberWithInteger:self.belief_Id],
                                          @"type":self.strSupposeOrOppose,
                                          @"content":commentContent,
                                          @"topic_title":self.strTitle};
    [self.api callPostUrlWithHeader:param method:@"/api/v1/comment_create" success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        NSLog(@"%@", task.responseString);
    }];
}

///*
//- (void)composeBarViewDidPressUtilityButton:(PHFComposeBarView *)composeBarView {
//    [self prependTextToTextView:@"Utility button pressed"];
//}
//
//- (void)prependTextToTextView:(NSString *)text {
//    NSString *newText = [text stringByAppendingFormat:@"\n\n%@", [[self textView] text]];
//    [[self textView] setText:newText];
//}
//*/
//

- (void)backBtnTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

@synthesize container = _container;
- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:kInitialViewFrame];
        [_container setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }

    return _container;
}
//
////Making text view
//
@synthesize composeBarView = _composeBarView;
- (PHFComposeBarView *)composeBarView {
    if (!_composeBarView) {
        CGRect frame = CGRectMake(0.0f,
                                  kInitialViewFrame.size.height - PHFComposeBarViewInitialHeight,
                                  kInitialViewFrame.size.width,
                                  PHFComposeBarViewInitialHeight);
//        CGRect frame = kInitialViewFrame;
//        if(IS_IPHONE_6) {
//            frame = CGRectMake(0, 604 - PHFComposeBarViewInitialHeight, 375, PHFComposeBarViewInitialHeight);
//        } else if (IS_IPHONE_4_OR_LESS) {
//            frame = CGRectMake(0, 480 - 64 - PHFComposeBarViewInitialHeight, 320, PHFComposeBarViewInitialHeight);
//        }

        _composeBarView = [[PHFComposeBarView alloc] initWithFrame:frame];
        [_composeBarView setMaxCharCount:160];
        [_composeBarView setMaxLinesCount:5];
        [_composeBarView setPlaceholder:@"Type something..."];
        //[_composeBarView setUtilityButtonImage:[UIImage imageNamed:@"Camera"]];
        [_composeBarView setDelegate:self];
    }

    return _composeBarView;
}

- (void)composeBarView:(PHFComposeBarView *)composeBarView
   willChangeFromFrame:(CGRect)startFrame
               toFrame:(CGRect)endFrame
              duration:(NSTimeInterval)duration
        animationCurve:(UIViewAnimationCurve)animationCurve {

    NSLog(@"%@ %@", NSStringFromCGRect(startFrame), NSStringFromCGRect(endFrame));

    if (endFrame.size.height > self.toolBarYOrigin) {
        self.toolBarYOrigin = endFrame.size.height;
        [self setFrameOfTableVwAccordingToKeyboard:CGRectMake(self.tbleVwComment.frame.origin.x, self.tbleVwComment.frame.origin.y, self.tbleVwComment.frame.size.width, self.tbleVwComment.frame.size.height - 21)];
    } else {
        self.toolBarYOrigin = endFrame.size.height;
        [self setFrameOfTableVwAccordingToKeyboard:CGRectMake(self.tbleVwComment.frame.origin.x, self.tbleVwComment.frame.origin.y, self.tbleVwComment.frame.size.width, self.tbleVwComment.frame.size.height + 21)];
    }
}

#pragma mark -  Add activity indicator
- (void)addActivityIndicator {

    vwOverlay = [[UIView alloc]initWithFrame:self.view.frame];
    vwOverlay.backgroundColor = [UIColor clearColor];
    [vwOverlay setHidden:YES];
    [self.view addSubview:vwOverlay];

    activityIndicator = [[UIActivityIndicatorView alloc]init];
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height-35)/2);
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicator.tintColor = [UIColor setCustomColorOfTextField];
    [self.view bringSubviewToFront:activityIndicator];
    [self.view addSubview:activityIndicator];
    [activityIndicator setHidden:YES];
}

- (void)startAnimation {

    [vwOverlay setHidden:NO];
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
}

- (void)stopAnimation {

    [vwOverlay setHidden:YES];
    [activityIndicator setHidden:YES];
    [activityIndicator stopAnimating];
}

@end
