# WQAlertView
选择框
![B34F6273-A32A-4FCC-8040-675A5FB7FE03.png](http://upload-images.jianshu.io/upload_images/2835602-6eca7e5a3059d6a6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


里面的cell可以自定义·背景·颜色，按钮都可以
``` 
NSArray * arr = @[@"喜欢吗",@"欢迎下载",@"WQAlertView"];
self.alert = [WQAlertView tableAlertWithTitle:@"" cancelButtonTitle:@"" numberOfRows:^NSInteger(NSInteger section) {
        //返回多少个
        return arr.count;
    } andCells:^UITableViewCell *(WQAlertView *alert, NSIndexPath *indexPath) {
        //自定义cell
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];}
        cell.textLabel.text = arr[indexPath.row];
        return cell;

    }];
 [self.alert show];
```
 显示和消失的时候做啦一点动画视觉效果
#消失
```
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
```
#显示
```
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
```
