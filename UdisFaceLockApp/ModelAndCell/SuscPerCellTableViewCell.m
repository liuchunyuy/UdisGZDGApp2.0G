//
//  SuscPerCellTableViewCell.m
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/10/21.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "SuscPerCellTableViewCell.h"

@implementation SuscPerCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(SuscPerModel *)model{
    
    if (_model != model) {
        _model = model;
        
        if (model.MgEmpImg == 0) {
            [_image setImage:[UIImage imageNamed:@"user"]];
        }else{        
            [_image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", _model.MgEmpImg]]];
        }
        
        _nameLabel.text = [NSString stringWithFormat:@"%@",model.MgEmpName];
        _typeLabel.text = [NSString stringWithFormat:@"%@",model.MgEmpType];
        _phoneLabel.text = [NSString stringWithFormat:@"Tel: %@",model.MgEmpPhone];
        _recordTimeLabel.text = [NSString stringWithFormat:@"记录时间: %@",model.RecordTime];
        
    }
}

@end








