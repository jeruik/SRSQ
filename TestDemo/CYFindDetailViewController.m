//
//  CYFindDetailViewController.m
//  TestDemo
//
//  Created by dzb on 17/2/24.
//  Copyright © 2017年 蔡凌云. All rights reserved.
//

#import "CYFindDetailViewController.h"
#import "FindDetailViewCell.h"
#import "FindViewCell.h"

static NSString *const findDetailViewCellID = @"FindDetailViewCellID";
@interface CYFindDetailViewController ()

@end

@implementation CYFindDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"详情";
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindDetailViewCell class]) bundle:nil] forCellReuseIdentifier:findDetailViewCellID];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}
- (void)setUserModel:(FindUserModel *)userModel {
    _userModel = userModel;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:findDetailViewCellID];
    
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    FindViewCell *cell = [[FindViewCell alloc] init];
    cell.userModel = self.userModel;
    [bgView addSubview:cell];
    return bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.userModel.cellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
