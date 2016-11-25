//
//  SuscPerModel.h
//  UdisFaceLockApp
//
//  Created by GavinHe on 16/10/21.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "JSONModel.h"

@interface SuscPerModel : JSONModel
@property (nonatomic, copy) NSString *FaceRecordID;
@property (nonatomic, copy) NSString *MgEmpImg;
@property(nonatomic,copy) NSString *MgEmpName;
@property (nonatomic, copy) NSString *MgEmpNo;
@property (nonatomic, copy) NSString *MgEmpPhone;
@property(nonatomic,copy) NSString *MgEmpType;
@property(nonatomic,copy) NSString *RecordTime;
@property (nonatomic, copy) NSString *UserId;
@end
