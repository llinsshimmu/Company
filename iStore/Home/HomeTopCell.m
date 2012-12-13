//
//  HomeTopCell.m
//  iStore
//
//  Created by 林世木 on 12/10/16.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "HomeTopCell.h"

@implementation HomeTopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withObject:(id)obj
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        mainObject = obj;
        
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,320,100)];
        scrollView.contentSize=CGSizeMake(640,100);
        scrollView.backgroundColor=[UIColor whiteColor];
        [self addSubview:scrollView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_top.png"]];
        imageView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 100.0f);
        [scrollView addSubview:imageView];

        UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_top.png"]];
        imageView2.frame = CGRectMake(320.0f, 0.0f, 320.0f, 100.0f);
        [scrollView addSubview:imageView2];

        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
