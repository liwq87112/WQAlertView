//
//  ViewController.m
//  WQAlertView
//
//  Created by 小树普惠 on 2017/10/24.
//  Copyright © 2017年 lwq. All rights reserved.
//

#import "ViewController.h"
#import "WQAlertView.h"

@interface ViewController ()

@property (strong, nonatomic) WQAlertView                  *alert;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.title = @"WQAlertView";
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSArray * arr = @[@"喜欢吗",@"欢迎下载",@"WQAlertView"];

    self.alert = [WQAlertView tableAlertWithTitle:@"温馨提示WQAlertView" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
                  {
                      return arr.count;
                  }
                                         andCells:^UITableViewCell* (WQAlertView *anAlert, NSIndexPath *indexPath)
                  {
                      static NSString *CellIdentifier = @"CellIdentifier";
                      UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                      if (cell == nil)
                      {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];}
                      cell.textLabel.text = arr[indexPath.row];
                      return cell;
                  }];
    
    self.alert.height = 200;
    self.alert.alertBgImage = [UIImage imageNamed:@"bgView"];

    [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex)
     {

         NSLog(@"选中☑️ - %@ ",arr[selectedIndex.row]);
         
     } andCompletionBlock:^{}];
    [self.alert show];
}

@end
