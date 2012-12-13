//
//  StoreProductListCell.h
//  iStore
//
//  Created by 林世木 on 12/11/2.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreProductListCell : UITableViewCell{
    UIImageView *productImageView;
    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *introLabel;

}

@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UIImageView *productImageView;
@property (strong,nonatomic) UILabel *priceLabel;
@property (strong,nonatomic) UILabel *introLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
