//
//  ViewController.m
//  CycleAdvert
//
//  Created by Alex on 2016/11/5.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "ViewController.h"
#import "CycleAdvertView.h"
#import "AdvertModel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CycleAdvertView *advertView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //本地图片
    NSArray *images =@[@"http://b.hiphotos.baidu.com/image/pic/item/4034970a304e251f34b7c316a386c9177e3e539f.jpg"
                       ,@"http://g.hiphotos.baidu.com/image/pic/item/8b82b9014a90f6039dd1baa93d12b31bb151edff.jpg"
                       ,@"http://c.hiphotos.baidu.com/image/pic/item/267f9e2f070828389df77ac3bc99a9014d08f16b.jpg"];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < images.count; i++) {
        AdvertModel *model = [AdvertModel new];
        model.imageUrl = images[i];
        [dataArray addObject:model];
    }
    
    //循环切换一张图的时间
    _advertView.animationDuration = 3.0f;
    //当前滚动的颜色
    _advertView.curentPageTinColor=[UIColor redColor];
    //全部小圆点的颜色额
    _advertView.pageTinColor=[UIColor grayColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //调一下添加图片的方法
        _advertView.imagesArray = dataArray;
    });
    
    _advertView.imageTapBlock = ^(NSInteger index){
        NSLog(@"点击了:%zd",index);
    };

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
