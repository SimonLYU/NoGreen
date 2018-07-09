//
//  BaseEmun.h
//  ヾ(･ε･｀*)
//
//  Created by Simon on 2018/6/7.
//  Copyright © 2018年 吕旭明. All rights reserved.
//

#ifndef BaseEmun_h
#define BaseEmun_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LYUVCType) {            //!< 定义加载VC的方式
    kLYUVCTypeCode = 0,              //!< 创建纯代码vc
    kLYUVCTypeXib,                //!< 从xib创建VC
    kLYUVCTypeStorybMain,  //!< 从main storyboard 初始
    kLYUVCTypeStorybMember,//!< 从Member storyboard 初始化
    kLYUVCTypeStorybLogin, //!< 从Login storyboard 初始化
};

#endif /* BaseEmun_h */
