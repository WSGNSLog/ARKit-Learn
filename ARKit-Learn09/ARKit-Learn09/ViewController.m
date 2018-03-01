//
//  ViewController.m
//  ARKit-Learn09
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
 
 12-物理世界
 
 在第十一节中,我们看到,给物体了一个动态的身体,的身体，物体就自动的掉落下来,大家有没有思考过为什么,因为在我们创建的场景中可能存在着一种力,这个力很有可能是重力。我没有深究它,今天我们就详细的了解一下，这个物理世界到底是什啥玩意!
 
 ####先从类(SCNPhysicsWorld)的属性开始探究
 
 重力加速度: 可以设置方向和大小
 
 @property(nonatomic) SCNVector3 gravity;
 
 我们试着日志输出一下场景中的这个值
 
 NSLog(@"x:%f",scnView.scene.physicsWorld.gravity.x);
 NSLog(@"y:%f",scnView.scene.physicsWorld.gravity.y);
 NSLog(@"z:%f",scnView.scene.physicsWorld.gravity.z);
 
 输出结果:
 
 x:0.000000
 y:-9.800000
 z:0.000000
 
 我们发现我们创建创景的时候,系统已经给我添加了一个向下的重力,如果把重力加速度设置为(0,0,0）所有物体都会失重。
 
 模拟运行的速度(默认值为1)
 
 @property(nonatomic) CGFloat speed;
 
 用法:
 
 如果你想要增加或者减小模拟运行的速度，可以调节这个属性，但是会影响模拟的物理世界的真实性。
 
 执行时间的步伐值(默认为1/60s 即60HZ)
 
 @property(nonatomic) NSTimeInterval timeStep;
 
 碰撞检测代理
 
 @property(atomic, assign, nullable) id <SCNPhysicsContactDelegate> contactDelegate;
 
 友情提示
 
 物体的碰撞检测，内容比较多,我们在中级篇会详细讲解
 
 增加和删除行为
 
 - (void)addBehavior:(SCNPhysicsBehavior *)behavior;
 - (void)removeBehavior:(SCNPhysicsBehavior *)behavior;
 - (void)removeAllBehaviors;
 -
 
 友情提示
 
 这个暂时不讲解,因为我们还没有讲物体的行为的内容,后面专门来讲。
 
 下面是一些测试的方法
 
 - (NSArray<SCNPhysicsContact *> *)contactTestBetweenBody:(SCNPhysicsBody *)bodyA andBody:(SCNPhysicsBody *)bodyB options:(nullable NSDictionary<NSString *, id> *)options;
 - (NSArray<SCNPhysicsContact *> *)contactTestWithBody:(SCNPhysicsBody *)body options:(nullable NSDictionary<NSString *, id> *)options;
 - (NSArray<SCNPhysicsContact *> *)convexSweepTestWithShape:(SCNPhysicsShape *)shape fromTransform:(SCNMatrix4)from toTransform:(SCNMatrix4)to options:(nullable NSDictionary<NSString *, id> *)options;
 
 这些测试方法,后面用到会讲,莫着急。
 
 立即执行碰撞检测
 
 - (void)updateCollisionPairs
 
 提示
 
 默认情况下,执行碰撞检测是在下一次模拟运行的时候,如果此次运行有碰撞,想要立刻执行碰撞检测，则调用这个方法。
 
 物理世界对象主要干那些事情:
 
 控制全局属性 (比如重力和其他类型的力 还有它的速度)
 间接修改或者注册场景中的物理身体的连接等行为
 管理物理身体的碰撞行为
 执行特殊的接触测试(如发射,扫射)

 */


@end
