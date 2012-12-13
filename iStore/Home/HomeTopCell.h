//
//  HomeTopCell.h
//  iStore
//
//  Created by 林世木 on 12/10/16.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTopCell: UITableViewCell{
    id mainObject;
    
    UIScrollView *scrollView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withObject:(id)obj;@end
