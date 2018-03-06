//
//  ViewController.m
//  ARKit-Learn17
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
    
    
}


/*

 20-教你玩转游戏中的各种力

 学习内容
 1.了解在SceneKit游戏框架中存在的力
 2.理解各种力对物体产生的效果
 3.用代码实现各种力
 
 想和你聊聊
 1.力对物体产生作用有个前期条件那就是物体必须有物理身体(SCNPhysicsBody) 2.一个物体可能受到很多力的作用 3.如果力加到静态身体和运动身体上会产生什么影响？你应该自己去尝试。 4.力都能对那些类型的物体产生影响呢？怎么模拟龙卷风呢? 5.如何让所有物体失重呢? ...
 
 你在学习一个东西的时候，应该想出很多问题,这样我们才能带着疑问探索,你会觉得很好玩。我们现在就去玩玩.
 
 认识一个类(SCNPhysicsField)
 提示:
 
 这个类几乎包含了物理世界存在的各种力,我们要掌握它的属性的含义
 
 控制力的强度(默认为1.0)
 
 @property(nonatomic) CGFloat strength;
 
 决定力的衰减指数(默认为0)
 
 //  如果值不为0，力的计算公式是 (1 / distance ^ falloffExponent)
 @property(nonatomic) CGFloat falloffExponent;
 
 设置距离力中心点的最小不衰减距离,在这个范围内力不衰减(默认值为1e-6)
 
 @property(nonatomic) CGFloat minimumDistance;
 
 设置力的激活状态(默认为YES)
 
 @property(nonatomic, getter=isActive) BOOL active;
 
 阻止任何在它作用范围内的力(默认为NO)
 
 @property(nonatomic, getter=isExclusive) BOOL exclusive;
 
 决定力作用的范围
 
 @property(nonatomic) SCNVector3 halfExtent;
 
 决定作用的范围是个四方体还是一个球体(默认NO)
 
 @property(nonatomic) BOOL usesEllipsoidalExtent;
 
 决定力作用的范围是在指定的范围内，还是范围外
 
 @property(nonatomic) SCNPhysicsFieldScope scope;
 
 力的中心到影响范围的偏移
 
 @property(nonatomic) SCNVector3 offset;
 
 力的方向(默认为(0,-1,0))
 
 // 注意它只对线性力有影响，比如重力
 @property(nonatomic) SCNVector3 direction;
 
 决定哪些节点可以被影响(高级用法,暂时不讲,当学习了碰撞检测之后,在悄悄告诉你)
 
 @property(nonatomic) NSUInteger categoryBitMask NS_AVAILABLE(10_10, 8_0);
 
 上面是一些基本属性,你应该都掌握了吧,下面我们介绍一下,这个类到底包含了那些力,我喜欢图文并茂,我相信你也喜欢,所以我自己搭建了工程,开始玩起来了,你不自己动手,你就没法掌握,走马观花,永远是过客,身历其境,才能感受其魅力!
 
 拖拽力
 
 先提几个问题:
 
 静态身体,动态身体,运动什么?那些可以添加速度?怎么添加速度?
 拖拽力,能不能让静态的物体运动呢?
 
 估计有些人比较忙没有时间去一个一个尝试一些,没关系,这就带你们一个一个去尝试一下。
 
 a.实验1-给三种身体分别添加一个力(0,-10,0)
 
 静态身体:等了老长时间了,微丝不懂
 
 动态身体:哥们你别走啊,等等我
 
 运动身体:一动不动
 
 结论:
 
 只有动态身体可以添加速度,静态身体和运动身体添加速度没有效果,没必要进行实验2了
 
 讲解我们的拖拽力
 
 // 创建拖拽力
 + (SCNPhysicsField *)dragField;
 
 我们给动态身体添加一个(0,0,-1000)的速度,然后给它添加一个30的拖拽力。
 
 代码:
 
 SCNNode *drayFieldNode = [SCNNode node];
 drayFieldNode.physicsField = [SCNPhysicsField dragField];
 drayFieldNode.physicsField.strength = 30;
 drayFieldNode.physicsField.direction = SCNVector3Make(0, -1, 0);
 [boxNode addChildNode:drayFieldNode];
 
 添加拖拽力
 
 你猜:
 
 如果我们把拖拽力的方向变成(0,1,0) 还会是这样效果吗?
 
 运行结果:
 
 学习是要花费时间的
 
 结论:
 
 拖拽力没有方向，只有大小,主要是阻碍物体的运动,如果真要说方向朝向哪里，就是和物体运动方向相反,如果物体没有速度,拖拽力不会对物体产生影响。结论是否正确,你猜!
 
 创建一个围绕轴旋转的力
 
 + (SCNPhysicsField *)vortexField;
 
 代码:
 
 - (void)addVortexField{
 SCNNode *vortexFieldNode = [SCNNode node];
 vortexFieldNode.physicsField = [SCNPhysicsField vortexField];
 vortexFieldNode.physicsField.strength = 1;
 vortexFieldNode.physicsField.direction = SCNVector3Make(-1, 0, 0);
 [self.scnView.scene.rootNode addChildNode:vortexFieldNode];
 }
 
 龙卷风来了
 
 接下来,我们改变一下方向(-1, 0, 0)
 
 让学习成为一种习惯
 
 结论:
 
 旋转力类似右手螺旋定则,设置的轴线方向为大拇指的指向的方向,手指环绕的方向才是力的方向。
 
 创建朝向一个点的力
 
 + (SCNPhysicsField *)radialGravityField;
 
 代码:
 
 -(void)addRadialGravity{
 SCNNode *radialGravityNode = [SCNNode node];
 radialGravityNode.physicsField = [SCNPhysicsField radialGravityField];
 radialGravityNode.physicsField.strength = -1000;
 radialGravityNode.position = SCNVector3Make(0, 0, 0);
 [self.scnView.scene.rootNode   addChildNode:radialGravityNode];
 }
 
 运行结果: 让学习成为一种习惯
 
 总结:
 
 可以设置位置,力朝向设置的位置。如果设置负值,力是朝向外边的。
 
 线性力
 
 + (SCNPhysicsField *)linearGravityField;
 
 代码:
 
 -(void)addLineGravity{
 SCNNode *lineGravityNode = [SCNNode node];
 lineGravityNode.physicsField = [SCNPhysicsField linearGravityField];
 lineGravityNode.physicsField.strength = 1;
 lineGravityNode.physicsField.direction = SCNVector3Make(0, 0, -1);
 [self.scnView.scene.rootNode   addChildNode:lineGravityNode];
 }
 
 我们给场景中添加一个(0,-1,0)方向的线性力,运行结果如下图:
 
 线性力
 
 创建随机的力
 
 //   smoothness 噪点的平滑性 animationSpeed运动的速度
 + (SCNPhysicsField *)noiseFieldWithSmoothness:(CGFloat)smoothness animationSpeed:(CGFloat)speed;
 
 代码:
 
 -(void)addNoiseField{
 SCNNode *noiseFieldNode = [SCNNode node];
 noiseFieldNode.physicsField = [SCNPhysicsField noiseFieldWithSmoothness:0 animationSpeed:1];
 noiseFieldNode.physicsField.strength = 5;
 [self.scnView.scene.rootNode addChildNode:noiseFieldNode];
 }
 
 你知道用在什么地方吗?
 
 比如你想营造下雪的效果 或者 萤火虫效果，可以使用这个力
 
 我们运行看一下效果:
 
 让学习成为一种习惯
 
 一种和速度成正比的随机力
 
 + (SCNPhysicsField *)turbulenceFieldWithSmoothness:(CGFloat)smoothness animationSpeed:(CGFloat)speed;
 
 代码:
 
 -(void)addTurbulenceField{
 SCNNode *turbulenceFieldNode = [SCNNode node];
 turbulenceFieldNode.physicsField  = [SCNPhysicsField turbulenceFieldWithSmoothness:0 animationSpeed:1];
 turbulenceFieldNode.physicsField.strength = 5;
 [self.scnView.scene.rootNode addChildNode:turbulenceFieldNode];
 }
 
 运行结果:
 
 让学习成为一种习惯
 
 弹性力(胡克定律)
 
 + (SCNPhysicsField *)springField;
 
 代码:
 
 SCNNode *springField = [SCNNode node];
 springField.physicsField = [SCNPhysicsField springField];
 springField.physicsField.strength = 0.01;
 springField.position = SCNVector3Make(0, 30, 0);
 [self.scnView.scene.rootNode addChildNode:springField];
 
 运行效果:
 
 让学习成为一种习惯
 
 提示:
 
 创建这个力,需要设置力的位置和力的大小
 
 创建电场
 
 + (SCNPhysicsField *)electricField;
 
 提示:
 
 这种力的大小,取决于物体带的电荷的多少和距离磁场的距离 放向取决于电荷的正负。
 
 代码:
 
 -(void)addElectricField{
 SCNNode *electricFieldNode = [SCNNode node];
 electricFieldNode.physicsField = [SCNPhysicsField electricField];
 electricFieldNode.physicsField.strength = 10;
 [self.scnView.scene.rootNode addChildNode:electricFieldNode];
 }
 
 运行结果: 让学习成为一种习惯
 
 提示:
 
 电场默认的属性是正的
 
 如何创建带电荷的节点对象呢？给段代码自己看看,后面会专门讲解
 
 SCNNode *boxNode = [SCNNode node];
 boxNode.geometry = [SCNBox boxWithWidth:4 height:4 length:4 chamferRadius:0];
 boxNode.geometry.firstMaterial.diffuse.contents = [UIColor redColor];
 boxNode.physicsBody = [SCNPhysicsBody dynamicBody];
 boxNode.position = SCNVector3Make(0, 30, 0);
 boxNode.physicsBody.velocity = SCNVector3Make(0, 0, 0);
 [self.scnView.scene.rootNode addChildNode:boxNode];
 boxNode.physicsBody.charge = -10; // 创建电荷正负和大小
 
 创建磁场
 
 + (SCNPhysicsField *)magneticField;
 
 代码:
 
 - (void)addMagneticField{
 SCNNode *magneticFielddNode = [SCNNode node];
 magneticFielddNode.physicsField = [SCNPhysicsField magneticField];
 magneticFielddNode.physicsField.strength = -0.5;
 [self.scnView.scene.rootNode addChildNode:magneticFielddNode];
 }
 
 运行结果:
 
 让学习成为一种习惯
 
 总结:
 
 吸引或者排斥物体,取决于电荷的大小,正负,速度,距离等因素
 
 自定义力
 
 typedef SCNVector3 (^SCNFieldForceEvaluator)(SCNVector3 position, SCNVector3 velocity, float mass, float charge, NSTimeInterval time);
 
 友情提示:
 
 中级篇,暂时不讲,高级篇,我们详细讲解。 我们已经把SceneKit 框架中的包含的所有力介绍完毕,相信你也已经掌握,接下来,我们做一个小小的联系巩固一下我们今天学的知识!
 
 下面带大家实现下面的效果
 
 让学习成为一种习惯
 
 走进代码的世界
 1.创建工程(略)
 2.在控制器中添加框架
 
 让学习成为一种习惯
 
 3.创建游戏视图SCNView
 
 self.scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
 self.scnView.backgroundColor = [UIColor blackColor];
 self.scnView.scene = [SCNScene scene];
 [self.view addSubview:self.scnView];
 
 4.添加照相机
 
 SCNNode *cameraNode = [SCNNode node];
 cameraNode.camera = [SCNCamera camera];
 cameraNode.position = SCNVector3Make(0, 30, 30);
 cameraNode.rotation = SCNVector4Make(1, 0, 0, -M_PI/4);
 cameraNode.camera.automaticallyAdjustsZRange = true;
 [self.scnView.scene.rootNode addChildNode:cameraNode];
 
 5.添加一个地板
 
 SCNNode *floorNode = [SCNNode node];
 self.floorNode = floorNode;
 floorNode.geometry = [SCNFloor floor];
 floorNode.geometry.firstMaterial.diffuse.contents = @"floor.jpg";
 floorNode.physicsBody = [SCNPhysicsBody staticBody];
 [self.scnView.scene.rootNode addChildNode:floorNode];
 
 6.创建粒子系统文件
 
 粒子文件
 
 选择fire选项
 
 我给它起名字叫做"fire"
 
 7.创建圆筒给里面把粒子装上
 
 SCNTube *tube = [SCNTube tubeWithInnerRadius:1 outerRadius:1.2 height:4];
 tube.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 SCNNode *tubeNode =[SCNNode nodeWithGeometry:tube];
 tubeNode.physicsBody = [SCNPhysicsBody kinematicBody];
 tubeNode.position = SCNVector3Make(-5, 2, 0);
 [self.scnView.scene.rootNode addChildNode:tubeNode];
 
 // 装上粒子,也就是说添加子节点
 SCNParticleSystem *particleSytem = [SCNParticleSystem particleSystemNamed:@"fire.scnp" inDirectory:nil];
 // 设置和粒子产生碰撞的节点
 particleSytem.colliderNodes = @[tubeNode1,self.floorNode];
 particleSytem.affectedByPhysicsFields = true;// 让粒子可以受力的影响
 // 设置粒子的电荷
 particleSytem.particleCharge = 10;
 SCNNode *particleNode = [SCNNode node];
 particleNode.position = SCNVector3Make(0, 0, 0);
 [particleNode addParticleSystem:particleSytem];
 particleNode.physicsBody = [SCNPhysicsBody dynamicBody];
 [tubeNode addChildNode:particleNode];
 
 8.再创建一个圆筒，给圆筒添加一个电场
 
 SCNNode *tubeNode1 = [SCNNode nodeWithGeometry:[SCNTube tubeWithInnerRadius:4.5 outerRadius:5 height:2]];
 tubeNode1.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.PNG"];
 tubeNode1.position = SCNVector3Make(6, 1, 0);
 [self.scnView.scene.rootNode addChildNode:tubeNode1];
 SCNNode *electricFieldNode = [SCNNode node];
 electricFieldNode.physicsField = [SCNPhysicsField electricField];
 electricFieldNode.physicsField.strength = -10;
 [tubeNode1 addChildNode:electricFieldNode];
 

 */


@end
