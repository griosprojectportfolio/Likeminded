//
//  BelieveViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 16/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "BelieveViewController.h"
#import "ActionSheetPicker.h"
#import "Draft.h"
#import "DraftViewController.h"
#import "User.h"

@interface BelieveViewController () <UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DraftDelegates>{

    int selectedLauguageId;

    UIAlertView *alertYouTube;
    UIAlertView *alertSelectFile;
    UIAlertView *alertVwSuccess;

    NSURL*urlYoutube;
    NSString *strImageString;
    NSURL *urlOfFile;
    NSString *typeOfUploadFile;
    UIActivityIndicatorView *activityIndicator;
    UIView *vwOverlay;
    NSArray*arrySelectCategory;
    BOOL is_publish;
    BOOL isAuther;
    User *userObject;
}

@property (nonatomic, retain) AppApi *api;
@property (nonatomic, strong) NSMutableArray *arryLanguage;
@property (nonatomic, strong) NSMutableArray *arryCategory;
@property (nonatomic, strong) NSMutableArray *arryLanguageId;
@property (nonatomic, strong) NSMutableArray *arryCategorybtnList;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation BelieveViewController

#pragma mark - View life cycle

- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];
    is_publish = 0;
    isAuther = 0;
    self.txtstatement.delegate = self;
    self.navigationController.navigationBar.titleTextAttributes = @ {NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]};
    self.title = @"Add New Belief";

    urlYoutube = [NSURL URLWithString:@""];
    self.arryLanguage = [[NSMutableArray alloc]init];
    self.arryLanguageId = [[NSMutableArray alloc]init];
    self.arryCategorybtnList = [[NSMutableArray alloc]init];
    self.arryCategory = [[NSMutableArray alloc]init];

    NSArray *arrFetchedData =[User MR_findAll];
    userObject = [arrFetchedData objectAtIndex:0];

    is_publish = YES;

    [self addActivityIndicator];

    [self defaulUISettings];
    [self getAlllanguageList];
    [self getAllCategory];

    self.vScrollView.contentSize = CGSizeMake(self.vScrollView.frame.size.width, 800);
    self.btnOK.backgroundColor = [UIColor setCustomSignUpColor];
    [self.btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnOK.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.segUpload.selectedSegmentIndex = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - Add Activity indicator
/**************************************************************************************************
 Function to add activity indicator
 **************************************************************************************************/
- (void)addActivityIndicator {

    vwOverlay = [[UIView alloc]initWithFrame:self.view.frame];
    vwOverlay.backgroundColor = [UIColor clearColor];
    [vwOverlay setHidden:YES];
    [self.view addSubview:vwOverlay];

    activityIndicator = [[UIActivityIndicatorView alloc]init];
    activityIndicator.center = CGPointMake((self.view.frame.size.width)/2, (self.view.frame.size.height-35)/2);
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
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

#pragma mark - Set default settings
/**************************************************************************************************
 Function to set default settings
 **************************************************************************************************/
- (void)defaulUISettings {

    self.view.backgroundColor = [UIColor colorWithPatternImage:[ConstantClass imageAccordingToPhone]];
    int txtFieldWidth = self.view.frame.size.width - 40;

    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTapped)];
    btnBack.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setLeftBarButtonItem:btnBack];

    UIBarButtonItem *btnDrats = [[UIBarButtonItem alloc]initWithTitle:@"Draft" style:UIBarButtonItemStylePlain target:self action:@selector(draftBtnTapped)];
    btnDrats.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setRightBarButtonItem:btnDrats];

    [self.txtstatement setCustomImgVw:@"statment" withWidth:txtFieldWidth];
    self.txtstatement.textColor = [UIColor setCustomColorOfTextField];
    self.txtstatement.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Your Statement" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [self.txtlanguage setCustomImgVw:@"language" withWidth:txtFieldWidth];
    self.txtlanguage.textColor = [UIColor setCustomColorOfTextField];
    self.txtlanguage.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Language" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    lblPrivacyHeading.font = [UIFont boldSystemFontOfSize:14.0];
    lblPrivacyHeading.textColor = [UIColor whiteColor];
    lblShowAsAuthor.textColor = [UIColor whiteColor];
    lblShowOnProfile.textColor = [UIColor whiteColor];

    lblPublishStmtHeading.font = [UIFont boldSystemFontOfSize:14.0];
    lblPublishStmtHeading.textColor = [UIColor whiteColor];
    lblPublishStmt.textColor = [UIColor whiteColor];

    lblRelevantHeading.font = [UIFont boldSystemFontOfSize:14.0];
    lblRelevantHeading.textColor = [UIColor whiteColor];

    lblWebLink.textColor = [UIColor whiteColor];
    lblUploadFrom.textColor = [UIColor whiteColor];
    lblAddImageOrVideo.textColor = [UIColor whiteColor];

    self.swtPublish.tintColor = [UIColor whiteColor];
    self.swtPublish.onTintColor = [UIColor setCustomColorOfTextField];

    self.segUpload.tintColor = [UIColor whiteColor];

    [self.txtFldWebLink setCustomImgVw:@"link" withWidth:txtFieldWidth];
    self.txtFldWebLink.textColor = [UIColor setCustomColorOfTextField];
    self.txtFldWebLink.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"WebLink" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [self addChakeBoxs];
    [self startAnimation];
}

- (void)backBtnTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)draftBtnTapped {

  DraftViewController*draftVwController = [self.storyboard instantiateViewControllerWithIdentifier:@"DraftVC"];
  draftVwController.delegate = self;
  [self.navigationController pushViewController:draftVwController animated:YES];
}

#pragma mark - Add check box of category
/**************************************************************************************************
 Function to add category checkbox
 **************************************************************************************************/
- (void)addCheckBoxWithLabel {

    int yAxis = 250;
    for (int i=0 ; i<self.arryCategory.count ; i++) {

        NSDictionary *dictCategory = [self.arryCategory objectAtIndex:i];
        NSInteger catId = [[dictCategory valueForKey:@"id"] integerValue];
        NSString *strCatName = [dictCategory valueForKey:@"name"];

        UILabel *lblCheckBox = [[UILabel alloc]init];
        lblCheckBox.frame = CGRectMake(50, yAxis+1, 250, 21);
        lblCheckBox.text = strCatName;
        lblCheckBox.textColor = [UIColor whiteColor];
        lblCheckBox.font = [UIFont systemFontOfSize:14];
        [self.vScrollView addSubview:lblCheckBox];

        M13Checkbox *btnCheckBox = [[M13Checkbox alloc]initWithFrame:CGRectMake(22, yAxis, 23, 23)];
        btnCheckBox.tag = catId;
        btnCheckBox.checkState = 0;
        [self.vScrollView addSubview:btnCheckBox];

        [self.arryCategorybtnList addObject:btnCheckBox];
        yAxis = yAxis + 30;
    }

    lblAddImageOrVideo.frame = CGRectMake(lblAddImageOrVideo.frame.origin.x, yAxis + 10, lblAddImageOrVideo.frame.size.width, lblAddImageOrVideo.frame.size.height);

    lblUploadFrom.frame = CGRectMake(lblUploadFrom.frame.origin.x, yAxis + 40,lblUploadFrom.frame.size.width, lblUploadFrom.frame.size.height);
    self.segUpload.frame = CGRectMake(self.segUpload.frame.origin.x, yAxis + 40, self.segUpload.frame.size.width, self.segUpload.frame.size.height);

    lblWebLink.frame = CGRectMake (lblWebLink.frame.origin.x, yAxis + 90, lblAddImageOrVideo.frame.size.width, lblWebLink.frame.size.height);
    self.txtFldWebLink.frame = CGRectMake(self.txtFldWebLink.frame.origin.x, yAxis + 90, self.txtFldWebLink.frame.size.width, self.txtFldWebLink.frame.size.height);
    self.segPublishStatement.frame = CGRectMake(20, yAxis + 145, self.view.frame.size.width - 40, self.segPublishStatement.frame.size.height);
    self.btnOK.frame = CGRectMake(20, yAxis + 190, self.btnOK.frame.size.width, self.btnOK.frame.size.height);

    self.vScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.btnOK.frame.origin.y + 95);
    [self stopAnimation];
    
    // Load current page when view come from left panel
    [self viewComeFromLeftPanel];
}

#pragma mark - Add check box of auther and publish
- (void) addChakeBoxs {

    chkAuthor = [[M13Checkbox alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50 ,lblShowAsAuthor.frame.origin.y - 6, 29, 29)];
    chkAuthor.checkState = 0;
    chkAuthor.checkColor = [UIColor blackColor];
    [chkAuthor addTarget:self action:@selector(authorBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.vScrollView addSubview:chkAuthor];
  
    chkShowOnProfile = [[M13Checkbox alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50,lblShowOnProfile.frame.origin.y - 8 , 29, 29)];
    chkShowOnProfile.checkState = 0;
    [self.vScrollView addSubview:chkShowOnProfile];
}

#pragma mark - Auther button tapped
- (void)authorBtnTapped {

    if (chkAuthor.checkState == 1) {
        chkShowOnProfile.enabled = NO;
    } else {
        chkShowOnProfile.enabled = YES;
    }
}

- (NSManagedObjectContext *)managedObjectContext {

    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark - Ok button tapped
- (IBAction)tappedOKButton:(id)sender{

    if (self.txtstatement.text.length == 0) {
        UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your statement." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msgAlert show];
        return;
    }

    if (self.txtlanguage.text.length == 0) {
        UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select language." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msgAlert show];
        return;
    }

  [self insertDataInDataBase];
}

- (void)insertDataInDataBase{

    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Believe" inManagedObjectContext:context];
    [newStatement setValue:self.txtstatement.text forKey:@"statement"];
}

#pragma mark - UIText field button tapped
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    if (textField == self.txtFldWebLink) {
        if(self.txtFldPathOfUploadFile.hidden == YES) {
            self.vScrollView.contentOffset = CGPointMake(0, self.vScrollView.contentSize.height);
            self.vScrollView.contentSize = CGSizeMake(self.vScrollView.contentSize.width, self.vScrollView.contentSize.height + 160);
        } else {
            self.vScrollView.contentOffset = CGPointMake(0,640);
            self.vScrollView.contentSize = CGSizeMake(self.vScrollView.contentSize.width, self.vScrollView.contentSize.height + 200);
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if (textField == self.txtFldWebLink){
        self.vScrollView.contentOffset = CGPointMake(0, 0);
        self.vScrollView.contentSize = CGSizeMake(self.vScrollView.contentSize.width, self.vScrollView.contentSize.height - 160);
    }
}

#pragma mark - Get all list
- (void)getAlllanguageList {

    if ([ConstantClass checkNetworkConection] == YES) {

        [self.api callGETUrl:nil method:@"/api/v1/languages" success:^(AFHTTPRequestOperation *task, id responseObject) {

            NSArray *arryLanguage = [[responseObject valueForKey:@"data"]valueForKey:@"language"];
            for (NSDictionary *dictResponse in arryLanguage) {
                NSString *laungID;
                NSString *lName;
                laungID = [dictResponse objectForKey:@"id"];
                lName = [dictResponse objectForKey:@"name"];

                [self.arryLanguage addObject:lName];
                [self.arryLanguageId addObject:laungID];
            }

        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        }];
    }
}

#pragma mark - Language btn is tapped
- (IBAction)languageBtnTapped:(id)sender {

    [self.view endEditing:YES];
    [ActionSheetPicker displayActionPickerWithView:self.view data:self.arryLanguage selectedIndex:0 target:self action:@selector(setLanguageToField::) title:@"Language" width:320];
}

- (void)setLanguageToField:(NSString *)selectedMonth :(id)element {

    self.txtlanguage.text = [self.arryLanguage objectAtIndex:selectedMonth.intValue];
    selectedLauguageId = [[self.arryLanguageId objectAtIndex:selectedMonth.intValue] intValue];
}

#pragma mark - Segment button change
- (IBAction)indexChangedofUploadData:(UISegmentedControl *)sender {

  [self.view endEditing:YES];
    if (self.segUpload.selectedSegmentIndex == 0) {
        alertSelectFile = [[UIAlertView alloc] initWithTitle:@"Select From Device" message:nil delegate:self cancelButtonTitle:@"Select" otherButtonTitles:@"Cancel", nil];
        [alertSelectFile show];
    } else if (self.segUpload.selectedSegmentIndex == 1) {
        alertYouTube = [[UIAlertView alloc] initWithTitle:@"Youtube" message:@"Please enter youtube url." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        alertYouTube.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[alertYouTube textFieldAtIndex:0] setPlaceholder:@"placeholder text..."];
        [alertYouTube show];
    }
}

#pragma mark - Get all category
- (void)getAllCategory {

    if ([ConstantClass checkNetworkConection] == YES) {

        dispatch_queue_t queue = dispatch_queue_create("category", NULL);
        dispatch_async(queue, ^ {
            dispatch_async (dispatch_get_main_queue(), ^{
                [self.api callGETUrl:nil method:@"/api/v1/categories" success:^(AFHTTPRequestOperation *task, id responseObject) {

                    NSArray *arryCategory = [[responseObject valueForKey:@"data"]valueForKey:@"categories"];
                    for (NSDictionary *dictResp in arryCategory) {
                        NSNumber *catId = [dictResp valueForKey:@"id"];
                        NSString *catName = [dictResp valueForKey:@"name"];
                        NSNumber *sortOder = [dictResp valueForKey:@"sort_order"];
                        NSDictionary *dictCat = @{@"name":catName, @"id":catId, @"sortOder":sortOder};
                        [self.arryCategory addObject:dictCat];
                    }

                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOder"
                                                                                   ascending:YES];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                    NSArray *sortedArray = [self.arryCategory sortedArrayUsingDescriptors:sortDescriptors];
                    [self.arryCategory removeAllObjects];
                    self.arryCategory = [sortedArray mutableCopy];

                    [self addCheckBoxWithLabel];
                } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                }];
            });
        });
    }
}

- (void)chooseFileFromDirectory {

    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - UIImage picker view delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    if ([type isEqualToString:(NSString *)kUTTypeVideo] || [type isEqualToString:(NSString *)kUTTypeMovie]) {//

        urlOfFile = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *dataVideo = [NSData dataWithContentsOfURL:urlOfFile];
        strImageString = [dataVideo base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        typeOfUploadFile = @"video.mp4";
    } else {

        UIImage *cameraImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSData *dataImage = UIImagePNGRepresentation(cameraImage);

        strImageString = [dataImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        urlOfFile = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        typeOfUploadFile = @"image.jpg";
    }

    [self showPathOfFile];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView == alertYouTube) {

        if (buttonIndex == 0) {
            
            NSString *strPath = [alertView textFieldAtIndex:0].text;
            urlYoutube = [NSURL URLWithString:strPath];

            if (strPath.length != 0) {
                [self showPathOfFile];
                self.txtFldPathOfUploadFile.text = strPath;
                typeOfUploadFile = @"video";
                strImageString = 0;
            }
        }
    } else if (alertView == alertSelectFile) {

        if (buttonIndex == 0) {
            [self chooseFileFromDirectory];
        }
    } else if (alertView == alertVwSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Show path of file in field
- (void)showPathOfFile {

    if (self.txtFldPathOfUploadFile.hidden == YES) {

        [self.txtFldPathOfUploadFile setCustomImgVw:@"" withWidth:self.view.frame.size.width - 100];
        self.txtFldPathOfUploadFile.hidden = NO;
        self.txtFldPathOfUploadFile.backgroundColor = [UIColor whiteColor];

        self.txtFldPathOfUploadFile.frame = CGRectMake(self.view.frame.size.width - 190, self.txtFldWebLink.frame.origin.y , 170, self.txtFldPathOfUploadFile.frame.size.height);

        self.txtFldWebLink.frame = CGRectMake(self.txtFldWebLink.frame.origin.x, self.txtFldWebLink.frame.origin.y+50, self.txtFldWebLink.frame.size.width, self.txtFldWebLink.frame.size.height);

        self.segPublishStatement.frame = CGRectMake(20,  self.segPublishStatement.frame.origin.y + 50, self.view.frame.size.width - 40, self.segPublishStatement.frame.size.height);

        self.btnOK.frame = CGRectMake(self.btnOK.frame.origin.x, self.btnOK.frame.origin.y+ 50, self.btnOK.frame.size.width, self.btnOK.frame.size.height);
    }
    self.txtFldPathOfUploadFile.text = urlOfFile.absoluteString;
}

#pragma mark - Add belief button tapped
- (IBAction)addNewBliefBtnTapped:(id)sender {

    NSMutableArray *arryselectedCategory = [[NSMutableArray alloc]init];
    [self startAnimation];

    for (int i = 0 ; i<self.arryCategorybtnList.count; i ++) {

        M13Checkbox *checkBtn = [self.arryCategorybtnList objectAtIndex:i];
        if (checkBtn.checkState == 1) {
            [arryselectedCategory addObject:[NSNumber numberWithInteger:checkBtn.tag]];
        }
    }

    if (self.txtstatement.text.length == 0) {
        UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter statement." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msgAlert show];
        [self stopAnimation];
        return;
    }

    if (self.txtlanguage.text.length == 0) {
        UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select language." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msgAlert show];
        [self stopAnimation];
        return;
    }

    if (arryselectedCategory.count == 0) {
        UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select category." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msgAlert show];
        [self stopAnimation];
        return;
    }

    if (strImageString.length == 0 && urlYoutube.absoluteString.length == 0) {
        UIImage *image = [UIImage imageNamed:@"download1"];
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
        strImageString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        typeOfUploadFile = @"image.jpg";
    }

  if (urlYoutube.absoluteString.length != 0) {//youtube
    NSString *strVideoId = [self isValid:urlYoutube];
        if (strVideoId == nil) {
            UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter right youtube url." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [msgAlert show];
            [self stopAnimation];
            return;
        } else{
          NSString *strVideoUrl = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",strVideoId];
          urlYoutube = [NSURL URLWithString:strVideoUrl];
          NSString *strVideoId = [self isValid:urlYoutube];
          if (strVideoId == nil) {
            UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter right youtube url." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [msgAlert show];
            [self stopAnimation];
            return;
          }
        }
    }

    if ([ConstantClass checkNetworkConection] == NO) {
        return;
    }

    if (strImageString.length == 0) {
        strImageString = @"";
    }

    if (chkShowOnProfile.checkState == 1) {
        isAuther = 1;
    } else {
        isAuther = 0;
    }

    if (chkAuthor.checkState == 1) {
        isAuther = 1;
    }
    NSString *strWebUrl= @"";
    if (self.txtFldWebLink.text.length != 0) {
        strWebUrl = [NSString stringWithFormat:@"https://%@" ,self.txtFldWebLink.text];
    }
    dispatch_queue_t queue = dispatch_queue_create("post Belief", NULL);
    dispatch_async(queue, ^ {
        dispatch_async (dispatch_get_main_queue(), ^{

            NSDictionary *param = @{@"text":self.txtstatement.text,
                                    @"language_id":[NSString stringWithFormat:@"%i", selectedLauguageId],
                                    @"youtube_url":urlYoutube,
                                    @"category_ids":arryselectedCategory,
                                    @"is_publish":[NSNumber numberWithBool:is_publish],
                                    @"show_author": [NSNumber numberWithBool:isAuther],
                                    @"belief_image":strImageString,
                                    @"belief_url":strWebUrl
                                    };

            NSDictionary *dict;
            if (strImageString.length != 0) {
                if ([typeOfUploadFile isEqualToString:@"video.mp4"]) {
                    dict = @{@"belief": param, @"file_name":typeOfUploadFile, @"system_video":@"Video"};
                } else {
                    dict = @{@"belief": param, @"file_name":typeOfUploadFile};
                }
            } else {
                dict = @{@"belief": param};
            }

        [self.api callPostUrlWithHeader:dict method:@"/api/v1/beliefs" success:^(AFHTTPRequestOperation *task, id responseObject) {

            [self stopAnimation];
             alertVwSuccess = [[UIAlertView alloc]initWithTitle:@"Success!!!"message:@"Successfully add belief." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertVwSuccess show];
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {

            [self stopAnimation];
            NSString *jsonMessage = task.responseString;
            NSData *data = [jsonMessage dataUsingEncoding:NSUTF8StringEncoding];
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *dictMessage = (NSDictionary *)jsonResponse;
            NSString *msg = [[dictMessage valueForKey:@"info"]objectAtIndex:0];
            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error"message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertVw show];
            [self stopAnimation];
            }];
        });
    });
}

- (NSString*)isValid:(NSURL *)youtubeVideoURL {

    NSString *regexString = @"^(?:http(?:s)?://)?(?:www\\.)?(?:youtu\\.be/|youtube\\.com/(?:(?:watch)?\\?(?:.*&)?v(?:i)?=|(?:embed|v|vi|user)/))([^\?&\"'>]+)";
    NSError *error;
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:regexString
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:self.txtFldPathOfUploadFile.text
                                                    options:0
                                                      range:NSMakeRange(0, [self.txtFldPathOfUploadFile.text length])];

    if (match && match.numberOfRanges == 2) {
        NSRange videoIDRange = [match rangeAtIndex:1];
        NSString *videoID = [self.txtFldPathOfUploadFile.text substringWithRange:videoIDRange];
        return videoID;
    }
    return nil;
}

- (IBAction)segmentActionOfPublish:(id)sender {

  UISegmentedControl *segment = (UISegmentedControl*)sender;
  NSInteger index = segment.selectedSegmentIndex;

  if (index == 0) {
    is_publish = YES;
  } else {
    [self saveStatementAsDraft];
  }
}


- (void)saveStatementAsDraft{

  NSMutableString *strCategories = [[NSMutableString alloc]init];

  if (self.txtstatement.text.length == 0) {
    self.segPublishStatement.selectedSegmentIndex = 0;
    UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter statement." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [msgAlert show];
    [self stopAnimation];
    return;
  }

  for (int i = 0 ; i<self.arryCategorybtnList.count; i ++) {
    M13Checkbox *checkBtn = [self.arryCategorybtnList objectAtIndex:i];
    if (checkBtn.checkState == 1) {
      [strCategories  appendString:[NSString stringWithFormat:@"%@,",[NSNumber numberWithInteger:checkBtn.tag]]];
    }
  }
  
  NSString *strDraftId = self.objDraft.draftId != nil ? self.objDraft.draftId : [NSString stringWithFormat:@"%ld",(long)([[NSDate date] timeIntervalSince1970])];
    
  NSDictionary *dictStatement = @ {@"statement":self.txtstatement.text,
                                    @"categories":strCategories,
                                    @"language":self.txtlanguage.text,
                                    @"languageId":[NSString stringWithFormat:@"%i",selectedLauguageId],
                                    @"auther":[NSNumber numberWithBool:chkAuthor.checkState],
                                    @"draftId":strDraftId,
                                    @"userid": userObject.userid
                                    };

  [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
    [Draft entityWithDictionary:dictStatement inContext:localContext];
  } completion:^(BOOL success, NSError *error) {
      [self showSavedAsDraftsAlerts];
  }];
}

- (void)showDraftInfo:(Draft *)draft {
  
  self.objDraft = draft;
    
  self.txtstatement.text = draft.statement;
  self.txtlanguage.text = draft.langName;
  selectedLauguageId = draft.languageId.intValue;
  chkAuthor.checkState = draft.auther.boolValue;
  arrySelectCategory = [draft.categories componentsSeparatedByString:@","];
  for (int i=0; i<self.arryCategorybtnList.count; i++) {

    M13Checkbox *checkBtn = [self.arryCategorybtnList objectAtIndex:i];
    if ([arrySelectCategory containsObject:[NSString stringWithFormat:@"%i",(int) checkBtn.tag]]) {
      checkBtn.checkState = 1;
    }
   }
}

// Load page when view come from left panel
- (void)viewComeFromLeftPanel {
    if (self.isFromLeftMenu) {
        [self showDraftInfo:self.objDraft];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)showSavedAsDraftsAlerts {
    [self.navigationController popViewControllerAnimated:YES];
    UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Successfully saved as draft." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [msgAlert show];
}

@end
