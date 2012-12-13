//
//  ProductCommentCell.h
//  iStore
//
//  Created by 林世木 on 12/11/2.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCommentCell : UITableViewCell{
    UILabel *commentLabel;
    UILabel *commentTimeLabel;
    UILabel *usernameLabel;
}
@property (strong,nonatomic) UILabel *commentLabel;
@property (strong,nonatomic) UILabel *commentTimeLabel;
@property (strong,nonatomic) UILabel *usernameLabel;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
