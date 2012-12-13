//
//  JsonParseOperation.m
//  eReaderPro
//
//  Created by 林世木 on 12/9/18.
//  Copyright (c) 2012年 lsray. All rights reserved.
//

#import "JsonParseOperation.h"

#import "SBJson.h"


@implementation JsonParseOperation


- (id)initWithObject:(id)object callBackMethod:(SEL)callBack withURL:(NSString *)str withPostKeyValue:(NSArray *)kv
{
    if(!(self = [super init])){
        return nil;
    }
    completeCallBack = callBack;
    mainObject = object;
    urlStr = str;
    postKeyValueArray = kv;
    
    return self;
    
}

//('url'=>'v','post'=>array(dic,dic))
- (void)main
{
    @autoreleasepool {  

        formRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
        for (NSDictionary *keyValueDic in postKeyValueArray) {
            [formRequest setPostValue:[keyValueDic objectForKey:@"value"] forKey:[keyValueDic objectForKey:@"key"]];

        }
        
        [formRequest setTimeOutSeconds:20];
        
        [formRequest startSynchronous];

        // 如果请求成功，返回 Response
        NSString *response = [formRequest responseString];
    
        NSLog(@"%@",response);
        
        NSDictionary *returnDic = [response JSONValue];

        [mainObject performSelectorOnMainThread:completeCallBack withObject:returnDic waitUntilDone:YES];

        
    }
}


@end
