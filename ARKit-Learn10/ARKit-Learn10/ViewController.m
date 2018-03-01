//
//  ViewController.m
//  ARKit-Learn10
//
//  Created by shiguang on 2018/3/1.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建SCNView视图添加到View中去
    
    SCNView *scnView  = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnView.backgroundColor = [UIColor blackColor];
    scnView.scene = [SCNScene scene];
    scnView.allowsCameraControl = TRUE;
    [self.view addSubview:scnView];
    
    //创建摄像头
    SCNCamera *camera = [SCNCamera camera];
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    camera.automaticallyAdjustsZRange = true;
    cameraNode.position = SCNVector3Make(0, 0, 50);
    [scnView.scene.rootNode addChildNode:cameraNode];
    
    //添加一个四方体
    SCNBox *box = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
    box.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
    SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
    //
    boxNode.position = SCNVector3Make(0, 10, -100);
    [scnView.scene.rootNode addChildNode:boxNode];
    
    // 1.创建粒子系统对象
    SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"fire.scnp" inDirectory:nil];
    // 2.创建一个节点添加粒子系统
    SCNNode *particlenode = [SCNNode node];
    [particlenode addParticleSystem:particleSystem];
    particlenode.position = SCNVector3Make(0, 1, 0);
    // 3.将粒子系统节点设置为四方体的子节点
    [boxNode addChildNode:particlenode];
    
    SCNAction *move = [SCNAction repeatActionForever:[SCNAction moveBy:SCNVector3Make(0, 0, 10) duration:1]];
    
    [boxNode runAction:move];
    
    cameraNode.constraints = @[[SCNLookAtConstraint lookAtConstraintWithTarget:boxNode ]];
}


/*
 13-粒子系统
 
 粒子系统表示三维计算机图形学中模拟一些特定的模糊现象的技术，而这些现象用其它传统的渲染技术难以实现的真实感的 game physics。经常使用粒子系统模拟的现象有火、爆炸、烟、水流、火花、落叶、云、雾、雪、尘、流星尾迹或者象发光轨迹这样的抽象视觉效果等等。
 
 SceneKit 给我们提供了那些粒子系统呢?下面先来展示一下
 
 1.fire(??)
 

 
 2.confetti(五彩纸屑)
 
 
 
 3.bokeh(散景)
 
 
 
 4.Rain(下雨)
 
 
 
 5.Reactor(反应堆)
 
 
 
 6.Smoke(烟)
 
 
 
 7.Star(?)
 
 
 
 以上就是SceneKit 框架中提供给我们的几种粒子系统,下面我做个简单的例子帮助大家学习如何简单的使用粒子系统。
 
 走进代码的世界
 第一步.创建工程就不演示了。 第二步.创建SCNView视图添加到View中去
 
 SCNView *scnView  = [[SCNView alloc]initWithFrame:self.view.bounds];
 scnView.backgroundColor = [UIColor blackColor];
 scnView.scene = [SCNScene scene];
 scnView.allowsCameraControl = TRUE;
 [self.view addSubview:scnView];
 
 第三步.创建摄像头
 
 SCNCamera *camera = [SCNCamera camera];
 SCNNode *cameraNode = [SCNNode node];
 cameraNode.camera = camera;
 camera.automaticallyAdjustsZRange = TRUE;
 cameraNode.position = SCNVector3Make(0, 0, 50);
 [scnView.scene.rootNode addChildNode:cameraNode];
 
 第四步.添加一个四方体
 
 SCNBox *box = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
 box.firstMaterial.diffuse.contents = @"1.PNG";
 SCNNode *boxNode = [SCNNode nodeWithGeometry:box];
 boxNode.position = SCNVector3Make(0, 10, -100);
 [scnView.scene.rootNode addChildNode:boxNode];
 
 第五步.创建一个粒子系统文件
 

 
 第六步.如何把粒子添加到刚才创建的四方体上呢?
 
 // 1.创建粒子系统对象
 SCNParticleSystem *particleSystem = [SCNParticleSystem particleSystemNamed:@"fire.scnp" inDirectory:nil];
 // 2.创建一个节点添加粒子系统
 SCNNode *node = [SCNNode node];
 [node addParticleSystem:particleSystem];
 node.position = SCNVector3Make(0, -1, 0);
 // 3.将粒子系统节点设置为四方体的子节点
 [boxNode addChildNode:node];
 
 完成之一步，今天我们的内容就结束了,是不是很简单！
 
 运行结果:
 

 */

@end
