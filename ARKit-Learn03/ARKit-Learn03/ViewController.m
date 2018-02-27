//
//  ViewController.m
//  ARKit-Learn03
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
    [self setupSCNView];
}
- (void)setupSCNView{
    
    //创建游戏视图
    SCNView *scnview = [[SCNView alloc]initWithFrame:self.view.bounds];
    //加载游戏文件
    NSURL *resourceURL = [[NSBundle mainBundle] URLForResource:@"yizi" withExtension:@"dae"];
    scnview.scene = [SCNScene sceneWithURL:resourceURL options:nil error:nil];
    
    scnview.backgroundColor = [UIColor lightGrayColor];
    scnview.allowsCameraControl = true;
    [self.view addSubview:scnview];

}
/*
 4-SCNScene

 本节学习目标
 
 掌握SCNScene的基本概念
 主要能干什么事情
 怎么使用
 概念
 
 通俗的说就是游戏场景,游戏场景主要由几何模型,灯光,照相机，和其它的属性组成,另外请注意,SCNScene这个对象包含3D场景和场景中的内容。
 
 主要能干什么事情
 
 添加各种游戏元素到场景中
 读取场景文件
 将场景写入文件
 还有很多功能,这里暂时不讲,以为要用到后面的知识!我们慢慢来,最终吃完整个蛋糕。
 
 怎么使用
 
 我们创建一个工程演示一下
 
 第一步
 
 创建一个简单的工程,就和普通应用一样。这里就不演示了,在第一节中有讲到!
 
 第二步
 
 导入游戏框架
 
 import SceneKit
 
 第三步
 
 创建游戏专用视图
 
 let scnView = SCNView(frame: self.view.bounds);
 
 第四步
 
 加载游戏文件,请上网随便找一个后缀名为.dae的文件
 
 scnView.scene = SCNScene(named: "my.dae")
 
 第五步
 
 将游戏专用视图添加到我们的视图中去
 
 self.view.addSubview(scnView);
 
 这个时候运行一下工程试试看
 
 将场景写入文件中去
 
 let urlString = NSHomeDirectory() + "/Documents/my.dae"
 scnView.scene?.write(to: URL(fileURLWithPath: urlString), options: nil, delegate: nil, progressHandler: { (progress, error, flag) in
 print( progress);
 })
 
 然后到模拟器的目录下面去查看是否有保存的文件,怎么去查看保存文件的路径呢？网上的方法有很多都过时,并且不靠谱,最简单的方式如下
 
 print(urlString)
 
 /Users/xujie/Library/Developer/
 CoreSimulator/Devices/
 7DBC6358-32AF-42EE-BAA4-6350562AFD73/
 data/Containers/Data/Application/067F20AD-7CB8-4F70-A202-EBB9DA1306A3/Documents/my.dae
 
 在Finder->前往->前往文件夹->输入地址 即可找到
 
 真机怎么查看保存的文件?
 
 xcode->window->Devices->选中真机->单击应用->选择设置图标->download Container... 下载下来即可
 
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
