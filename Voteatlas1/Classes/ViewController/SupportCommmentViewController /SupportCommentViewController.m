  //
  //  SupportCommentViewController.m
  //  Voteatlas1
  //
  //  Created by GrepRuby on 31/03/15.
  //  Copyright (c) 2015 Voteatlas. All rights reserved.
  //

#import "SupportCommentViewController.h"
#import "SupportOpposeCell.h"
#import "ProfileViewController.h"
#import "Comment.h"
#import "User.h"

#define WIDTH 120

@interface SupportCommentViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, CommentDelegate> {
  UIView *view;
  NSString *userName;
  UIView *vwOverlay;
  UIActivityIndicatorView *activityIndicator;
}

@property (readonly, nonatomic) UIView *container;
@property (nonatomic) CGRect tbleHeight;
@property (nonatomic, strong) NSMutableArray *arryCommentSuppose;
@property (nonatomic, strong)  NSMutableArray *arryCommentOppose;
@property (nonatomic, strong)  NSMutableArray *arryComment;
@property (readonly, nonatomic) PHFComposeBarView *composeBarView;
@property (readonly, nonatomic) UITextView *textView;
@property (nonatomic,readonly) UITableView *tbleVwComment;
@property (nonatomic,readonly) UIView *vwComment;
@property (nonatomic,readonly) UIButton *btnOppose;
@property (nonatomic,readonly) UIButton *btnSuppose;
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
    self.title = @"Comments";
    self.strSupposeOrOppose = @"Supporter";

    self.tbleVwComment.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillToggle:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillToggle:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];

    self.arryCommentSuppose = [[NSMutableArray alloc]init];
    self.arryComment = [[NSMutableArray alloc]init];
    self.arryCommentOppose = [[NSMutableArray alloc]init];

    NSArray *arrFetchedData =[User MR_findAll];
    User *user  = [arrFetchedData objectAtIndex:0];
    userName = user.name;

    [self addActivityIndicator];
    [self startAnimation];
    [_btnSuppose setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    [self commentApiCall];
    [self defaulUISettings];

    UIBarButtonItem *btnCancel= [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnTapped)];
    btnCancel.tintColor = [UIColor setCustomColorOfTextField];
    self.navigationItem.rightBarButtonItem = btnCancel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillHideNotification
                                                object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.title = @"Comment";
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark -  Set default UI
- (void)defaulUISettings {

    self.view.backgroundColor = [UIColor colorWithPatternImage:[ConstantClass imageAccordingToPhone]];
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

    NSDictionary *dictResponse = [responseObject objectForKey:@"comment"];
    if ([[dictResponse valueForKey:@"opposer_comments"] count] != 0) {

        NSArray *arryOppose = [dictResponse valueForKey:@"opposer_comments"];
        for (NSDictionary *dict in arryOppose) {
            Comment *objComment = [[Comment alloc]init];
            objComment.name = userName;
            objComment.comment = [dict valueForKey:@"content"];
            objComment.userName = [dict valueForKey:@"author_name"];
            [self.arryCommentOppose addObject:objComment];
            _tbleVwComment.frame = CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height-148);
        }
      }

      if ([[dictResponse valueForKey:@"supporter_comments"] count] != 0) {

        NSArray *arrySuppose = [dictResponse valueForKey:@"supporter_comments"];
        for (NSDictionary *dict in arrySuppose) {
            Comment *objComment = [[Comment alloc]init];
            objComment.name = [dict valueForKey:@"author_name"];
            objComment.comment = [dict valueForKey:@"content"];
            objComment.userName = [dict valueForKey:@"author_name"];

            [self.arryCommentSuppose addObject:objComment];
            [_container addSubview:[self composeBarView]];
            CGRect frame = CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height-148);
            _tbleVwComment.frame = frame;
        }
      }
      [self commentBtnTapped:_btnSuppose];
      [self stopAnimation];
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    [self stopAnimation];
  }];
}

#pragma mark - UITable view Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arryComment.count;
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
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    Comment *objComment = [self.arryComment objectAtIndex:indexPath.row];
    [cell setValueOfCommentsInTableVw:objComment withWidth:_tbleVwComment.frame.size.width - 60];
    return cell;
}

#pragma mark - UITable view Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    Comment *objComment = [self.arryComment objectAtIndex:indexPath.row];
    NSString *strSuppose = [objComment.comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGRect rect =[strSuppose boundingRectWithSize:CGSizeMake(_tbleVwComment.frame.size.width - 60, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil];
    return (rect.size.height + 28);
}

#pragma mark - Load view to add comment view
- (void)loadView {

    view = [[UIView alloc] initWithFrame:kInitialViewFrame];
    [view setBackgroundColor:[UIColor clearColor]];

    UIView *container = [self container];
    [container addSubview:[self textView]];
    [container addSubview:[self addComentTab:container.frame]];

    [container addSubview:[self addTableVw:container.frame]];
    [container addSubview:[self composeBarView]];
    [[self composeBarView] setHidden:YES];
    [view addSubview:container];
    [self setView:view];
}

@synthesize tbleVwComment = _tbleVwComment;
- (UITableView *) addTableVw:(CGRect)frame {

    _tbleVwComment = [[UITableView alloc]init];
    _tbleVwComment.delegate = self;
    _tbleVwComment.dataSource = self;
    _tbleVwComment.backgroundColor = [UIColor clearColor];
    _tbleVwComment.separatorColor = [UIColor darkGrayColor];
    return _tbleVwComment;
}

@synthesize vwComment = _vwComment;
@synthesize btnSuppose = _btnSuppose;
@synthesize btnOppose = _btnOppose;
- (UIView *) addComentTab:(CGRect)frame {

    _vwComment = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [ConstantClass withOfDeviceScreen], 40)];
    _vwComment.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _vwComment.backgroundColor = [UIColor clearColor];

    _btnSuppose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSuppose setTitle:@"Support" forState:UIControlStateNormal];
    _btnSuppose.tag = 100;
    _btnSuppose.backgroundColor = [UIColor clearColor];
    _btnSuppose.frame = CGRectMake(0, 0, _vwComment.frame.size.width/2, 40);
    [_btnSuppose setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnSuppose setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_btnSuppose addTarget:self action:@selector(commentBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_vwComment addSubview:_btnSuppose];

    _btnOppose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnOppose setTitle:@"Oppose" forState:UIControlStateNormal];
    _btnOppose.tag = 200;
    _btnOppose.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    _btnOppose.frame = CGRectMake( _vwComment.frame.size.width/2, 0,  _vwComment.frame.size.width/2, 40);
    [_btnOppose setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnOppose setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [_btnOppose addTarget:self action:@selector(commentBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_vwComment addSubview:_btnOppose];

  return _vwComment;
}

- (void)commentBtnTapped:(id)sender{

    UIButton *btnSeder = (UIButton *)sender;
    [_btnSuppose setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _btnSuppose.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];

    [_btnOppose setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _btnOppose.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];

    _tbleVwComment.hidden = NO;

    if (btnSeder.tag == 100) {
        self.arryComment = self.arryCommentSuppose;
        self.strSupposeOrOppose = @"Supporter";

        if (self.isSupport == 1 && self.isTrash == 0) {
          [[self composeBarView] setHidden:NO];
          CGRect frame = CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height-148);
          _tbleVwComment.frame = frame;
        } else {
          [[self composeBarView] setHidden:YES];
          CGRect frame = CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height-104);
          _tbleVwComment.frame = frame;
        }
    } else {
      self.arryComment = self.arryCommentOppose;
      self.strSupposeOrOppose = @"Opposer";

        if (self.isSupport == 0 && self.isTrash == 0) {
          CGRect frame = CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height-148);
          _tbleVwComment.frame = frame;
          [[self composeBarView] setHidden:NO];
        } else {
          CGRect frame = CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height-104);
          _tbleVwComment.frame = frame;
           [[self composeBarView] setHidden:YES];
        }
  }

    [btnSeder setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnSeder.backgroundColor = [UIColor clearColor];
    [_tbleVwComment reloadData];
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
        self.tbleHeight = _tbleVwComment.frame;
    }
    [UIView animateWithDuration:duration
                        delay:0
                      options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
                   animations:^{
                     [[self container] setFrame:newContainerFrame];
                     if (sizeChange < 0) {
                       [self setFrameOfTableVwAccordingToKeyboard:CGRectMake(self.tbleVwComment.frame.origin.x, 104, self.tbleVwComment.frame.size.width, self.tbleVwComment.frame.size.height - 256)];//256
                     }
                   }
                   completion:NULL];
}

- (void)setFrameOfTableVwAccordingToKeyboard:(CGRect)frame {
    _tbleVwComment.frame = frame;

    if (self.arryComment.count > 0) {
      NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.arryComment.count -1  inSection:0];
      [_tbleVwComment scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)cancelBtnTapped {

    [[self composeBarView] resignFirstResponder];
    [self setFrameOfTableVwAccordingToKeyboard:self.tbleHeight];
}
  // Delegate to get text to comment
- (void)composeBarViewDidPressButton:(PHFComposeBarView *)composeBarView {

    NSString *content = [NSString stringWithFormat:@"%@", [composeBarView text]];
    [composeBarView setText:@"" animated:YES];
    [composeBarView resignFirstResponder];
    [self setFrameOfTableVwAccordingToKeyboard:self.tbleHeight];

    Comment *objComment = [[Comment alloc]init];
    objComment.name = userName;
    objComment.userName = userName;
    objComment.comment = content;
    [self.arryComment addObject:objComment];

    if (self.arryComment.count == 1) {
        _tbleVwComment.frame = self.tbleHeight;
        _tbleVwComment.hidden = NO;
        [[self composeBarView] setHidden:NO];
    }
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
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    }];
}

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

        _composeBarView = [[PHFComposeBarView alloc] initWithFrame:frame];
        [_composeBarView setMaxCharCount:160];
        [_composeBarView setMaxLinesCount:5];
        [_composeBarView setPlaceholder:@"Compose new comment.."];
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

  if (endFrame.size.height > self.toolBarYOrigin) {
    self.toolBarYOrigin = endFrame.size.height;
    [self setFrameOfTableVwAccordingToKeyboard:CGRectMake(self.tbleVwComment.frame.origin.x, self.tbleVwComment.frame.origin.y, self.tbleVwComment.frame.size.width, self.tbleVwComment.frame.size.height - 20)];
  } else {
    self.toolBarYOrigin = endFrame.size.height;
    [self setFrameOfTableVwAccordingToKeyboard:CGRectMake(self.tbleVwComment.frame.origin.x, self.tbleVwComment.frame.origin.y, self.tbleVwComment.frame.size.width, self.tbleVwComment.frame.size.height + 20)];
  }
}

#pragma mark -  Add activity indicator
- (void)addActivityIndicator {

  vwOverlay = [[UIView alloc]initWithFrame:self.view.frame];
  vwOverlay.backgroundColor = [UIColor clearColor];
  [vwOverlay setHidden:YES];
  [self.view addSubview:vwOverlay];
  int yAxis = self.view.frame.size.height;
  int xAxis = self.view.frame.size.width;
  if (IS_IPHONE_5) {
    yAxis = 568;
  } else if (IS_IPHONE_6) {
    yAxis = 667;
    xAxis = 375;
  } else if (IS_IPHONE_6P) {
    yAxis = 768;
    xAxis = 414;
  }
  activityIndicator = [[UIActivityIndicatorView alloc]init];
  activityIndicator.center = CGPointMake(xAxis/2, (yAxis-35)/2);
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


- (void)profileBtnTapped:(Comment*)comment {
    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilID"];
    vc.userName = comment.userName;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
