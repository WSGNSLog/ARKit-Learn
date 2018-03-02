//
//  ViewController.m
//  ARKit-Learn13
//
//  Created by shiguang on 2018/3/2.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //我们创建SCNView
    SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnView.backgroundColor = [UIColor blackColor];
    scnView.scene = [SCNScene scene];
    scnView.allowsCameraControl = true;
    [self.view addSubview:scnView];
    
    //添加照相机
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.position = SCNVector3Make(0, 0, 20);
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.automaticallyAdjustsZRange = true;
    [scnView.scene.rootNode addChildNode:cameraNode];
    
}

/*
 
 16-过渡动画
 
 模型到模型之间的过渡，两个或者多个模型的数据顶点必须相同
 
 先看效果图:
 
 我们先看一下我们的模型文件
 
 1.一个四方形,但是边上有很多顶点 培养学习的兴趣很重要
 
 2.折皱的面
 
 让学习成为一种习惯
 
 接下来，我们让这两个面平滑过渡
 
 实战讲解
 第一步 创建工程(略)
 
 第二步 添加我们的文件到工程中去
 
 8C4C8A7E-BDAE-4AE4-BC51-B13A871FD4C0.png
 
 第三步 我们创建SCNView
 SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
 scnView.backgroundColor = [UIColor blackColor];
 scnView.scene = [SCNScene scene];
 scnView.allowsCameraControl = true;
 [self.view addSubview:scnView];
 
 第四步 添加照相机
 SCNNode *cameraNode = [SCNNode node];
 cameraNode.position = SCNVector3Make(0, 0, 20);
 cameraNode.camera = [SCNCamera camera];
 cameraNode.camera.automaticallyAdjustsZRange = true;
 [scnView.scene.rootNode addChildNode:cameraNode];
 
 第六步 索引到模型中的几何对象
 NSURL *url1 = [[NSBundle mainBundle]URLForResource:@"aaa" withExtension:@"dae"];
 NSURL *url2 = [[NSBundle mainBundle]URLForResource:@"aaa2" withExtension:@"dae"];
 SCNScene *scene1 = [SCNScene sceneWithURL:url1 options:nil error:nil];
 SCNScene *scene2 = [SCNScene sceneWithURL:url2 options:nil error:nil];
 SCNGeometry *g1 = [scene1.rootNode childNodeWithName:@"plane" recursively:true].geometry;
 SCNGeometry *g2 = [scene2.rootNode childNodeWithName:@"plane" recursively:true].geometry;
 g1.firstMaterial.diffuse.contents = @"mapImage.png";
 g2.firstMaterial.diffuse.contents = @"mapImage.png";
 
 第七步 把第一个几何体绑定到节点上添加到场景中去
 SCNNode *planeNode = [SCNNode node];
 [scnView.scene.rootNode addChildNode:planeNode];
 planeNode.geometry = g1;
 [scnView.scene.rootNode addChildNode:planeNode];
 
 到这里我们的准备工作已经完成，下面就是我们今天的重点内容
 
 第八步 创建一个过渡期,添加我们要过渡的模型
 planeNode.morpher = [[SCNMorpher alloc]init];
 planeNode.morpher.targets = @[g2];
 
 第九步 设置过渡动画
 CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"morpher.weights[0]"]; // 0 代表过渡目标数组的第一个模型
 animation.fromValue = @0.0;
 animation.toValue = @1.0;
 animation.autoreverses = YES;
 animation.repeatCount = INFINITY;
 animation.duration = 2;
 [planeNode addAnimation:animation forKey:nil];
 
 高级内容
 下面叫大家一种简单的方式实现上面的效果,先给看一张图
 
 模型文件截图
 
 我们可以让模型设计师帮我们把过渡到指定的目标几何绑定到我们的文件中
 
 接下来，再看我们的代码怎么写
 
 NSURL *url3 = [[NSBundle mainBundle]URLForResource:@"foldingMap" withExtension:@"dae"];
 SCNNode *node1 = [[SCNScene sceneWithURL:url3 options:nil error:nil].rootNode childNodeWithName:@"Map" recursively:true];
 node1.geometry.firstMaterial.diffuse.contents = @"1.PNG";
 [scnView.scene.rootNode addChildNode:node1];
 
 // 过渡动画和上面的写法一样
 CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"morpher.weights[0]"];
 animation.fromValue = @0.0;
 animation.toValue = @1.0;
 animation.autoreverses = YES;
 animation.repeatCount = INFINITY;
 animation.duration = 2;
 [node1 addAnimation:animation forKey:nil];
 
 */


@end
