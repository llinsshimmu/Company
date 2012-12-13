//
//  ProductCommentViewController.h
//  iStore
//
//  Created by 林世木 on 12/10/12.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductCommentViewController : UIViewController{
    id mainObject;
    NSString *productid;
    
    NSOperationQueue *operationQueue;

    CGSize viewSize;

    UITextView *textView;

}

- (id)initWithObject:(id)obj withProductId:(NSString *)value;


@end
