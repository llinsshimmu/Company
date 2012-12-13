//
//  ProductDetailHeaderCell.m
//  iStore
//
//  Created by 林世木 on 12/11/2.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "ProductDetailHeaderCell.h"

@implementation ProductDetailHeaderCell
@synthesize nameLabel;
@synthesize priceLabel;
@synthesize productImageView;
@synthesize introLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withObj:(id)obj
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        mainObj = obj;
        
        //product image 80h
        self.productImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.productImageView];
        
        //product name
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        
        //product price
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = [UIFont systemFontOfSize:12.0f];
        self.priceLabel.numberOfLines = 1;
        self.priceLabel.textAlignment = UITextAlignmentCenter;
        self.priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:self.priceLabel];
        
        //try button
        tryButton = [[UIButton alloc] init];
        [tryButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
        [tryButton setTitle:@"好玩，试穿一下" forState:UIControlStateNormal];
        [tryButton addTarget:mainObj action:@selector(tryAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:tryButton];
        
        //buy button
        buyButton = [[UIButton alloc] init];
        [buyButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [buyButton addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:buyButton];
        
        //intro image icon
        introImage = [[UIImageView alloc] init];
        introImage.image = [UIImage imageNamed:@"detail_intro_label.png"];
        [self.contentView addSubview:introImage];

        //intro label
        self.introLabel = [[UILabel alloc] init];
        self.introLabel.font = [UIFont systemFontOfSize:10.0f];
        self.introLabel.numberOfLines = 4;
        self.introLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.introLabel];
        
        //comment label
        commentImage = [[UIImageView alloc] init];
        commentImage.image = [UIImage imageNamed:@"detail_comment_label.png"];
        [self.contentView addSubview:commentImage];
        
        //comment btn
        commentButton =  [[UIButton alloc] init];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"detail_comment_btn.png"] forState:UIControlStateNormal];
        [commentButton setTitle:@"发表评论" forState:UIControlStateNormal];
        [commentButton addTarget:mainObj action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:commentButton];
    }
    return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews]; //400
    
    CGSize cellSize = self.contentView.bounds.size;
    self.productImageView.frame = CGRectMake(50.0f, 5.0f, cellSize.width-100, 200);
    
    //product name
    self.nameLabel.frame = CGRectMake(0.0f, 200.0f, cellSize.width, 20.0f);
    
    
    //product price
    self.priceLabel.frame = CGRectMake(0.0f, 220.0f, cellSize.width, 15.0f);
    
    //try btn
    tryButton.frame = CGRectMake(30.0f, 250.0f, 120.0f, 30.0f);
    
    //buy btn
    buyButton.frame = CGRectMake(180.0f, 250.0f, 120.0f, 30.0f);

    //intro iamge
    introImage.frame = CGRectMake(50.0f,300.0f, cellSize.width-100.0f, 30.0f);
    
    //intro label
    self.introLabel.frame = CGRectMake(50.0f, 330.0f, cellSize.width-100.0f, 80.0f);
    
    //comment image
    commentImage.frame  = CGRectMake(50.0f, 420.0f, cellSize.width-100.0f, 30.0f);
    
    //comment btn
    commentButton.frame = CGRectMake(200.0f, 425.0f, 80.0f, 20.0f);
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
