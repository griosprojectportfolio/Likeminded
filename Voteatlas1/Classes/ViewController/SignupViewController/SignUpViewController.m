//
//  SignUpViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 13/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "SignUpViewController.h"
#import "LogInViewController.h"
#import "ActionSheetPicker.h"
#import "TableViewController.h"
#import "User.h"

@interface SignUpViewController () {

    UIView *vwDOB;
    int selectedLauguageId;
    UIView *vwOverlay;
    UIActivityIndicatorView *activityIndicator;
    UIAlertView *alertVwVerify;
}

@property (nonatomic, strong)NSMutableArray *arryLanguage;
@property (nonatomic, strong)NSMutableArray *arryLanguageId;
@property (nonatomic, strong)NSMutableArray *arryCountry;
@property (nonatomic, strong)NSMutableArray *arryCity;
@property (nonatomic, strong)NSMutableArray *arryState;
@property (nonatomic, strong)NSMutableArray *arryYears;

@end

@implementation SignUpViewController

#pragma mark - View life cycle
- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.hidden = false;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]};
    usersArray = [[NSMutableArray alloc]init];
    self.arryLanguage = [[NSMutableArray alloc]init];
    self.arryLanguageId = [[NSMutableArray alloc]init];
    self.arryCountry =  [[NSMutableArray alloc]init];
    self.arryCity =  [[NSMutableArray alloc]init];
    self.arryState =  [[NSMutableArray alloc]init];

    [self addUserDetailOfUser];
    self.btnState.hidden = YES;
    self.btnCity.hidden = YES;
    self.gender = @"";

    [self defaulUISettings];

    [self addActivityIndicator];
    [self getAlllanguageList];

    if (self.isGoogle == YES) {
        self.txtUserID.text = self.strGPlusMailId;
        self.txtUserID.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Set default UI
- (void)defaulUISettings {

    self.view.backgroundColor = [UIColor colorWithPatternImage:[ConstantClass imageAccordingToPhone]];
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTapped)];
    btnBack.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setLeftBarButtonItem:btnBack];

    int txtFieldWidth = self.view.frame.size.width - 40;

    [self.txtUserID setCustomImgVw:@"email" withWidth:txtFieldWidth];
    self.txtUserID.textColor = [UIColor setCustomColorOfTextField];
    self.txtUserID.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email/User ID" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [self.txtname setCustomImgVw:@"user" withWidth:txtFieldWidth];
    self.txtname.textColor = [UIColor setCustomColorOfTextField];
    self.txtname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [self.txtNewPassword setCustomImgVw:@"password" withWidth:txtFieldWidth];
    self.txtNewPassword.textColor = [UIColor setCustomColorOfTextField];
    self.txtNewPassword.secureTextEntry = YES;
    self.txtNewPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [self.txtConfirmationPassword setCustomImgVw:@"password" withWidth:txtFieldWidth];
    self.txtConfirmationPassword.secureTextEntry = YES;
    self.txtConfirmationPassword.textColor = [UIColor setCustomColorOfTextField];
    self.txtConfirmationPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [self.txtDOB setCustomImgVw:@"calander" withWidth:txtFieldWidth];
    self.txtDOB.textColor = [UIColor setCustomColorOfTextField];
  
    self.txtDOB.frame = CGRectMake(self.txtDOB.frame.origin.x, self.txtDOB.frame.origin.y, (self.view.frame.size.width/2)- 25, 40);
    self.txtDOB.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Birth Year(Opt)" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField],NSFontAttributeName:[UIFont systemFontOfSize:10]}];

    [self.txtGender setCustomImgVw:@"" withWidth:135];
    self.txtGender.textColor = [UIColor setCustomColorOfTextField];
    self.txtGender.frame = CGRectMake((self.view.frame.size.width/2) + 5,  self.txtDOB.frame.origin.y, self.txtDOB.frame.size.width, 40);
    self.txtGender.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Gender(Opt)" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];
    self.btnGender.frame = self.txtGender.frame;

    [self.txtCountry setCustomImgVw:@"location" withWidth:txtFieldWidth];
    self.txtCountry.textColor = [UIColor setCustomColorOfTextField];
    self.txtCountry.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Country" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [self.txtState setCustomImgVw:@"" withWidth:txtFieldWidth];
    self.txtState.textColor = [UIColor setCustomColorOfTextField];
    self.txtState.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"State / Region" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [self.txtCity setCustomImgVw:@"" withWidth:135];
    self.txtCity.textColor = [UIColor setCustomColorOfTextField];
    self.txtCity.frame = CGRectMake(20,self.txtCity.frame.origin.y , (self.view.frame.size.width/2)- 25, self.txtPostalCode.frame.size.height);
    self.txtCity.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Town / City" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [self.txtPostalCode setCustomImgVw:@"" withWidth:135];
    self.txtPostalCode.textColor = [UIColor setCustomColorOfTextField];
    self.txtPostalCode.frame = CGRectMake((self.view.frame.size.width/2) + 5,self.txtPostalCode.frame.origin.y , self.txtCity.frame.size.width, self.txtPostalCode.frame.size.height);
    self.txtPostalCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Postal Code" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [self.txtPLanguage setCustomImgVw:@"language" withWidth:txtFieldWidth];
    self.txtPLanguage.textColor = [UIColor setCustomColorOfTextField];
    self.txtPLanguage.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Preferred Language" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [self.btnSignUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSignUp setBackgroundColor:[UIColor setCustomSignUpColor]];
    self.btnSignUp.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    
    [self.btnUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnUpdate setBackgroundColor:[UIColor setCustomRedColor]];

    if (self.btnUpdatetag == 5) {
        self.title = @"My Account";
        self.btnSignUp.hidden = YES;
        [self userInfofatch];
        self.txtUserID.userInteractionEnabled = NO;
    } else {
        self.btnUpdate.hidden = YES;
    }

    if (IS_IPHONE_4_OR_LESS| IS_IPHONE_5) {
        [self.vScrollView setContentSize:CGSizeMake(self.vScrollView.frame.size.width, 650)];
    }

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int i2 = [[formatter stringFromDate:[NSDate date]] intValue];

        //Create Years Array from 1960 to This year
    self.arryYears = [[NSMutableArray alloc] init];
    for (int i=1900; i<=i2; i++) {
        [self.arryYears addObject:[NSString stringWithFormat:@"%d",i]];
    }
}

#pragma mark - Add social type
- (void)addUserDetailOfUser {

    if (self.dictUserDetail.count != 0) {
        switch (self.btnTag) {
            case 1:
                strid = [self.dictUserDetail valueForKey:@"id"];
                strProvider = @"Facebook";
                break;
            case 2:
                strid = [self.dictUserDetail valueForKey:@"id"];
                strProvider = @"Twitter";
                break;
            default:
                break;
        }
    }
}

#pragma mark - Date of Birth button tapped
- (IBAction)dateofBirthBtnTapped:(id)sender {

    [self.view endEditing:YES];
    self.vScrollView.contentOffset = CGPointMake(0, 50);
  [ActionSheetPicker displayActionPickerWithView:self.view data:self.arryYears selectedIndex:0 target:self action:@selector(setDateToField::) title:@"Year" width:320];
}

- (void)setDateToField:(NSString *)selectedDate :(id)element {

    self.vScrollView.contentOffset = CGPointMake(0, -64);
    //convert date into string
    NSString *strGivenDate =  [self.arryYears objectAtIndex:selectedDate.intValue];
    self.txtDOB.text = strGivenDate;
}

#pragma mark - Language btn is tapped
- (IBAction)languageBtnTapped:(id)sender {

    [self.view endEditing:YES];
    CGPoint point = CGPointMake(0, 100);
    if (IS_IPHONE_5) {
        point = CGPointMake(0, 150);
    }
    self.vScrollView.contentOffset = point;
    [ActionSheetPicker displayActionPickerWithView:self.view data:self.arryLanguage selectedIndex:0 target:self action:@selector(setLanguageToField::) title:@"Language" width:320];
}

- (void)setLanguageToField:(NSString *)selectedMonth :(id)element {

    self.vScrollView.contentOffset = CGPointMake(0, -64);
    self.txtPLanguage.text = [self.arryLanguage objectAtIndex:selectedMonth.intValue];
    selectedLauguageId = [[self.arryLanguageId objectAtIndex:selectedMonth.intValue] intValue];
}


#pragma mark - State button is tapped
- (IBAction)stateBtnTapped:(id)sender {

    [self.view endEditing:YES];
    [ActionSheetPicker displayActionPickerWithView:self.view data:self.arryState selectedIndex:0 target:self action:@selector(setStateToField::) title:@"State" width:320];
}

- (void)setStateToField:(NSString *)selectedMonth :(id)element {

    self.vScrollView.contentOffset = CGPointMake(0, -64);
    self.txtState.text = [self.arryState objectAtIndex:selectedMonth.intValue];
    if ([ConstantClass checkNetworkConection] == NO) {
        return;
    }

    NSDictionary *param = @{@"state": self.txtState.text};
    [self.api callGETUrl:param method:@"/api/v1/cities" success:^(AFHTTPRequestOperation *task, id responseObject) {
        self.arryCity = [[responseObject valueForKey:@"data"]valueForKey:@"cities"];
        if (self.arryCity.count == 0) {
            self.btnCity.hidden = YES;
        }
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    }];
}

#pragma mark - City btn is tapped
- (IBAction)genderBtnTapped:(id)sender {

    [self.view endEditing:YES];
    NSArray *arryGender = @[@"Male", @"Female", @"None"];
    [ActionSheetPicker displayActionPickerWithView:self.view data:arryGender selectedIndex:0 target:self action:@selector(setGenderToField::) title:@"Gender" width:320];
}

- (void)setGenderToField:(NSString *)selectedGender :(id)element {

    NSArray *arryGender = @[@"Male", @"Female", @"None"];
    self.vScrollView.contentOffset = CGPointMake(0,-64);
    self.txtGender.text = [arryGender objectAtIndex:selectedGender.intValue];
    self.gender = self.txtGender.text;
    if (selectedGender.intValue == 2) {
        self.gender = @"";
        self.txtGender.text = @"";
        self.txtGender.placeholder = @"Gender(Opt)";
    }
}


#pragma mark - City btn is tapped
- (IBAction)cityBtnTapped:(id)sender {

    [self.view endEditing:YES];
    [ActionSheetPicker displayActionPickerWithView:self.view data:self.arryCity selectedIndex:0 target:self action:@selector(setCityToField::) title:@"Ciy" width:320];
}

- (void)setCityToField:(NSString *)selectedMonth :(id)element {

    self.vScrollView.contentOffset = CGPointMake(0,-64);
    self.txtCity.text = [self.arryCity objectAtIndex:selectedMonth.intValue];
}

#pragma mark - Back button tapped
- (void)backBtnTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Gender button tapped
- (IBAction)genderSegmenttapped:(id)sender{

    UISegmentedControl *segDetail = (UISegmentedControl *)sender;
    NSInteger index = segDetail.selectedSegmentIndex;
    if (index == 0) {
        self.gender = @"Male";
    } else{
        self.gender = @"Female";
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

#pragma mark - Sign up button tapped
- (IBAction)btnSignUpTapped:(id)sender {

    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL status = [emailTest evaluateWithObject:self.txtUserID.text];

    if (!status) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter valid email/userID." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }

    if (self.txtname.text.length == 0) {
        UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msgAlert show];
        return;
    }

    if (self.txtCountry.text.length == 0) {
        UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter country." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msgAlert show];
        return;
    }

    if (self.txtState.text.length == 0) {
        UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter State." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msgAlert show];
        return;
    }

    if (self.txtCity.text.length == 0) {
        UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter city." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msgAlert show];
        return;
    }

    if (self.txtPostalCode.text.length == 0) {
        UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter postal Code." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msgAlert show];
        return;
    }

    if (self.txtNewPassword.text.length < 7) {
        UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter password of atleast eight digits." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msgAlert show];
        return;
    }
    if (![self.txtNewPassword.text isEqual:self.txtConfirmationPassword.text]) {

      UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Password Not Matched" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [msgAlert show];
        return;
    }
    [self showActivityIndicator];
    [self userCreateNewAccount];
}

- (void)userCreateNewAccount {

    NSMutableDictionary *dict;
    if (self.dictUserDetail.count != 0) {
        self.dictSocialUserDetail = [[NSMutableDictionary alloc] init];
        [self.dictSocialUserDetail setObject:strid forKey:@"facebook_token"];
        [self.dictSocialUserDetail setObject:strProvider forKey:@"provider"];
        [self.dictSocialUserDetail setObject:self.txtUserID.text forKey:@"email"];
        [self.dictSocialUserDetail setObject:self.txtNewPassword.text forKey:@"password"];
        [self.dictSocialUserDetail setObject:self.txtConfirmationPassword.text forKey:@"password_confirmation"];
        [self.dictSocialUserDetail setObject:self.txtCountry.text forKey:@"country"];
        [self.dictSocialUserDetail setObject:self.txtState.text forKey:@"state"];
        [self.dictSocialUserDetail setObject:self.txtCity.text forKey:@"city"];
        [self.dictSocialUserDetail setObject:self.txtPostalCode.text forKey:@"postal_code"];
        [self.dictSocialUserDetail setObject:self.txtname.text forKey:@"name"];
        [self.dictSocialUserDetail setObject:[NSString stringWithFormat:@"%i", selectedLauguageId] forKey:@"language_id"];
        [self.dictSocialUserDetail setObject:self.gender forKey:@"gender"];
        if (self.txtDOB.text.length != 0){
            [self.dictSocialUserDetail setObject:self.txtDOB.text forKey:@"dob"];
        }
        dict = [[NSMutableDictionary alloc]init];
        [dict setObject:self.dictSocialUserDetail forKey:@"user"];
    } else {
        NSMutableDictionary *dictdata = [[NSMutableDictionary alloc] init];
        [dictdata setObject:self.txtUserID.text forKey:@"email"];
        [dictdata setObject:self.txtNewPassword.text forKey:@"password"];
        [dictdata setObject:self.txtConfirmationPassword.text forKey:@"password_confirmation"];
        [dictdata setObject:self.txtCountry.text forKey:@"country"];
        [dictdata setObject:self.txtState.text forKey:@"state"];
        [dictdata setObject:self.txtCity.text forKey:@"city"];
        [dictdata setObject:self.txtPostalCode.text forKey:@"postal_code"];
        [dictdata setObject:self.txtname.text forKey:@"name"];
        [dictdata setObject:[NSString stringWithFormat:@"%i", selectedLauguageId] forKey:@"language_id"];
        [dictdata setObject:self.gender forKey:@"gender"];
        if (self.txtDOB.text.length != 0){
            [dictdata setObject:self.txtDOB.text forKey:@"dob"];
        }
        dict = [[NSMutableDictionary alloc]init];
        [dict setObject:dictdata forKey:@"user"];
    }

    if ([ConstantClass checkNetworkConection] == NO) {
        return;
    }
    [self.api callPostUrl:dict method:@"/api/v1/registrations" success:^(AFHTTPRequestOperation *task, id responseObject) {
        [User deleteAllEntityObjects];
        [MagicalRecord setupCoreDataStackWithStoreNamed:@"Voteatlas"];

       alertVwVerify = [[UIAlertView alloc]initWithTitle:@"Message" message:@"You must verify your account prior to proceeding to your account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertVwVerify show];
        [self hideActivityIndicator];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {

      [self hideActivityIndicator];
      NSString *jsonMessage = task.responseString; //@"@{sss:asdasd, asd:asdasd}";//
      NSData *data = [jsonMessage dataUsingEncoding:NSUTF8StringEncoding];
      id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

      NSDictionary *dictMessage = (NSDictionary *)jsonResponse;

      NSString *msg;
      if ([[dictMessage valueForKey:@"errors"]count] == 0){
          msg  = @"Sign up is not successfully.Please try again.";
      } else {
          msg = [[dictMessage valueForKey:@"errors"]objectAtIndex:0];
      }
      UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Alert"message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
      [alertVw show];
  }];
}

#pragma mark - Get all language
- (void)getAlllanguageList {

    if ([ConstantClass checkNetworkConection] == NO) {
        return;
    }
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

#pragma mark - UIText field Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return  YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    activetextfield = textField;
    int yAxis = 100;
    if (IS_IPHONE_5|IS_IPHONE_4_OR_LESS) {
        yAxis = 230;
    }
     if (textField == self.txtPostalCode || textField == self.txtCity || textField == self.txtPLanguage){
         self.vScrollView.contentOffset = CGPointMake(0, yAxis);
    }

    if (textField == self.txtCountry || textField == self.txtState) {
        self.vScrollView.contentOffset = CGPointMake(0, yAxis-100);
    }

    [self.vScrollView setContentSize:CGSizeMake(self.vScrollView.frame.size.width, 850)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if (textField == self.txtCountry) {

        NSDictionary *param = @{@"country": self.txtCountry.text};
        [self.api callGETUrl:param method:@"/api/v1/states" success:^(AFHTTPRequestOperation *task, id responseObject) {
            self.arryState = [[responseObject valueForKey:@"data"]valueForKey:@"states"];
            if (self.arryState.count == 0) {
                self.btnState.hidden = YES;
            }
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        }];
    } else if (textField == self.txtState) {

        NSDictionary *param = @{@"state": self.txtState.text};
        [self.api callGETUrl:param method:@"/api/v1/cities" success:^(AFHTTPRequestOperation *task, id responseObject) {
            self.arryCity = [[responseObject valueForKey:@"data"]valueForKey:@"cities"];
            if (self.arryCity.count == 0) {
                self.btnCity.hidden = YES;
            }
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        }];
    }
    self.vScrollView.contentOffset = CGPointMake(0,-64);
    [self.vScrollView setContentSize:CGSizeMake(self.vScrollView.frame.size.width, 650)];
}

- (void)userInfofatch {

    NSArray *arrFetchedData =[User MR_findAll];
    User *userObject = [arrFetchedData objectAtIndex:0];
    self.txtUserID.text = userObject.userid;
    self.txtname.text = userObject.name;
    self.txtCountry.text = userObject.country;
    self.txtState.text = userObject.state;
    self.txtCity.text = userObject.city;
    self.txtPLanguage.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"userlanguage"];
    self.txtPostalCode.text = userObject.postalCode;
    NSString *strGender = userObject.gender;
    if ([strGender isEqualToString:@"Female"]) {
        self.txtGender.text = @"Female";
    } else if ([strGender isEqualToString:@"Male"]) {
       self.txtGender.text = @"Male";
    } else {

    }
}

#pragma mark - Update button tapped
- (IBAction)UpdateTapped:(id)sender {

    [self showActivityIndicator];
    NSMutableDictionary *dictdata = [[NSMutableDictionary alloc] init];
    [dictdata setObject:self.txtUserID.text forKey:@"email"];
    [dictdata setObject:self.txtNewPassword.text forKey:@"password"];
    [dictdata setObject:self.txtConfirmationPassword.text forKey:@"password_confirmation"];
    [dictdata setObject:self.txtCountry.text forKey:@"country"];
    [dictdata setObject:self.txtState.text forKey:@"state"];
    [dictdata setObject:self.txtCity.text forKey:@"city"];
    [dictdata setObject:self.txtPostalCode.text forKey:@"postal_code"];
    [dictdata setObject:self.txtname.text forKey:@"name"];
        //[dictdata setObject:[NSString stringWithFormat:@"%i", selectedLauguageId] forKey:@"language"];
   [dictdata setObject:self.gender forKey:@"gender"];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:dictdata forKey:@"user"];

    [self.api callPutUrlWithHeader:dict method:@"/api/v1/update" success:^(AFHTTPRequestOperation *task, id responseObject) {

        NSDictionary *dictUser = [responseObject valueForKey:@"data"];
         NSMutableArray *arr = [NSMutableArray arrayWithObject:dictUser];
         [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
             [User entityFromArray:arr inContext:localContext];
         } completion:^(BOOL success, NSError *error) {
            [self hideActivityIndicator];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success!!" message:@"Update profile successfuly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
         }];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Data not updated." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        [self hideActivityIndicator];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (alertView == alertVwVerify) {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

#pragma mark - Add Activity indicator
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

- (void) hideActivityIndicator {

    [vwOverlay setHidden:YES];
    [activityIndicator setHidden:YES];
    [activityIndicator stopAnimating];
}

- (void) showActivityIndicator {

    [vwOverlay setHidden:NO];
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
}

@end
