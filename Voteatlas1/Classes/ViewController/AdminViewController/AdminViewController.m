//
//  AdminViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 09/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "AdminViewController.h"
#import "AdminCustomCell.h"

@interface AdminViewController () <AdminCellDelegate, UITextFieldDelegate, UIAlertViewDelegate> {

    CustomTextField *txtFldCatUpdate;
    UIView *vwOverlay;
    UIAlertView *alertvwDeleteCategory;
}

@property(nonatomic,strong)AppApi *api;
@property(nonatomic,strong) NSMutableArray *arrayCategory;

@end

@implementation AdminViewController

#pragma mark - View life cycle

- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];

    [self defaulUISettings];

    self.arrayCategory = [[NSMutableArray alloc]init];
    [self getAllCategory];
    self.title = @"Category";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        // [self.navigationController.navigationBar setHidden:YES];
    self.tabBarController.title = @"Category";
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]};

//    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTapped)];
//    btnBack.tintColor = [UIColor setCustomColorOfTextField];
//    [self.navigationItem setLeftBarButtonItem:btnBack];
}

#pragma mark - Back btn tapped
- (void)backBtnTapped {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Get all category

- (void)getAllCategory {

    dispatch_queue_t queue = dispatch_queue_create("category", NULL);
    dispatch_async(queue, ^ {
        dispatch_async (dispatch_get_main_queue(), ^{
            [self.api callGETUrl:nil method:@"/api/v1/categories" success:^(AFHTTPRequestOperation *task, id responseObject) {

                [self.arrayCategory removeAllObjects];
                NSArray *arryCategory = [[responseObject valueForKey:@"data"]valueForKey:@"categories"];

                for (NSDictionary *dictResp in arryCategory) {
                    NSNumber *catId = [dictResp valueForKey:@"id"];
                    NSString *catName = [dictResp valueForKey:@"name"];
                    NSNumber *sortOder = [dictResp valueForKey:@"sort_order"];
                    NSDictionary *dictCat = @{@"name":catName, @"id":catId, @"sortOder":sortOder};
                    [self.arrayCategory addObject:dictCat];
                }

                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortOder"
                                                             ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                NSArray *sortedArray = [self.arrayCategory sortedArrayUsingDescriptors:sortDescriptors];
                [self.arrayCategory removeAllObjects];
                self.arrayCategory = [sortedArray mutableCopy];
                [self.tbleVwCategory reloadData];

            } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            }];
        });
    });
}

#pragma mark - Set default UI settings
- (void)defaulUISettings {

    if (IS_IPHONE_4_OR_LESS) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG4.png"]];
    }
    if (IS_IPHONE_5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG5.png"]];
    }
    if (IS_IPHONE_6) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG6.png"]];
    }
    if (IS_IPHONE_6P) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG6Pluse.png"]];
    }

    self.tbleVwCategory.frame = CGRectMake(0, 0, self.tbleVwCategory.frame.size.width, self.view.frame.size.height - 225);
    self.tbleVwCategory.separatorColor = [UIColor clearColor];
    self.tbleVwCategory.backgroundColor = [UIColor clearColor];

    self.txtFldCat.frame = CGRectMake(self.txtFldCat.frame.origin.x,self.tbleVwCategory.frame.origin.y + self.tbleVwCategory.frame.size.height +5, self.txtFldCat.frame.size.width, 40);
    self.txtFldCat.returnKeyType = UIReturnKeyDone;
    [self.txtFldCat setCustomImgVw:@"" withWidth:self.view.frame.size.width - 20];
    self.txtFldCat.textColor = [UIColor setCustomColorOfTextField];
    self.txtFldCat.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Your Category" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    self.btnAdd.frame = CGRectMake(self.txtFldCat.frame.origin.x,self.txtFldCat.frame.origin.y+60,self.txtFldCat.frame.size.width/2 - 10, 40);
    self.btnAdd.layer.borderWidth = 0.5;
    self.btnAdd.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    self.btnAdd.layer.cornerRadius = 5.0;
    self.btnAdd.backgroundColor = [UIColor setCustomSignUpColor];

    self.btnSaveSortOrder.frame = CGRectMake(self.btnAdd.frame.size.width+self.btnAdd.frame.origin.x+17, self.btnAdd.frame.origin.y, self.btnAdd.frame.size.width, 40);
    self.btnSaveSortOrder.hidden = YES;
    self.btnSaveSortOrder.layer.borderWidth = 0.5;
    self.btnSaveSortOrder.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    self.btnSaveSortOrder.layer.cornerRadius = 5.0;
    self.btnSaveSortOrder.backgroundColor = [UIColor setCustomSignUpColor];
}

#pragma mark - Add new caterogy
- (IBAction)addNewCategory:(id)sender {
    [self.view endEditing:YES];
    NSDictionary *dict = @{@"name":self.txtFldCat.text,
                            @"sort_order":[NSNumber numberWithInteger:self.arrayCategory.count]};

    NSDictionary *param = @{@"category":dict};
    [self.api callPostUrl:param method:@"/api/v1/categories" success:^(AFHTTPRequestOperation *task, id responseObject) {

        [self getAllCategory];
        UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Add new category." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertVw show];
        self.txtFldCat.placeholder = @"Enter Your Category";

    } failure:^(AFHTTPRequestOperation *task, NSError *error) {

    }];
}

#pragma mark - Save sort order
- (IBAction)saveSortOrder:(id)sender {

    NSMutableArray *arrySortCat = [[NSMutableArray alloc]init];
    for (int iLoop=0; iLoop<self.arrayCategory.count; iLoop++) {

        NSDictionary *category = [self.arrayCategory objectAtIndex:iLoop];
        NSDictionary *dict = @{@"id":[category valueForKey:@"id"],
                               @"order":[NSNumber numberWithInt:iLoop]};
        [arrySortCat addObject:dict];
    }

    NSDictionary *param = @{@"category":arrySortCat};

    [self.api callPostUrl:param method:@"/api/v1/update_sort_order" success:^(AFHTTPRequestOperation *task, id responseObject) {
        [self getAllCategory];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {

    }];
}

#pragma mark - UITable view Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self arrayCategory] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdminCustomCell *cell = (AdminCustomCell*)[tableView dequeueReusableCellWithIdentifier:@"adminIdentifier" forIndexPath:indexPath];
    cell.delegate = self;
    NSDictionary *dictCat = [self.arrayCategory objectAtIndex:indexPath.row];
    [cell setValuesOfAdminCell:dictCat forRow:indexPath.row listCount:self.arrayCategory.count];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    NSString *strSuppose = [[self.arrayCategory objectAtIndex:indexPath.row] valueForKey:@"name"];
//    CGRect rect =[strSuppose boundingRectWithSize:CGSizeMake(200, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} context:nil];
//    return rect.size.height+5;
//}

#pragma mark - Handle up event of category
- (void)handleUpEvent:(NSInteger)tag {

    [self.btnSaveSortOrder setHidden:NO];
    AdminCustomCell *cell = (AdminCustomCell*)[self.tbleVwCategory cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag-1 inSection:0]];
    cell.tag = tag;
    NSIndexPath *currentPath = [NSIndexPath indexPathForRow:tag inSection:0];
    NSIndexPath *destinationPath = [NSIndexPath indexPathForRow:tag-1 inSection:0];
    [self.tbleVwCategory moveRowAtIndexPath:currentPath toIndexPath:destinationPath];

    NSDictionary *dict = [self.arrayCategory objectAtIndex:tag];
    [self.arrayCategory removeObjectAtIndex:tag];
    [self.arrayCategory insertObject:dict atIndex:tag-1];
}

#pragma mark - Handle down event of category
- (void)handleDownEvent:(NSInteger)tag {

    [self.btnSaveSortOrder setHidden:NO];
    NSInteger rowTag = tag + 1;
    AdminCustomCell *cell = (AdminCustomCell*)[self.tbleVwCategory cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowTag inSection:0]];
    cell.tag = tag;

    NSIndexPath *currentPath = [NSIndexPath indexPathForRow:tag inSection:0];
    NSIndexPath *destinationPath = [NSIndexPath indexPathForRow:tag+1 inSection:0];
    [self.tbleVwCategory moveRowAtIndexPath:currentPath toIndexPath:destinationPath];

    NSDictionary *dict = [self.arrayCategory objectAtIndex:tag];
    [self.arrayCategory removeObjectAtIndex:tag];
    [self.arrayCategory insertObject:dict atIndex:tag+1];
}

#pragma mark - Handle delete event
- (void)handleDeleteEvent:(NSInteger)tag {

    alertvwDeleteCategory = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Are you sure to delete category?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alertvwDeleteCategory.tag = tag;
    [alertvwDeleteCategory show];
}

#pragma mark - Handle edit event
- (void)handleEditEvent:(NSInteger)tag {

    vwOverlay = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width , self.view.frame.size.height)];
    vwOverlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [self.view addSubview:vwOverlay];
    
    UIView *vwBckground = [[UIView alloc]initWithFrame:CGRectMake(10, 50 , self.view.frame.size.width - 20, 200)];
    vwBckground.backgroundColor = [UIColor whiteColor];
    [vwOverlay addSubview:vwBckground];

    UILabel *lblKeepMePostHeading = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.view.frame.size.width - 30, 21)];
    lblKeepMePostHeading.textColor = [UIColor darkGrayColor];
    lblKeepMePostHeading.text = @"Editing Category";
    lblKeepMePostHeading.font = [UIFont boldSystemFontOfSize:15.0f];
    [vwBckground addSubview:lblKeepMePostHeading];

    UILabel *lblEmailStatusHeading = [[UILabel alloc]initWithFrame:CGRectMake(15, lblKeepMePostHeading.frame.size.height + lblKeepMePostHeading.frame.origin.y + 10, vwBckground.frame.size.width - 30, 42)];
    lblEmailStatusHeading.numberOfLines = 0;
    lblEmailStatusHeading.textColor = [UIColor darkGrayColor];
    lblEmailStatusHeading.text = @"Name";
    [vwBckground addSubview:lblEmailStatusHeading];

     txtFldCatUpdate = [[CustomTextField alloc]initWithFrame:CGRectMake(15, lblEmailStatusHeading.frame.origin.y + lblEmailStatusHeading.frame.size.height +20, vwBckground.frame.size.width - 30, 40) withImage:@""];
    txtFldCatUpdate.returnKeyType = UIReturnKeyDone;
    txtFldCatUpdate.textColor = [UIColor setCustomColorOfTextField];
    txtFldCatUpdate.text = [[self.arrayCategory objectAtIndex:tag]valueForKey:@"name"];
    [vwBckground addSubview:txtFldCatUpdate];

    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSend.frame = CGRectMake((vwBckground.frame.size.width - 150)/2, txtFldCatUpdate.frame.size.height + txtFldCatUpdate.frame.origin.y +20, 150, 30);
    [btnSend setTitle:@"Update Category" forState:UIControlStateNormal];
    btnSend.tag = tag;
    btnSend.backgroundColor = [UIColor setCustomSignUpColor];
    [btnSend addTarget:self action:@selector(updateBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [vwBckground addSubview:btnSend];

    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake((vwBckground.frame.size.width - 50), 10, 44, 40);
    [btnCancel setTitle:@"x" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnCancel.tag = [[[self.arrayCategory objectAtIndex:tag]valueForKey:@"id"]integerValue];
    [btnCancel addTarget:self action:@selector(hideEditVw) forControlEvents:UIControlEventTouchUpInside];
    [vwBckground addSubview:btnCancel];
}

- (void)hideEditVw {
    [vwOverlay removeFromSuperview];
}

#pragma mark - Handle Update btn event
- (void)updateBtnTapped:(id)sender {

    UIButton *btn = (UIButton *)sender;
    NSInteger btnTag = btn.tag;

    NSDictionary *dict = @{@"name":txtFldCatUpdate.text};

    NSInteger catId = [[[self.arrayCategory objectAtIndex:(btnTag)] valueForKey:@"id"]integerValue];
    NSDictionary *param = @{@"category":dict, @"id":[NSNumber numberWithInteger:catId]};
    [self.api callPutUr :param method:@"/api/v1/update_category" success:^(AFHTTPRequestOperation *task, id responseObject) {
        [self getAllCategory];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {

    }];
    [self.view endEditing:YES];
    [self hideEditVw];
}

#pragma mark - UIText field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    int yAxis = 250;
    self.scrollVwCat.contentOffset = CGPointMake(self.scrollVwCat.frame.size.width, yAxis);
    self.scrollVwCat.contentSize = CGSizeMake(self.scrollVwCat.frame.size.width, 730);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    self.scrollVwCat.contentOffset = CGPointMake(self.scrollVwCat.frame.size.width, -64);
    self.scrollVwCat.contentSize = CGSizeMake(self.scrollVwCat.frame.size.width, self.view.frame.size.height-120);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView == alertvwDeleteCategory) {

        if (buttonIndex == 0) {

            NSDictionary *dictionary = [self.arrayCategory objectAtIndex:alertvwDeleteCategory.tag];
            NSDictionary *param = @{@"id":[dictionary objectForKey:@"id"]};
            [self.api callDeleteUrl:param method:@"/api/v1/destroy_category" success:^(AFHTTPRequestOperation *task, id responseObject) {
                [self.arrayCategory removeObjectAtIndex:alertvwDeleteCategory.tag];
                [self.tbleVwCategory reloadData];
            } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                
            }];
        }
    }
}

@end
