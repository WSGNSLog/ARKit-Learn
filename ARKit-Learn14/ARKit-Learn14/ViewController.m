//
//  ViewController.m
//  ARKit-Learn14
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


/*
 17-SCNView重要方法和属性
 
 1.我们怎么打开调试模式,查看我们的帧率和场中中包含多少个精灵呢?
 
 scnView.showsStatistics = true;
 
 2.怎么调节渲染的帧率
 
 scnView.preferredFramesPerSecond = 30;
 
 FP = 60
 
 CUP 消耗挺高的
 
 FP = 10 降低不少
 
 为什么设置帧率？
 
 当我们的游戏画面能够满足我们的画质要求和性能要求的时候，尽量把帧率设置低点，这样能够节省我们的CPU 资源
 
 3.怎么给游戏截屏
 
 [self.scnView snapshot]
 
 4.怎么查看游戏引擎的类型
 
 if (scnView.eaglContext){
 NSLog(@"OpenGL");
 
 }else{
 NSLog(@"metal");
 }
 
 5.怎么改善画面质量
 
 开启抗锯齿功能,默认是关闭的
 
 scnView.antialiasingMode = SCNAntialiasingModeMultisampling4X;
 
 关闭抗锯齿
 
 开启抗锯齿
 
 6.选择渲染模式(OpenGL+Metal)
 
 你应该这样初始化
 
 SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds options:@{SCNPreferLowPowerDeviceKey:@(true)}];
 
 我们看看有什么可选项
 
 // OpenGL
 SCN_EXTERN NSString * const SCNPreferredRenderingAPIKey   NS_AVAILABLE(10_11, 9_0);
 
 // 指定渲染器使用<MTLDevice>
 SCN_EXTERN NSString * const SCNPreferredDeviceKey NS_AVAILABLE(10_11, 9_0);
 
 // 指定如果是渲染则使用Metal
 SCN_EXTERN NSString * const SCNPreferLowPowerDeviceKey NS_AVAILABLE(10_11, 9_0);

 */

@end
