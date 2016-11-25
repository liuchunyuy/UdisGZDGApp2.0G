//
//  SuscPerCellTableViewCell.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/10/21.
//  Copyright © 2016年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuscPerModel.h"
#import "SuscPerListViewController.h"
@interface SuscPerCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *recordTimeLabel;

@property (nonatomic,strong) SuscPerModel *model;

@end
