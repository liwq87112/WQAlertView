//
//  WQAlertView.h
//  ppppppvvvvv
//
//  Created by 小树普惠 on 2017/9/6.
//  Copyright © 2017年 小树普惠. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQAlertView;

typedef NSInteger (^WQAlertViewNumberOfRowsBlock)(NSInteger section);
typedef UITableViewCell* (^WQAlertViewTableCellsBlock)(WQAlertView *alert, NSIndexPath *indexPath);
typedef void (^WQAlertViewRowSelectionBlock)(NSIndexPath *selectedIndex);
typedef void (^WQAlertViewCompletionBlock)(void);



@interface WQAlertView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) UIImage *alertBgImage;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) WQAlertViewCompletionBlock completionBlock;

@property (nonatomic, strong) WQAlertViewRowSelectionBlock selectionBlock;

+(WQAlertView *)tableAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle numberOfRows:(WQAlertViewNumberOfRowsBlock)rowsBlock andCells:(WQAlertViewTableCellsBlock)cellsBlock;

-(id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle numberOfRows:(WQAlertViewNumberOfRowsBlock)rowsBlock andCells:(WQAlertViewTableCellsBlock)cellsBlock;

-(void)configureSelectionBlock:(WQAlertViewRowSelectionBlock)selBlock andCompletionBlock:(WQAlertViewCompletionBlock)comBlock;

-(void)show;


@end
