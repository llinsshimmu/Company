//
//  JsonParseOperation.h
//  eReaderPro
//
//  Created by 林世木 on 12/9/18.
//  Copyright (c) 2012年 lsray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface JsonParseOperation : NSOperation<ASIHTTPRequestDelegate>{
    id mainObject;
    SEL completeCallBack;

    NSString *urlStr;  //'url'=>''
    NSArray *postKeyValueArray;   
    
    ASIFormDataRequest *formRequest;

    
}

- (id)initWithObject:(id)object callBackMethod:(SEL)callBack withURL:(NSString *)str withPostKeyValue:(NSArray *)kv;


@end
