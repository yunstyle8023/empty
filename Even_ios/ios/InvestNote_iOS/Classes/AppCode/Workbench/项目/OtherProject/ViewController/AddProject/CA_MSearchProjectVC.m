//
//  CA_MAddProjectVC.m
//  InvestNote_iOS
//  Created by yezhuge on 2017/12/20.
//  God bless me without no bugs.
//

@interface CustomAccessoryView :UIView
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UIImageView* arrowImgView;
@property(nonatomic,copy)dispatch_block_t tapBlock;
@end

@implementation CustomAccessoryView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    [self addSubview:self.bgView];
    [self addSubview:self.titleLb];
    [self addSubview:self.arrowImgView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-13);
    }];
    [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb.mas_trailing);
        make.centerY.mas_equalTo(self.titleLb);
    }];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLb).offset(-20);
        make.trailing.mas_equalTo(self.arrowImgView.mas_trailing).offset(20);
        make.top.mas_equalTo(self.titleLb.mas_top).offset(-5);
        make.bottom.mas_equalTo(self.titleLb.mas_bottom).offset(5);
    }];
    [self.bgView addShadowColor:kColor(@"#D8D8D8")
                    withOpacity:0.5
                    shadowRadius:3
                    andCornerRadius:13];
}
-(void)tapGestureAction{
    !_tapBlock?:_tapBlock();
}
-(UIImageView *)arrowImgView{
    if (_arrowImgView) {
        return _arrowImgView;
    }
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.image = kImage(@"shape");
    return _arrowImgView;
}
-(UILabel *)titleLb{
    if (_titleLb) {
        return _titleLb;
    }
    _titleLb = [[UILabel alloc] init];
    NSString* title = @"没找到想要的？手动录入";
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(14) range:NSMakeRange(0, title.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, 7)];
    [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_TINTCOLOR range:NSMakeRange(7, title.length-7)];
    _titleLb.attributedText = attStr;
    [_titleLb sizeToFit];
    return _titleLb;
}
-(UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = kColor(@"#FFFFFF");
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [_bgView addGestureRecognizer:tapGesture];
    return _bgView;
}
@end

@protocol CustomTextFieldViewDelegate <NSObject>
-(void)jump2AddProject;
-(void)textDidChange:(NSString*)content;
-(void)keyboradChange;
@end

@interface CustomTextFieldView :UIView<UITextFieldDelegate>
@property(nonatomic,strong)UITextField* txtField;
@property(nonatomic,strong)CustomAccessoryView* accessoryView;
@property(nonatomic,weak)id<CustomTextFieldViewDelegate> deleagte;
@end

@implementation CustomTextFieldView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColor(@"#FFFFFF");
        [self addSubview:self.txtField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.txtField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self).offset(4);
        make.width.mas_equalTo(CA_H_SCREEN_WIDTH - 20*2);
    }];
}

- (void)textFieldDidChangeValue:(UITextField*)txtField{
    if (self.deleagte &&
        [self.deleagte respondsToSelector:@selector(textDidChange:)]) {
        [self.deleagte textDidChange:txtField.text];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)keyboardWillBeHiden{
    if (self.deleagte &&
        [self.deleagte respondsToSelector:@selector(keyboradChange)]) {
        [self.deleagte keyboradChange];
    }
}

-(CustomAccessoryView *)accessoryView{
    if (_accessoryView) {
        return _accessoryView;
    }
    _accessoryView = [[CustomAccessoryView alloc] initWithFrame:CGRectMake(0, 0, CA_H_SCREEN_WIDTH, 44)];
     CA_H_WeakSelf(self)
    _accessoryView.tapBlock = ^{
        CA_H_StrongSelf(self)
        if (self.deleagte && [self.deleagte respondsToSelector:@selector(jump2AddProject)]) {
            [self.deleagte jump2AddProject];
        }
    };
    return _accessoryView;
}
-(UITextField *)txtField{
    if (_txtField) {
        return _txtField;
    }
    _txtField = [[UITextField alloc] init];
    NSString* placeholder = @"请填写项目名称";
    NSMutableAttributedString* attStr = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [attStr addAttribute:NSFontAttributeName value:CA_H_FONT_PFSC_Regular(18) range:NSMakeRange(0, placeholder.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:CA_H_9GRAYCOLOR range:NSMakeRange(0, placeholder.length)];
    _txtField.attributedPlaceholder = attStr;
    _txtField.inputAccessoryView = self.accessoryView;
    _txtField.inputAccessoryView.hidden = YES;
    [_txtField addTarget:self
                  action:@selector(textFieldDidChangeValue:)
        forControlEvents:UIControlEventEditingChanged];
    _txtField.returnKeyType = UIReturnKeyDone;
    _txtField.delegate = self;
    return _txtField;
}
@end

#import "CA_MSearchProjectVC.h"
#import "CA_MSearchDetailProjectVC.h"
#import "CA_MSettingHeaderView.h"
#import "CA_MAddProjectCell.h"
#import "CA_MAddProjectVC.h"
#import "CA_MSelectModel.h"
#import "CA_MEmptyView.h"
#import "CA_MSelectProjectNetModel.h"

static NSString* const key = @"CA_MAddProjectCell";

@interface CA_MSearchProjectVC ()
<UITableViewDataSource,
UITableViewDelegate,
CustomTextFieldViewDelegate>

/// txtFieldBgView
@property(nonatomic,strong)UIView* txtFieldBgView;
/// txtFieldView
@property(nonatomic,strong)CustomTextFieldView* txtFieldView;
/// tableview
@property(nonatomic,strong)UITableView* tableView;
/// 数据源
@property(nonatomic,strong)NSMutableArray* dataSource;

@property (nonatomic,assign,getter=isLoadMore) BOOL loadMore;
@property (nonatomic,strong) CA_MSelectProjectNetModel* projectNetModel;
@property (nonatomic,assign) int pageCount;
@property (nonatomic,strong) CA_MSettingHeaderView *headerView;

@property (nonatomic,strong) CustomAccessoryView *accessoryView;
@end

@implementation CA_MSearchProjectVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加项目";
    [self setupUI];
    [self initNetParamters];
    [self.txtFieldView.txtField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(44);
        make.leading.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view.height - 44);
        make.width.mas_equalTo(self.view.width);
    }];
    
    [self.txtFieldView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];

    [CA_HShadow dropShadowWithView:self.txtFieldView
                            offset:CGSizeMake(0, 3)
                            radius:3
                             color:CA_H_SHADOWCOLOR
                           opacity:0.2];
    
    [self.accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-10);
        //
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(CA_H_SCREEN_WIDTH);
    }];
}

#pragma mark - Public

#pragma mark - Private

- (void)setupUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.txtFieldView];
    [self.view addSubview:self.accessoryView];
}

- (void)initNetParamters{
    self.projectNetModel = [[CA_MSelectProjectNetModel alloc] init];
    self.projectNetModel.data_type = @"project";
    self.projectNetModel.search_type = @"keyword";
    self.projectNetModel.page_num = @1;
    self.projectNetModel.page_size = @10;
    self.projectNetModel.search_str = @"";
    self.loadMore = NO;
}

#pragma mark - CustomTextFieldViewDelegate

-(void)jump2AddProject{
    [self.txtFieldView.txtField resignFirstResponder];
    CA_MAddProjectVC* addProjectVC = [[CA_MAddProjectVC alloc] init];
    [self.navigationController pushViewController:addProjectVC animated:YES];
}

-(void)textDidChange:(NSString *)content{
    
    if (self.tableView.isHidden) {
        self.tableView.hidden = NO;
    }
    
    if (self.txtFieldView.txtField.inputAccessoryView.isHidden) {
        self.txtFieldView.txtField.inputAccessoryView.hidden = NO;
    }
    
    [self initNetParamters];
    if (![NSString isValueableString:content]) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    _projectNetModel.search_str = content;
    [self.dataSource removeAllObjects];
    [self requestData];
}

-(void)keyboradChange{
    self.accessoryView.hidden = self.dataSource.count <= 0;
}

-(void)requestData{
    NSDictionary* paramters = @{@"data_type":self.projectNetModel.data_type,
                                @"page_num":self.projectNetModel.page_num,
                                @"page_size":self.projectNetModel.page_size,
                                @"search_str":self.projectNetModel.search_str,
                                @"search_type":self.projectNetModel.search_type
                                };
    [CA_HNetManager postUrlStr:CA_M_Api_SearchDataList parameters:paramters callBack:^(CA_HNetModel *netModel) {
        if (netModel.type == CA_H_NetTypeSuccess) {
            if (netModel.errcode.integerValue == 0) {
                if ([netModel.data isKindOfClass:[NSDictionary class]] &&
                    [NSObject isValueableObject:netModel.data]) {
                    
                    self.pageCount = ceil([netModel.data[@"total_count"] floatValue] / self.projectNetModel.page_size.floatValue);
                    //
                    if ([netModel.data[@"data_list"] isKindOfClass:[NSArray class]] &&
                        [NSObject isValueableObject:netModel.data[@"data_list"]]){
                        if (!self.isLoadMore) {
                            [self.dataSource removeAllObjects];
                        }
                        for (NSDictionary* dic in netModel.data[@"data_list"]) {
                            CA_MSelectModel* model = [CA_MSelectModel modelWithDictionary:dic];
                            [self.dataSource addObject:model];
                        }
                    }
                }
                [self.tableView reloadData];
            }else{
                if (self.isLoadMore) {
                    self.projectNetModel.page_num = @(self.projectNetModel.page_num.intValue-1);
                }
                [self.tableView reloadData];
            }
            
        }else{
            if (self.isLoadMore) {
                self.projectNetModel.page_num = @(self.projectNetModel.page_num.intValue-1);
            }
//            [CA_HProgressHUD showHudStr:netModel.errmsg];
        }
        [self.tableView.mj_header endRefreshing];
        if (self.pageCount == self.projectNetModel.page_num.intValue) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    } progress:nil];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.backgroundView.hidden = self.dataSource.count > 0;
    tableView.mj_footer.hidden = !tableView.backgroundView.hidden;
    tableView.scrollEnabled = self.dataSource.count > 0;
    self.headerView.hidden = self.dataSource.count <= 0;
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CA_MAddProjectCell* addCell = [tableView dequeueReusableCellWithIdentifier:key];
    if([NSObject isValueableObject:self.dataSource]){
        CA_MSelectModel* model = self.dataSource[indexPath.row];
        addCell.model = model;
    }
    return addCell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([NSObject isValueableObject:self.dataSource] &&
        indexPath.row<=self.dataSource.count-1) {
        //如果不回到主线程操作,会造成几秒的卡顿,因此猜想presentViewController不是在主线程进行操作的
        dispatch_async(dispatch_get_main_queue(), ^{
            CA_MSearchDetailProjectVC* progressVC = [[CA_MSearchDetailProjectVC alloc] init];
            CA_MSelectModel* model = self.dataSource[indexPath.row];
            progressVC.model = model;
            [self presentViewController:progressVC animated:NO completion:nil];
        });
    }
 
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 47;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - Getter and Setter
-(CA_MSettingHeaderView *)headerView{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[CA_MSettingHeaderView alloc] init];
    _headerView.backgroundColor = kColor(@"#FFFFFF");
    _headerView.title = @"选择智能匹配项 可快速添加:";
    _headerView.titleColor = @"#999999";
    _headerView.font = 14;
    _headerView.hidden = YES;
    return _headerView;
}
-(NSMutableArray *)dataSource{
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = @[].mutableCopy;
    return _dataSource;
}
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [UITableView newTableViewGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kColor(@"#FFFFFF");
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 73 * CA_H_RATIO_WIDTH;
    _tableView.hidden = YES;
    [_tableView registerClass:[CA_MAddProjectCell class] forCellReuseIdentifier:key];
    CA_H_WeakSelf(self)
    _tableView.backgroundView = [CA_MEmptyView newTitle:@"当前条件下找不到你参与的项目" buttonTitle:@"" top:137*CA_H_RATIO_WIDTH onButton:^{
        CA_H_StrongSelf(self);
        
    } imageName:@"empty_search"];
    
    __weak UITableView* weakTableView = _tableView;
//    _tableView.mj_header = [CA_HDIYHeader headerWithRefreshingBlock:^{
//        CA_H_StrongSelf(self);
//        if (![NSString isValueableString:self.projectNetModel.search_str]) {
//            [weakTableView.mj_header endRefreshing];
//            return ;
//        }
//        self.loadMore = NO;
//        self.projectNetModel.page_num = @1;
//        [self.dataSource removeAllObjects];
//        [self requestData];
//    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        CA_H_StrongSelf(self);
        self.loadMore = YES;
        if (self.projectNetModel.page_num.intValue < self.pageCount) {
            self.projectNetModel.page_num = @(self.projectNetModel.page_num.intValue+1);
            [self requestData];
        }else if (self.projectNetModel.page_num.intValue == self.pageCount){
            [weakTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    return _tableView;
}
-(CustomTextFieldView *)txtFieldView{
    if (_txtFieldView) {
        return _txtFieldView;
    }
    _txtFieldView = [[CustomTextFieldView alloc] init];
    _txtFieldView.deleagte = self;
    return _txtFieldView;
}
-(UIView *)txtFieldBgView{
    if (_txtFieldBgView) {
        return _txtFieldBgView;
    }
    _txtFieldBgView = [[UIView alloc] init];
    _txtFieldBgView.backgroundColor = kColor(@"#FFFFFF");
    return _txtFieldBgView;
}
-(CustomAccessoryView *)accessoryView{
    if (_accessoryView) {
        return _accessoryView;
    }
    _accessoryView = [[CustomAccessoryView alloc] init];
    _accessoryView.hidden = YES;
    CA_H_WeakSelf(self)
    _accessoryView.tapBlock = ^{
        CA_H_StrongSelf(self)
        [self jump2AddProject];
    };
    return _accessoryView;
}
@end

