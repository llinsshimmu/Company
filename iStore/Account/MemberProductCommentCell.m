//
//  ProductCommentCell.m
//  iStore
//
//  Created by 林世木 on 12/11/2.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "MemberProductCommentCell.h"

@implementation MemberProductCommentCell
@synthesize commentLabel;
@synthesize commentTimeLabel;
@synthesize usernameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        
        //product name
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.commentLabel.numberOfLines = 4;
        self.commentLabel.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:self.commentLabel];
        
        //product price
        self.commentTimeLabel = [[UILabel alloc] init];
        self.commentTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        self.commentTimeLabel.numberOfLines = 1;
        self.commentTimeLabel.textAlignment = UITextAlignmentLeft;
        self.commentTimeLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:self.commentTimeLabel];

        self.usernameLabel = [[UILabel alloc] init];
        self.usernameLabel.font = [UIFont systemFontOfSize:10.0f];
        self.usernameLabel.numberOfLines = 1;
        self.usernameLabel.textAlignment = UITextAlignmentLeft;
        self.usernameLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:self.usernameLabel];
        
    }
    return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];    
    CGSize cellSize = self.contentView.bounds.size;
    
    self.usernameLabel.frame = CGRectMake(60.0f, 5.0f, 130, 15.0f);
    
    self.commentTimeLabel.frame = CGRectMake(150, 5.0f, 150, 15.0f);
    
    self.commentLabel.frame = CGRectMake(60.0f, 20.0f, cellSize.width-10, cellSize.height-20);

    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
