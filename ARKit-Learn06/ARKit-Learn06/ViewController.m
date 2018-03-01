//
//  ViewController.m
//  ARKit-Learn06
//
//  Created by shiguang on 2018/2/28.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加游戏专用视图
    SCNView *scnview = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnview.backgroundColor = [UIColor blackColor];
    scnview.allowsCameraControl = true;// 开启操纵照相机选项
    [self.view addSubview:scnview];
    
    //创建游戏场景
    scnview.scene = [SCNScene scene];
    
    //添加照相机
    SCNCamera *camera = [SCNCamera camera];
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 0, 50);
    [scnview.scene.rootNode addChildNode:cameraNode];
    
    
    //添加两个正方体
    SCNBox *box1 = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
    box1.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
    SCNNode *boxNode1 = [SCNNode node];
    boxNode1.geometry = box1;
    [scnview.scene.rootNode addChildNode:boxNode1];
    
    SCNBox *box2 = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
    box2.firstMaterial.diffuse.contents = [UIImage imageNamed:@"2.PNG"];
    SCNNode *boxNode2 = [SCNNode node];
    boxNode2.position = SCNVector3Make(0, 10, -20);
    boxNode2.geometry = box2;
    [scnview.scene.rootNode addChildNode:boxNode2];
}

/*

 7-SCNCamera
 
 照相机原理分析
 
 视角
 
 上图是一个游戏场景 照相机的位置为(10,0,0) 物体A的位置为(0,0-6)，yFor 表示的是Y轴上的视角。图你可以不太理解，的确有点抽象。
 
 举例说明:
 
 在游戏引擎中,照相机好比就是你的眼睛,你眼睛在X轴(左右看)和Y轴(上下看)有个最大角度，这个角度我们叫做xFov和yFov,想想一下，如果是这视野大了,我们能看到的范围就会变大,这个时候，你拍一张照片，我的要求是,照片的大小和你手机大小一样,如果你视野小，你的照里面的物体就少，如果你视野大，你照片里面的物体就会变多，那么，对于同一个物体，当然在视野小的时候，显示的体积大，在视野大的时候，显示的体积小。就是这么简单。
 
 视野小
 
 视野大
 
 焦距 焦距
 
 f: 焦距 从图可以看出,焦距越大，视野越小,焦距越小视野越大
 
 我相信你应该明白了游戏引擎中照相机的作用了吧! 记住:
 
 我们显示在手机屏幕中的物体都是能被照相机看到的物体。
 
 SCNCamera 详解
 
 它的父类为NSObject
 
 @interface SCNCamera : NSObject
 
 创建对象的方法
 
 + (instancetype)camera;
 
 给照相机对象设置名字
 
 @property(nonatomic, copy, nullable) NSString *name;
 
 X轴方向的视角(默认为60度)
 
 @property(nonatomic) double xFov;
 
 Y轴方向的视角(默认为60度)
 
 @property(nonatomic) double yFov;
 
 照相机能照到的最近距离(默认值为1)
 
 @property(nonatomic) double zNear;
 
 照相机能照到的最远距离(默认值为100)
 
 @property(nonatomic) double zFar;
 
 让照相机自动调节最近和最远距离(默认为关闭,开启后,没有最近和最远的限制)
 
 @property(nonatomic) BOOL automaticallyAdjustsZRange NS_AVAILABLE(10_9, 8_0);
 
 是否开启正投影模式
 
 正投影就是说物体在远离或者靠近照相机是,大小保持不变
 
 @property(nonatomic) BOOL usesOrthographicProjection;
 
 设置正投影的比例 (默认为1)
 
 注意，这里设置的比例越大,显示的图像越小,你可以这样理解scale = 屏幕的大小:图片的大小
 
 @property(nonatomic) double orthographicScale NS_AVAILABLE(10_9, 8_0);
 
 设置焦距(默认为10)
 
 @property(nonatomic) CGFloat focalDistance NS_AVAILABLE(10_9, 8_0);
 
 设置聚焦时，模糊物体模糊度(默认为0)
 
 @property(nonatomic) CGFloat focalBlurRadius NS_AVAILABLE(10_9, 8_0);
 
 决定进入焦点和离开焦点的过渡速度
 
 @property(nonatomic) CGFloat aperture NS_AVAILABLE(10_9, 8_0);
 
 用于检测节点碰撞使用
 
 @property(nonatomic) NSUInteger categoryBitMask NS_AVAILABLE(10_10, 8_0);
 
 走进代码的世界
 
 第一步.创建工程
 
 友情提示:我写的是系列教程,之前讲过的东西，代码注释不在写,如果看不懂，从入门1开始您的学习之旅。
 
 
 第二步.添加框架
 
 
 第三步.添加游戏专用显示视图
 
 // 添加scenekit 游戏专用视图SCNView
 SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
 scnView .backgroundColor = [UIColor blackColor];
 [self.view addSubview:scnView ];
 scnView .allowsCameraControl = true; // 开启操纵照相机选项
 
 第四步.创建游戏场景
 
 scnView .scene = [SCNScene scene];
 
 第五步.添加照相机
 
 // 添加照相机
 SCNCamera *camera = [SCNCamera camera];
 SCNNode *cameraNode =[SCNNode node];
 cameraNode.camera = camera;
 cameraNode.position = SCNVector3Make(0, 0, 50);
 [scnView.scene.rootNode addChildNode:cameraNode];
 
 第六步.添加两个正方体
 
 SCNBox *box1 = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
 box1.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.png"];
 SCNNode *boxNode1 =[SCNNode node];
 boxNode1.geometry = box1;
 [scnView .scene.rootNode addChildNode:boxNode1];
 
 
 SCNBox *box2 = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
 box2.firstMaterial.diffuse.contents = [UIImage imageNamed:@"2.png"];
 SCNNode *boxNode2 =[SCNNode node];
 boxNode2.position = SCNVector3Make(0, 10, -20);
 boxNode2.geometry = box2;
 [scnView .scene.rootNode addChildNode:boxNode2];
 
 我们运行一下:
 
 运行结果
 
 接下来带大家感受以下上面几个重要属性的作用 调节X轴和Y轴视角
 
 // 调节视角
 camera.xFov = 20;
 camera.yFov = 20;
 
 运行结果:
 
 学习是一件很开心的事情,就像玩一样
 
 设置焦距
 
 camera.focalDistance = 45;
 camera.focalBlurRadius = 1;// 默认为0 你要有模糊度的值才能出现这种效果.
 
 运行结果: 焦点我放在第一个物体上
 
 看看性能吧
 
 性能吃紧,君请珍惜
 
 设置相机的最远能照到的物体
 
 camera.zFar = 60;
 
 让学习成为一种习惯
 
 设置正投影
 
 camera.usesOrthographicProjection = true;
 
 设置正投影
 
 设置正投影比例
 
 camera.usesOrthographicProjection = true;
 camera.orthographicScale = 10;
 
 运行结果: 学习是一件很开心的事
 
 补充点内容
 
 上面我们有个操作是开启控制照相机
 
 scnView .allowsCameraControl = true;
 
 到底如何操纵我详细讲解一下
 
 1.一个手指头的时候，照相机对准(0,0,0)沿着球体表面旋转
 2.两个手指头平移手势，照相机是在X轴和Y轴移动
 3.捏合手势，是在Z轴移动

 */

@end
