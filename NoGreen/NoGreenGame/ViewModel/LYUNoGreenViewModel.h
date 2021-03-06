//
//  LYUNoGreenViewModel.h
//  NoGreen
//
//  Created by Simon on 2018/7/6.
//  Copyright © 2018年 Simon. All rights reserved.
//

#import "BaseViewModel.h"
@class LYUPixel;

@interface LYUNoGreenViewModel : BaseViewModel

@property (nonatomic, assign) NSInteger stage;
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) NSInteger heightScore;
@property (nonatomic, assign) NSInteger startStep;
@property (nonatomic, assign) NSInteger resetTimes;
@property (nonatomic, assign) BOOL showLifeAd;

@property (nonatomic, strong) NSArray *gameMap;

@property (nonatomic, strong) NSArray<NSArray *> *pixels;

@property (nonatomic, strong) RACCommand *selectCommand;
@property (nonatomic, strong) RACCommand *theNewGameCommand;
@property (nonatomic, strong) RACCommand *restartCommand;
@property (nonatomic, strong) RACCommand *addLifeCommand;

- (void)selectPixelView:(LYUPixel *)pixel;
- (void)randomMap;

@end
