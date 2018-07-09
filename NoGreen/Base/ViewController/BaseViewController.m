//
//  BaseViewController.m
//  I❤U
//
//  Created by 吕旭明 on 2018/3/7.
//  Copyright © 2018年 吕旭明. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseHeaders.h"

@interface BaseViewController ()

@property (nonatomic, strong, readwrite) BaseViewModel *viewModel;

@end

@implementation BaseViewController

- (instancetype)initWithViewModel:(id)viewModel
{
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self _addKeyboardNotifications];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self _removeKeyboardNotifications];
}
- (void)dealloc{
    [self _removeKeyboardNotifications];
}

- (void)bandingViewModel:(id)viewModel
{
    self.viewModel = viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - RAC
- (void)registerRacsignal{
    
}

#pragma mark - notification
- (void)_addKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)_removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)onKeyboardWillShow:(NSNotification *)notification
{
}

- (void)onKeyboardDidShow:(NSNotification *)notification
{
}

- (void)onKeyboardWillHide:(NSNotification *)notification
{
}

- (void)onKeyboardDidHide:(NSNotification *)notification
{
}

- (void)onKeyboardWillChangeFrame:(NSNotification *)notification
{
}

- (void)onKeyboardDidChangeFrame:(NSNotification *)notification
{
}
@end
