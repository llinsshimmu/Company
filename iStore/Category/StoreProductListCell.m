//
//  StoreProductListCell.m
//  iStore
//
//  Created by 林世木 on 12/11/2.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "StoreProductListCell.h"

@implementation StoreProductListCell
@synthesize nameLabel;
@synthesize priceLabel;
@synthesize productImageView;
@synthesize introLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //product image 80h
        self.productImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.productImageView];
        
        //product name
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.nameLabel.numberOfLines = 1;
        [self.contentView addSubview:self.nameLabel];
        
        //product price
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = [UIFont systemFontOfSize:12.0f];
        self.priceLabel.numberOfLines = 1;
        self.priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:self.priceLabel];
        
        //intro label
        self.introLabel = [[UILabel alloc] init];
        self.introLabel.font = [UIFont systemFontOfSize:10.0f];
        self.introLabel.numberOfLines = 4;
        self.introLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.introLabel];
        
    }
    return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

    CGSize cellSize = self.contentView.bounds.size;
    self.productImageView.frame = CGRectMake(5.0f, 5.0f, 90, cellSize.height-10);
    
    //product name
    self.nameLabel.frame = CGRectMake(110.0f, 5.0f, cellSize.width- 120.0f, 20.0f);

    //product price
    self.priceLabel.frame = CGRectMake(110.0f, 30.0f, cellSize.width-120.0f, 15.0f);
    
    //intro label
    self.introLabel.frame = CGRectMake(110.0f, 45.0f, cellSize.width-120.0f, 40.0f);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
