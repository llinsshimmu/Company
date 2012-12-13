//
//  HomeRecommendCell.m
//  iStore
//
//  Created by 林世木 on 12/10/16.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "HomeRecommendCell.h"

@implementation HomeRecommendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withObject:(id)obj
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        mainObject = obj;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 120, 30)];
        titleLabel.font = [UIFont systemFontOfSize:17.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"热门商品推荐";
        [self addSubview:titleLabel];
        
        
        
        UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(230.0, 0.0, 80.0, 30.0)];
        [moreButton setTitle:@"更多..." forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [moreButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn"] forState:UIControlStateNormal];
        [moreButton addTarget:mainObject action:@selector(tryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreButton];
        
        //first line
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_try_1.png"]];
        imageView.frame = CGRectMake(5.0f, 30.0f, 150.0f, 80.0f);
        [self addSubview:imageView];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_try_2.png"]];
        imageView2.frame = CGRectMake(165.0f, 30.0f, 150.0f, 80.0f);
        [self addSubview:imageView2];
        
        //second line
        UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_try_3.png"]];
        imageView3.frame = CGRectMake(5.0f, 120.0f, 100.0f, 80.0f);
        [self addSubview:imageView3];
        
        UIImageView *imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_try_4.png"]];
        imageView4.frame = CGRectMake(110.0f, 120.0f, 100.0f, 80.0f);
        [self addSubview:imageView4];
        
        UIImageView *imageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_try_5.png"]];
        imageView5.frame = CGRectMake(215.0f, 120.0f, 100.0f, 80.0f);
        [self addSubview:imageView5];

        

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
