//
//  CA_HChooseTagMenuController.m
//  InvestNote_iOS
//
//  Created by 韩云智 on 2018/1/26.
//  Copyright © 2018年 韩云智. All rights reserved.
//

#import "CA_HChooseTagMenuController.h"

@interface CA_HChooseTagMenuController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (nonatomic, strong) UIView *menuView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIAlertController *alert;

@end

@implementation CA_HChooseTagMenuController


#pragma mark --- Action

- (void)onButton:(UIButton *)sender {
    self.viewModel.clickBlock(sender);
}

#pragma mark --- Lazy

- (CA_HChooseTagMenuViewModel *)viewModel {
    if (!_viewModel) {
        CA_HChooseTagMenuViewModel *viewModel = [CA_HChooseTagMenuViewModel new];
        
        CA_H_WeakSelf(self);
        viewModel.dismissMenuBlock = ^{
            CA_H_StrongSelf(self);
            [self dismissViewControllerAnimated:NO completion:nil];
        };
        
        viewModel.addNewTagBlock = ^{
            CA_H_StrongSelf(self);
            [self newTag];
        };
        
        viewModel.showMassageBlock = ^(NSString *massage) {
            CA_H_DISPATCH_MAIN_THREAD(^{
                CA_H_StrongSelf(self);
                
                [self.alert?self.alert:self presentAlertTitle:nil message:massage buttons:@[CA_H_LAN(@"确定")] clickBlock:nil];
            });
        };
        
        viewModel.loadMenuBlock = ^{
            CA_H_StrongSelf(self);
            [UIView animateWithDuration:0.25 animations:^{
                self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
            }];
            [self.view addSubview:self.menuView];
            self.viewModel.showBlock();
        };
        
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (UIView *)menuView {
    if (!_menuView) {
        _menuView = self.viewModel.menuViewBlock(self, @selector(onButton:), self.collectionView);
    }
    return _menuView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = self.viewModel.collectionViewBlock(self);
    }
    return _collectionView;
}

#pragma mark --- LifeCircle

- (void)dealloc {
    NSLog(@"%@----->dealloc",[self class]);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self upConfig];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upView];
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
////    self.viewModel.showBlock();
//}

#pragma mark --- Custom



- (void)upConfig {
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
}

- (void)upView {
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.viewModel.requestBlock();
}

- (void)newTag {
    _alert = [self presentAlertTitle:CA_H_LAN(@"新标签")
                             message:nil
                             buttons:@[CA_H_LAN(@"取消"),CA_H_LAN(@"确定")]
                          clickBlock:^(UIAlertController *alert, NSInteger index) {
                              self.alert = nil;
                              if (index == 1) {
                                  NSString * text = [alert.textFields.firstObject text];
                                  if (text.length) {
                                      self.viewModel.addDataBlock(text);
                                  }
                              }
                          }
                    countOfTextField:1
                      textFieldBlock:^(UITextField *textField, NSInteger index) {
                          textField.delegate = self;
                          textField.placeholder = CA_H_LAN(@"新标签名称");
                          textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                          textField.returnKeyType = UIReturnKeyDone;
                      }];
}

#pragma mark --- Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        if (touch.view == self.view) {
            self.viewModel.clickBlock(nil);
            break;
        }
    }
}

#pragma mark --- Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.numberOfItemsBlock(section);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.sizeForItemBlock(indexPath);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    self.viewModel.cellForItemBlock(cell, indexPath);
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return self.viewModel.shouldSelectItemBlock(indexPath);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.viewModel.shuoldDoneBlock();
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.viewModel.shuoldDoneBlock();
}

#pragma mark --- TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return self.viewModel.textFieldShouldChangeBlock(textField.text,string);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

@end
