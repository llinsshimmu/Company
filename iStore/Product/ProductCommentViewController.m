//
//  ProductCommentViewController.m
//  iStore
//
//  Created by 林世木 on 12/10/12.
//  Copyright (c) 2012年 林世木. All rights reserved.
//

#import "ProductCommentViewController.h"
#import "JsonParseOperation.h"


@interface ProductCommentViewController ()

@end

@implementation ProductCommentViewController

- (id)initWithObject:(id)obj withProductId:(NSString *)value
{
    self = [super init];
    if (self) {
        mainObject = obj;
        productid = value;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    operationQueue = [[NSOperationQueue alloc] init];
    viewSize = self.view.bounds.size;

    
    UIButton *commentButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f,0.0f,80.0f,35.0f)];
    [commentButton setTitle:@"确认评价" forState:UIControlStateNormal];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [commentButton setBackgroundImage:[UIImage imageNamed:@"nav_login_btn.png"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:commentButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    textView = [[UITextView alloc] init];
    textView.textColor = [UIColor blackColor]; //设置textview里面的字体颜色
    textView.font = [UIFont fontWithName:@"Arial" size:18.0]; //设置字体名字和字体大小
    textView.backgroundColor = [UIColor lightGrayColor]; //设置它的背景颜色
    textView.returnKeyType = UIReturnKeyGo; //返回键的类型
    textView.keyboardType = UIKeyboardTypeDefault; //键盘类型
    textView.scrollEnabled = YES;  //是否可以拖动
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight; //自适应高度
    textView.frame = CGRectMake(10.0f, 10.0f, 300.0f, 300.0f);
    [textView becomeFirstResponder];
    
    [self.view addSubview:textView];
    

}

- (void)commentButtonClicked:(id)sender
{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *urlStr =@"http://api.tengchen.com:90/Product/remoteProductCommentSubmit.do";
    
    NSArray *columnPostArray = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"userid",@"key",[ud objectForKey:@"userid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid",@"key",[ud objectForKey:@"sessionid"],@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"productid",@"key",productid,@"value", nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"memo",@"key",textView.text,@"value", nil],
                                nil];
    NSLog(@"%@",columnPostArray);
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(commentFeedBackResult:) withURL:urlStr withPostKeyValue:columnPostArray];
    
    [operationQueue addOperation:jsonParseOperation];

}


- (void)commentFeedBackResult:(NSDictionary *)returnDic
{
    NSLog(@"%@",[returnDic objectForKey:@"msg"]);
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        [self.navigationController popViewControllerAnimated:YES];

        
    } else {
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
