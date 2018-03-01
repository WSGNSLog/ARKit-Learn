//
//  ViewController.m
//  ARKit-Learn08
//
//  Created by shiguang on 2018/3/1.
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

 11-游戏中的物理身体
 什么是物理身体?
 
 物理知识,告诉我们，力可以作用到物体上,物体一般都是有质量的，有质量的物体,力才能对它起作用。根据F= m*a; 这里的m(质量) 我们认为就是物理身体的一部分属性，还有一个就是形状，比如这个正方体，力加到面上，和力作用到几个顶点上，产生的效果完全是不一样的。
 
 SceneKit 游戏引擎中提供了三种物理身体的属性,下面分别介绍.
 
 静态身体(StaticBody)
 
 Scenekit_03.gif
 
 理解:
 
 动画下面的柱子添加了静态的物理身体,你可以这样理解，它有一个很大的质量。外力对他不起作用。
 
 动态身体(Dynamic)
 
 让学习成为一种习惯
 
 理解:
 
 你可以这样理解，这个物体有自己的质量,并且不是无限大，能够收到力的作用。
 
 运动身体(kinematic)
 
 学习要多思考
 
 提示: 感觉和静态身体没有什么区别,这时候，我们要找出他们的区别来，就只能各种尝试了!当然官网也是有说明的,对于爱折腾的我,就喜欢先猜测一下.
 
 尝试1:
 
 我们设置下面的柱子为静态身体,球也为静态身体，给球设置一个向下移动的行为
 
 让思考也变成习惯
 
 尝试2:
 
 设置下面的柱子为静态身体，球为运动身体
 
 让思考也变成习惯
 
 尝试3:
 
 设置下面的柱子为动态身体,球为动态身体
 
 思考力决定你能走多远
 
 尝试4:
 
 设置下面的柱子为动态身体,球为运动身体
 
 多思考就能发现新大陆
 
 总结:
 
 静态身体 不能主动给物体施作用,不能和动态身体和运行身体起作用
 动态物体 能够作用动态物体，但是不是作用静态身体和运动身体,但能被运动身体作用
 运动身体 不能作用静态身体,也不能被其他身体作用，但是作用动态身体
 如何创建物理身体
 
 他是(节点)SCNNode的一个属性
 
 @property(nonatomic, retain, nullable) SCNPhysicsBody *physicsBody NS_AVAILABLE(10_10, 8_0);
 
 下面是三种物理身体的创建方法
 
 // 静态身体创建
 sphereNode.physicsBody = [SCNPhysicsBody staticBody];
 // 动态身体创建
 sphereNode.physicsBody = [SCNPhysicsBody dynamicBody];
 // 运动身体创建
 sphereNode.physicsBody = [SCNPhysicsBody kinematicBody];
 
 我们刚才说过，物理身体是有形状的，如果你不指定，默认为几何模型自身的形状，那我们怎么自定义呢?
 
 + (instancetype)bodyWithType:(SCNPhysicsBodyType)type shape:(nullable SCNPhysicsShape *)shape;
 @property(nonatomic, retain, nullable) SCNPhysicsShape *physicsShape;
 

 */


@end
