//
//  LYUNoGreenViewModel.m
//  NoGreen
//
//  Created by Simon on 2018/7/6.
//  Copyright © 2018年 Simon. All rights reserved.
//

#import "LYUNoGreenViewModel.h"
#import "LYUPixel.h"
#import "LYUNoGreenHeader.h"

static inline NSString * kHeightScoreKey() {
    return @"heightScoreKey";
}

@interface LYUNoGreenViewModel()
@end

@implementation LYUNoGreenViewModel

- (void)initialize{
    [super initialize];
    self.heightScore = [[[NSUserDefaults standardUserDefaults] objectForKey:kHeightScoreKey()] integerValue];
    self.stage = 1;
    self.startStep = self.step = 1;
    self.resetTimes = 1;
    self.showLifeAd = NO;
}

- (RACCommand *)selectCommand{
    if (!_selectCommand) {
        _selectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            LYUPixel * pixel = (LYUPixel *)input;
            --self.step;
            [self selectPixelView:pixel];
            return [RACSignal empty];
        }];
    }
    return _selectCommand;
}

- (void)selectPixelView:(LYUPixel *)pixel{
    
    NSMutableArray * pixelsNeedChangeType = [NSMutableArray array];
    [pixelsNeedChangeType addObject:pixel];
    
    NSInteger targetHang = pixel.position.x - 1;
    NSInteger targetLie = pixel.position.y;
    if (targetHang >= 0 && targetHang < kNoGreenHeight &&
        targetLie >= 0 && targetLie < kNoGreenLenght) {
        [pixelsNeedChangeType addObject:self.pixels[targetHang][targetLie]];
    }
    
    targetHang = pixel.position.x;
    targetLie = pixel.position.y - 1;
    if (targetHang >= 0 && targetHang < kNoGreenHeight &&
        targetLie >= 0 && targetLie < kNoGreenLenght) {
        [pixelsNeedChangeType addObject:self.pixels[targetHang][targetLie]];
    }
    
    targetHang = pixel.position.x + 1;
    targetLie = pixel.position.y;
    if (targetHang >= 0 && targetHang < kNoGreenHeight &&
        targetLie >= 0 && targetLie < kNoGreenLenght) {
        [pixelsNeedChangeType addObject:self.pixels[targetHang][targetLie]];
    }
    
    targetHang = pixel.position.x;
    targetLie = pixel.position.y + 1;
    if (targetHang >= 0 && targetHang < kNoGreenHeight &&
        targetLie >= 0 && targetLie < kNoGreenLenght) {
        [pixelsNeedChangeType addObject:self.pixels[targetHang][targetLie]];
    }
    if (self.step >= 0) {
        for (LYUPixel * pixel in pixelsNeedChangeType) {
            if (pixel.type == kLYUPixelTypeNormal) {
                pixel.type = kLYUPixelTypeSelected;
            }else{
                pixel.type = kLYUPixelTypeNormal;
            }
        }
    }else{
        self.step = 0;
    }
    
    if ([self detectFail]) {
        if ([self canResetCurrentStage]) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"失败" message:[NSString stringWithFormat:@"步数用尽,请重新开始此关卡!(%zd/3)",self.resetTimes] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ++self.resetTimes;
                self.step = self.startStep;
                self.gameMap = self.gameMap;
            }]];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
        }else if(!self.showLifeAd){
            self.showLifeAd = YES;
        }else{
            [UIUtil showHint:@"三次重置机会已经用尽,重新开始游戏吧!"];
        }
    }else if ([self detectWin]) {
        //        self.startStep =  self.step = self.step + ++self.stage;//保留上一关剩余的步数(easy 模式)
        self.startStep =  self.step = ++self.stage;//不保留上一关剩余的步数(hard 模式)
        self.resetTimes = 1;
        self.showLifeAd = NO;//重置续命广告
        [UIUtil showHint:@"恭喜!\n进入下一关!" inView:self.viewController.view];
        [self randomMap];
    }
}

- (RACCommand *)addLifeCommand{
    if (!_addLifeCommand) {
        _addLifeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            self.step = self.startStep;
            self.gameMap = self.gameMap;
            return [RACSignal empty];
        }];
    }
    return _addLifeCommand;
}

- (RACCommand *)restartCommand{
    if (!_restartCommand) {
        _restartCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            if (![self canResetCurrentStage]) {
                if(!self.showLifeAd){//加命
                    self.showLifeAd = YES;
                }else{//提示
                    [UIUtil showHint:@"三次重置机会已经用尽,重新开始游戏吧!"];
                }
                return [RACSignal empty];
            }
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"重新开始" message:[NSString stringWithFormat:@"每个关卡只能重置三次,确认重置?(%zd/3)",self.resetTimes] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                ++self.resetTimes;
                self.step = self.startStep;
                self.gameMap = self.gameMap;
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
            
            return [RACSignal empty];
        }];
    }
    return _restartCommand;
}

- (RACCommand *)theNewGameCommand{
    if (!_theNewGameCommand) {
        _theNewGameCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"新游戏" message:@"确定要从第一关重新开始游戏么?" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                self.stage = 1;
                self.resetTimes = 1;
                self.startStep = self.step = 1;
                self.showLifeAd = NO;
                [self randomMap];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self.viewController presentViewController:alertController animated:YES completion:nil];

            return [RACSignal empty];
        }];
    }
    return _theNewGameCommand;
}

- (void)randomMap{
    NSMutableArray * gameMap = [NSMutableArray array];
    for (int i = 0; i < self.stage; ++i) {
        [gameMap addObject:NSStringFromCGPoint(CGPointMake(arc4random_uniform(12), arc4random_uniform(10)))];
    }
    self.gameMap = gameMap;
}

- (BOOL)canResetCurrentStage{
    if (self.resetTimes > 3) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)detectFail{
    if (self.step <= 0) {//步数为零的时候开始检测场上是否有绿色
        for (int hang = 0; hang < kNoGreenHeight; ++hang) {
            for (int lie = 0; lie < kNoGreenLenght; ++lie) {
                LYUPixel * pixel = self.pixels[hang][lie];
                if (pixel.type == kLYUPixelTypeSelected) {
                    return YES;
                    break;
                }
            }
        }
    }
    return NO;
}

- (BOOL)detectWin{

    for (int hang = 0; hang < kNoGreenHeight; ++hang) {
        for (int lie = 0; lie < kNoGreenLenght; ++lie) {
            LYUPixel * pixel = self.pixels[hang][lie];
            if (pixel.type == kLYUPixelTypeSelected) {
                return NO;
                break;
            }
        }
    }
    return YES;
}

- (void)setStep:(NSInteger)step{
    _step = step;
    if (step > self.heightScore) {
        self.heightScore = step;
        [[NSUserDefaults standardUserDefaults] setObject:@(self.heightScore) forKey:kHeightScoreKey()];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
