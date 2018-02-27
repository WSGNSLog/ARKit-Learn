//
//  ViewController.m
//  ARKit-Learn01
//
//  Created by shiguang on 2018/2/27.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScnview];
}
- (void)setupScnview{
    
    //创建游戏专用视图
    SCNView *scnview = [[SCNView alloc]initWithFrame:self.view.bounds];
    //创建一个场景，系统默认是没有的
    scnview.scene = [SCNScene scene];
    //先设置一个颜色看看游戏引擎有没有加载
    scnview.backgroundColor = [UIColor lightGrayColor];
    
    //创建一个文字节点
    SCNNode *textNode = [SCNNode node];
    SCNText *text = [SCNText textWithString:@"hello world" extrusionDepth:0.5];
    textNode.geometry = text;
    //把这个文字节点添加到游戏场景的根结点上
    [scnview.scene.rootNode addChildNode:textNode];
    //允许用户操作摄像机
    scnview.allowsCameraControl = true;
    [self.view addSubview:scnview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
