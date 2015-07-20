//
//  ModerateViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 09/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "SearchUserViewController.h"
#import "SearchUserCell.h"

@interface SearchUserViewController () <UISearchBarDelegate>{

    UISearchBar *searchBarVote;
    M13Checkbox *btnCheckBoxPostal;
    M13Checkbox *btnCheckBoxUser;
    M13Checkbox *btnCheckBoxEmail;
}

@property (nonatomic, strong) NSMutableArray *arryCategorySearch;
@property (nonatomic, strong) AppApi *api;

@end

@implementation SearchUserViewController

#pragma mark - UIView life cycle
- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];
    self.arryCategorySearch = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]};
    self.title = @"Users";

    [self configureSearchBar];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    self.tabBarController.title = @"Users";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Configure search bar
- (void)configureSearchBar {

    if (IS_IPHONE_4_OR_LESS) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG4.png"]];
    } else if (IS_IPHONE_5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG5.png"]];
    } else if (IS_IPHONE_6) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG6.png"]];
    } else if (IS_IPHONE_6P) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG6Pluse.png"]];
    }

    searchBarVote = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 80.0,self.view.frame.size.width - 20, 35.0)];
    searchBarVote.searchBarStyle = UISearchBarStyleMinimal;
    searchBarVote.delegate = self;
        //  UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 260.0, 44.0)];
        // [searchBarView addSubview:searchBarVote];
    [self.view addSubview:searchBarVote];

    UILabel *lblSearchBy = [[UILabel alloc]initWithFrame:CGRectMake(10, searchBarVote.frame.origin.y + 50, self.view.frame.size.width - 30, 21)];
    lblSearchBy.textColor = [UIColor whiteColor];
    lblSearchBy.text = @"Search By";
    lblSearchBy.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.view addSubview:lblSearchBy];

    int yAxis = lblSearchBy.frame.size.height + lblSearchBy.frame.origin.y + 5;

    btnCheckBoxEmail = [[M13Checkbox alloc]initWithFrame:CGRectMake(22, yAxis, 20, 20)];
    btnCheckBoxEmail.checkState = 0;
    [self.view  addSubview:btnCheckBoxEmail];

    btnCheckBoxPostal = [[M13Checkbox alloc]initWithFrame:CGRectMake(22, yAxis+30, 20, 20)];
    btnCheckBoxPostal.checkState = 0;
    [self.view  addSubview:btnCheckBoxPostal];

    btnCheckBoxUser = [[M13Checkbox alloc]initWithFrame:CGRectMake(22, yAxis+60, 20, 20)];
    btnCheckBoxUser.checkState = 0;
    [self.view  addSubview:btnCheckBoxUser];

    NSArray *arrySearchCat = @[@"Email", @"Username", @"Postal Code"];
    for (int i=0 ; i<arrySearchCat.count ; i++) {

        NSString *strTitle = [arrySearchCat objectAtIndex:i];

        UILabel *lblCheckBox = [[UILabel alloc]init];
        lblCheckBox.frame = CGRectMake(46, yAxis, 250, 21);
        lblCheckBox.text = strTitle;
        lblCheckBox.textColor = [UIColor whiteColor];
        lblCheckBox.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:lblCheckBox];

        yAxis = yAxis + 30;
    }
    self.tbleVwUsers.frame = CGRectMake(0, yAxis, self.view.frame.size.width, (self.view.frame.size.height- yAxis+110));
    self.tbleVwUsers.backgroundColor = [UIColor clearColor];
    self.tbleVwUsers.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

#pragma mark - UITable view Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self arryCategorySearch] count];
}

#pragma mark - UITable view Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchUser" forIndexPath:indexPath];
    [cell setValueOfSearchUser:[self.arryCategorySearch objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UISearch bar delegates
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    NSDictionary *param;
    [self.view endEditing:YES];
    if (btnCheckBoxEmail.checkState == 1) {
        param = @{@"search":searchBarVote.text,@"email":[NSNumber numberWithInt:1]};
    } else if (btnCheckBoxPostal.checkState == 1) {
        param = @{@"search":searchBarVote.text,@"postal_code":[NSNumber numberWithInt:1]};
    } else if (btnCheckBoxUser.checkState == 1) {
        param = @{@"search":searchBarVote.text,@"user":[NSNumber numberWithInt:1]};
    }

    [self.api callGETUrl:param method:@"/api/v1/admin_search?" success:^(AFHTTPRequestOperation *task, id responseObject) {

        self.arryCategorySearch = (NSMutableArray*)responseObject;
        if (self.arryCategorySearch.count == 0){
            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No record found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertVw show];
        }
        [self.tbleVwUsers reloadData];

    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    }];
}

@end
