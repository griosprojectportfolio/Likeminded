//
//  AdminCustomCell.h
//  Voteatlas1
//
//  Created by GrepRuby on 09/04/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdminViewController.h"

@protocol AdminCellDelegate <NSObject>

- (void)handleDownEvent:(NSInteger)tag;
- (void)handleUpEvent:(NSInteger)tag;
- (void)handleDeleteEvent:(NSInteger)tag;
- (void)handleEditEvent:(NSInteger)tag;

@end

@interface AdminCustomCell : UITableViewCell {

    NSInteger count;
}

@property (nonatomic, strong) IBOutlet UIButton *btnUp;
@property (nonatomic, strong) IBOutlet UIButton *btnDown;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit;
@property (nonatomic, strong) IBOutlet UILabel *lblCategory;

@property (unsafe_unretained) id <AdminCellDelegate>delegate;

- (void)setValuesOfAdminCell:(NSDictionary *)dictCat forRow:(NSInteger)row listCount:(NSInteger)listCount ;

@end
