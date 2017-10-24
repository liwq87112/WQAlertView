//
//  WQAlertView.m
//  ppppppvvvvv
//
//  Created by 小树普惠 on 2017/9/6.
//  Copyright © 2017年 小树普惠. All rights reserved.
//

#import "WQAlertView.h"

#define kTableAlertWidth     284.0
#define kLateralInset         12.0
#define kVerticalInset         8.0
#define kMinAlertHeight      264.0
#define kCancelButtonHeight   44.0
#define kCancelButtonMargin    5.0
#define kTitleLabelMargin     12.0


@interface WQAlertView ()
@property (nonatomic, strong) UIView *alertBg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cancelButtonTitle;

@property (nonatomic) BOOL cellSelected;

@property (nonatomic, strong) WQAlertViewNumberOfRowsBlock numberOfRows;
@property (nonatomic, strong) WQAlertViewTableCellsBlock cells;

-(void)createBackgroundView;	//
-(void)animateIn;	            //
-(void)animateOut;	            //
-(void)dismissTableAlert;	    // Dismisses

@end

@implementation WQAlertView

#pragma mark - WQAlertView Class Method

static BOOL existing=0;
+(WQAlertView *)tableAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle numberOfRows:(WQAlertViewNumberOfRowsBlock)rowsBlock andCells:(WQAlertViewTableCellsBlock)cellsBlock
{
    return [[self alloc] initWithTitle:title cancelButtonTitle:cancelBtnTitle numberOfRows:rowsBlock andCells:cellsBlock];
}

#pragma mark - WQAlertView Initialization

-(id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle numberOfRows:(WQAlertViewNumberOfRowsBlock)rowsBlock andCells:(WQAlertViewTableCellsBlock)cellsBlock
{

    if(existing==1){return nil;}
    existing=1;
    if (rowsBlock == nil || cellsBlock == nil)
    {
        [[NSException exceptionWithName:@"rowsBlock and cellsBlock Error" reason:@"These blocks MUST NOT be nil" userInfo:nil] raise];
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        _numberOfRows = rowsBlock;
        _cells = cellsBlock;
        _title = title;
        _cancelButtonTitle = cancelButtonTitle;
        _height = kMinAlertHeight;
    }
    
    return self;
}

#pragma mark - Actions

-(void)configureSelectionBlock:(WQAlertViewRowSelectionBlock)selBlock andCompletionBlock:(WQAlertViewCompletionBlock)comBlock
{
    self.selectionBlock = selBlock;
    self.completionBlock = comBlock;
}

-(void)createBackgroundView
{
    self.cellSelected = NO;

    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.opaque = NO;

    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self];

    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    }];
}

-(void)animateIn
{
    self.alertBg.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.2 animations:^{
        self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1.0/15.0 animations:^{
            self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0/7.5 animations:^{
                self.alertBg.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

-(void)animateOut
{
    [UIView animateWithDuration:1.0/7.5 animations:^{
        self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0/15.0 animations:^{
            self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.alertBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
                self.alpha = 0.3;
            } completion:^(BOOL finished){
                [self removeFromSuperview];
            }];
        }];
    }];
}

- (void)setAlertBgImage:(UIImage *)alertBgImage {
    _alertBgImage = alertBgImage;
}

-(void)show
{
    [self createBackgroundView];

    self.alertBg = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.alertBg];
    
    UIImageView *alertBgImageView = [[UIImageView alloc]initWithImage:[_alertBgImage stretchableImageWithLeftCapWidth:15 topCapHeight:30]];
    [self.alertBg addSubview:alertBgImageView];
    
    // alert title creation
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    self.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.titleLabel.frame = CGRectMake(kLateralInset, 15, kTableAlertWidth - kLateralInset * 2, 22);
    self.titleLabel.text = self.title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertBg addSubview:self.titleLabel];
    
    // table view creation
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.table.frame = CGRectMake(kLateralInset, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + kTitleLabelMargin, kTableAlertWidth - kLateralInset * 2, (self.height - kVerticalInset * 2) - self.titleLabel.frame.origin.y - self.titleLabel.frame.size.height - kTitleLabelMargin - kCancelButtonMargin - kCancelButtonHeight);
    self.table.layer.cornerRadius = 6.0;
    self.table.layer.masksToBounds = YES;
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.backgroundView = [[UIView alloc] init];
    self.table.backgroundColor = [UIColor clearColor];
    [self.alertBg addSubview:self.table];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(kLateralInset, self.table.frame.origin.y + self.table.frame.size.height + kCancelButtonMargin, kTableAlertWidth - kLateralInset * 2, kCancelButtonHeight);
    self.cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.cancelButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
    self.cancelButton.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:[UIColor clearColor]];

    self.cancelButton.opaque = NO;
    self.cancelButton.layer.cornerRadius = 5.0;
    [self.cancelButton addTarget:self action:@selector(dismissTableAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.alertBg addSubview:self.cancelButton];
    
    self.alertBg.frame = CGRectMake((self.frame.size.width - kTableAlertWidth) / 2, (self.frame.size.height - self.height) / 2, kTableAlertWidth, self.height - kVerticalInset * 2);
    
    alertBgImageView.frame = CGRectMake(0.0, 0.0, kTableAlertWidth, self.height);
    self.alertBg.backgroundColor = [UIColor clearColor];
    [self becomeFirstResponder];
    

    [self animateIn];
}

-(void)dismissTableAlert
{

    [self animateOut];

    if (self.completionBlock != nil)
        
        self.completionBlock();
    existing=0;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)setHeight:(CGFloat)height
{
    if (height > kMinAlertHeight)
        _height = height;
    else
        _height = kMinAlertHeight;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numberOfRows(section);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cells(self, indexPath);
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.selectionBlock != nil)
        self.selectionBlock(indexPath);

    [self dismissTableAlert];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissTableAlert];
}

@end
