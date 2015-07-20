//
//  ModeratorViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 09/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "ModeratorViewController.h"
#import "ModeratorCell.h"

@interface ModeratorViewController ()

@property (nonatomic, strong) AppApi *api;
@property (nonatomic, strong) NSMutableArray *arryFlag;

@end

@implementation ModeratorViewController

#pragma mark - View life cycle
- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];

    [self defaulUISettings];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.hidden = false;
    self.tabBarController.title = @"Moderation";
    self.arryFlag = [[NSMutableArray alloc]init];
    self.tbleVwFlag.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    [self getListingOfFlag];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    self.tabBarController.title = @"Moderator";
    self.tbleVwFlag.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set default setting
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
}

#pragma mark - UITable view Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self arryFlag] count];
}

#pragma mark - UITable view Delegates
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ModeratorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moderator" forIndexPath:indexPath];
    NSDictionary *dictFlag = [self.arryFlag objectAtIndex:indexPath.row];
    [cell setFlagValues:dictFlag target:self forRow:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *strReason = [[self.arryFlag objectAtIndex:indexPath.row] valueForKey:@"text"];
    CGRect rectReason =[strReason boundingRectWithSize:CGSizeMake(self.tbleVwFlag.frame.size.width - 20, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    NSString *strBelief =[[[self.arryFlag objectAtIndex:indexPath.row] valueForKey:@"belief"]valueForKey:@"text"];
    CGRect rect =[strBelief boundingRectWithSize:CGSizeMake(self.tbleVwFlag.frame.size.width - 20, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    return  (rect.size.height + rectReason.size.height + 120);
}

#pragma mark - Delete belief
- (IBAction)deleteBelief:(id)sender {

    UIButton *btn = (UIButton *)sender;
    NSDictionary *param = @{@"id":[[self.arryFlag objectAtIndex:btn.tag]valueForKey:@"id"]};
    [self.api callPostUrl:param method:@"/api/v1/remove_belief" success:^(AFHTTPRequestOperation *task, id responseObject) {
        [self.arryFlag removeObjectAtIndex:btn.tag];
        [self.tbleVwFlag reloadData];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    }];
}

#pragma mark - Dismiss Flg
- (IBAction)dismissFlag:(id)sender {

    UIButton *btn = (UIButton *)sender;
    NSDictionary *param = @{@"id":[[self.arryFlag objectAtIndex:btn.tag]valueForKey:@"id"]};

    [self.api callPostUrl:param method:@"/api/v1/dismiss_flag" success:^(AFHTTPRequestOperation *task, id responseObject) {

        [self.arryFlag removeObjectAtIndex:btn.tag];
        [self.tbleVwFlag reloadData];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    }];
}

#pragma mark - Get listing of flag
- (void)getListingOfFlag {

    [self.arryFlag removeAllObjects];
    [self.api callGETUrl:nil method:@"/api/v1/flag_index" success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSArray *arry = [responseObject objectForKey:@"flag"];
        if (arry.count == 0) {
            return ;
        }
        for (NSDictionary *dictFlag in arry) {
            [self.arryFlag addObject:dictFlag];
        }
        [self.tbleVwFlag reloadData];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {

    }];
}

@end
