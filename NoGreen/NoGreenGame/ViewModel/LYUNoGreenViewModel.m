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

@interface LYUNoGreenViewModel()
@end

@implementation LYUNoGreenViewModel

- (void)initialize{
    [super initialize];
    self.stage = 1;
    self.startStep = self.step = 1;
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
    
    for (LYUPixel * pixel in pixelsNeedChangeType) {
        if (pixel.type == kLYUPixelTypeNormal) {
            pixel.type = kLYUPixelTypeSelected;
        }else{
            pixel.type = kLYUPixelTypeNormal;
        }
    }
    if ([self detectFail]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"失败" message:@"步数用尽,请重新开始此关卡!" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.step = self.startStep;
            self.gameMap = self.gameMap;
        }]];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    }
    if ([self detectWin]) {
        self.startStep =  self.step = self.step + ++self.stage;
        [UIUtil showHint:@"恭喜!\n即将进入下一关!" inView:self.viewController.view];
        [self randomMap];
    }
}

- (RACCommand *)restartCommand{
    if (!_restartCommand) {
        _restartCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            self.step = self.startStep;
            self.gameMap = self.gameMap;
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
                [self randomMap];
                self.startStep = self.step = 1;
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
@end
