//
//  BaseHeaders.h
//  I❤U
//
//  Created by 吕旭明 on 2018/3/7.
//  Copyright © 2018年 吕旭明. All rights reserved.
//

#ifndef BaseHeaders_h
#define BaseHeaders_h
#import "BaseEmun.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/RACSignal.h>
#import <ReactiveCocoa/RACTuple.h>

#import "Log.h"
#import "HttpUtil.h"
#import "UIUtil.h"


//注册账号的正则表达式:数字或小写字母组成的3~16位字符串(不可出现大写字母,环信的conversationID不识别大写字母)
#define kUserAccountRegiex @"^[0-9a-z]{3,16}$"

#endif /* BaseHeaders_h */
