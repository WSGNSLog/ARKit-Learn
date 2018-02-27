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
/*
游戏引擎常用类介绍

NO.1 SCNView

SCNView主要作用是显示SceneKit 的3D内容,在iOS 系统上是UIView 的子类,由于这个原因它可以添加到我们的视图中去,如果我们做一个应用想要加点3D元素,SceneKit绝对是首选。

NO.2 SCNScence

SCNScene 为游戏中的场景,简单的说,就是放的游戏元素(地图,灯光,人物的游戏元素)的地方。

NO.3 SCNNode

SCNNode 被称为节点,一个大型的游戏场景结构就是由无数个小的节点组成,它有自己的位置和自身坐标系统,我们可以把几何模型，灯光，摄像机的游戏中的真实元素，吸附到SCNNode 节点上。

NO.4 SCNCamera

SCNCamera 被称为照相机或者摄像机,游戏就相当于一个生活中的环境,我们可以通过照相机捕捉到你想要观察的画面。

NO.5 SCNLight

SCNLight 被称为灯光,没有光线的话,我们是看不到物体的,在游戏中也是一样的,我们可以给游戏中添加不同的灯光,来模拟逼真的环境。

NO.6 SCNAudioSource

SCNAudioSource 主要负责给游戏中添加声音。

NO.7 SCNAction

SCNAction 主要负责改变节点的属性,比如我们要让一个地球围绕太阳旋转,一个气球从一个地方移动另外一个地方。

NO.8 SCNTransaction

SCNTransaction 主要负责提交改变节点属性的事件,后面具体讲到再说明白。

NO.9 SCNGeometry

SCNGeometry 就是呈现三维模型的类,我们模型具体长什么样子,是个正方体还是长方体,都是它说了算。

NO.10 SCNMaterial

SCNMaterial 定义模型的外观，好比一个球体,它渲染出来是红色，还是绿色,会不会发光等

*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
