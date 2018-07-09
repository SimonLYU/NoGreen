//
//  BaseViewModel.m
//  CMFinancialServices
//
//  Created by 506208 on 2017/6/7.
//  Copyright © 2017年 GiveU. All rights reserved.
//

#import "BaseViewModel.h"
#import "BaseViewController.h"

@interface BaseViewModel ()

@property (nonatomic, assign) LYUVCType vcType;

@end

@implementation BaseViewModel

- (instancetype)initWithVCName:(NSString *)vcName {
    return [self initWithVCName:vcName withInitType:kLYUVCTypeCode];
}

- (instancetype)initWithVCName:(NSString *)vcName withInitType:(LYUVCType)loadType {
    if (self = [super init]) {
        self.vcName = vcName;
        [self initialize];
        self.vcType = loadType;
    }
    return self;
}

- (void)initialize
{
    
}

- (__kindof UIViewController *)loadedVC {
    if (self.viewController) {
        return self.viewController;
    }
    NSString *viewControllerName = self.vcName;
    BaseViewController *viewController;
    switch (self.vcType) {
        case kLYUVCTypeCode: {
            viewController = [[NSClassFromString(viewControllerName) alloc] init];
            break;
        }
        case kLYUVCTypeXib: {
            viewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
            break;
        }
        case kLYUVCTypeStorybMain: {
            break;
        }
        case kLYUVCTypeStorybMember: {
            break;
        }
        case kLYUVCTypeStorybLogin: {
            break;
        }
            
        default:
            break;
    }
    //双向引用
    self.viewController = viewController;
    //执行绑定
    [viewController bandingViewModel:self];
    return viewController;
}

#pragma mark - navigation action

- (void)pushViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated {
    NSAssert([NSThread isMainThread], @"only called in main thread!");
    UIViewController *baseViewController = [viewModel loadedVC];
    [self.viewController.navigationController pushViewController:baseViewController animated:animated];
}

- (__kindof UIViewController *)popViewModelAnimated:(BOOL)animated {
    NSAssert([NSThread isMainThread], @"only called in main thread!");
    return [self.viewController.navigationController popViewControllerAnimated:animated];
}

- (NSArray<__kindof UIViewController *> *)popToViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated {
    NSAssert([NSThread isMainThread], @"only called in main thread!");
    return [self.viewController.navigationController popToViewController:viewModel.viewController animated:animated];
}

- (NSArray<__kindof UIViewController *> *)popToRootViewModelAnimated:(BOOL)animated {
    NSAssert([NSThread isMainThread], @"only called in main thread!");
    return [self.viewController.navigationController popToRootViewControllerAnimated:animated];
}


#pragma mark - present action

- (void)presentViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated completion:(void (^)(void))completion {
    NSAssert([NSThread isMainThread], @"only called in main thread!");
    UIViewController *baseViewController = [viewModel loadedVC];
    [self.viewController presentViewController:baseViewController animated:animated completion:completion];
}

- (void)dismissViewModelAnimated:(BOOL)animated completion: (void (^)(void))completion {
    NSAssert([NSThread isMainThread], @"only called in main thread!");
    [self.viewController dismissViewControllerAnimated:animated completion:completion];
}

@end
