//
//  ViewController.m
//  ARKit-Learn05
//
//  Created by shiguang on 2018/2/28.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()

@property (nonatomic,retain) SCNView *gameView;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gameView = [[SCNView alloc]initWithFrame:self.view.bounds];
    self.gameView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.gameView];
    
    self.gameView.allowsCameraControl = true;
    
    //设置场景
    //SCNView 对象的scene 属性,系统默认为nil,所以我们必须手动创建scene
    self.gameView.scene = [SCNScene scene];
    
    //我们给游戏视图中添加一个正方形块节点和一个球体节点
    // 创建正方块
    SCNBox *box = [SCNBox boxWithWidth:0.5 height:0.5 length:0.5 chamferRadius:0];// 正方体
    // 创建球体
    SCNSphere *sphere = [SCNSphere sphereWithRadius:0.1];// 设置球体半径为0.1
    
    // 把两个结合体绑定到节点上
    SCNNode *boxNode = [SCNNode node];
    boxNode.geometry = box;
    boxNode.position = SCNVector3Make(0, 0, -11); // 把节点的位置固定在(0,0,-11)
    SCNNode *sphereNode = [SCNNode node];
    sphereNode.geometry = sphere;
    sphereNode.position = SCNVector3Make(0, 0, -10); // 把节点的位置固定在(0,0,-11)
    
    // 添加节点到场景中去
    [self.gameView.scene.rootNode addChildNode:boxNode];
    [self.gameView.scene.rootNode addChildNode:sphereNode];
    

    
    //第六步.我们给场景中只添加一个环境光
    [self setSCNLightTypeAmbient];
    
    
    //问题1:设置颜色为yellowColor 为什么物体不是yellow呢？
    
    //因为物体材质中没有黄色成分,比如你传的是一件绿色的衣服,你用黄光照射他,你不可能看见衣服是绿色或者黄色的,这里你可以把物体的颜色变为黄色试试看。
    
    //问题2:那为什么和不添加环境光一样的效果呢？
    
    //因为系统本身如果我们不提供任何光源，它会自动添加环境光，如果检测到我们添加了光源，它将不会帮我们添加环境光
    
    //第七步.我们向游戏场景中只添加一个点光源
    [self setSCNLightTypeOmni];

    //第八步.只添加一个平行方向光源
    [self setSCNLightTypeDirectional];
    
    //第九步.添加聚焦光源
    [self setSCNLightTypeSpot];
    
//    [self setSCNLightTypeSpot2];
}
- (void)setSCNLightTypeAmbient{
    
    SCNLight *light = [SCNLight light]; // 创建灯光
    light.type = SCNLightTypeAmbient; // 设置灯光类型
    light.color = [UIColor yellowColor]; // 设置灯光颜色
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.light  = light;
    [self.gameView.scene.rootNode addChildNode:lightNode];
}
- (void)setSCNLightTypeOmni{
    
    SCNLight *light = [SCNLight light];// 创建光对象
    light.type = SCNLightTypeOmni;// 设置类型
    light.color = [UIColor yellowColor]; // 设置光的颜色
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.position = SCNVector3Make(0, 0, 100); // 设置光源节点的位置
    lightNode.light  = light;
    [self.gameView.scene.rootNode addChildNode:lightNode]; // 添加到场景中去
    //我们的点光源的位置为(0,0,100),我们把位置改为(0,100,100),看一下效果，对比一下，你就掌握了这种光的特点
}
- (void)setSCNLightTypeDirectional{
    SCNLight *light = [SCNLight light];// 创建光对象
    light.type = SCNLightTypeDirectional;// 设置类型
    light.color = [UIColor yellowColor]; // 设置光的颜色
    
    SCNNode *lightNode = [SCNNode node];
    lightNode.position = SCNVector3Make(0, 10, -100); // 设置光源节点的位置
    lightNode.light  = light;
    [self.gameView.scene.rootNode addChildNode:lightNode]; // 添加到场景中去
    //下面我们把它的位置放在(1000,1000,1000) 看一下结果
    
    //位置在(1000,1000,1000)
    
    //一点变化也没有,接着下面我们改变一下照射方向,这种光的默认方向为z轴负方向，我们把它设置成Y轴负方向
    
    lightNode.rotation = SCNVector4Make(1, 0, 0, -M_PI/2.0);

}
- (void)setSCNLightTypeSpot{
    //第九步.添加聚焦光源
    
    SCNLight *light = [SCNLight light];// 创建光对象
    light.type = SCNLightTypeSpot;// 设置类型
    light.color = [UIColor yellowColor]; // 设置光的颜色
    light.castsShadow = TRUE;// 捕捉阴影
    SCNNode *lightNode = [SCNNode node];
    lightNode.position = SCNVector3Make(0, 0, -9); // 设置光源节点的位置
    lightNode.light  = light;
    [self.gameView.scene.rootNode addChildNode:lightNode]; // 添加到场景中去
    
    
}
- (void)setSCNLightTypeSpot2{
    //聚焦光源
    //我们试着使用一下照射范围的属性,让它只照射到球
    
    SCNLight *light = [SCNLight light];// 创建光对象
    light.type = SCNLightTypeSpot;// 设置类型
    light.color = [UIColor yellowColor]; // 设置光的颜色
    light.castsShadow = TRUE;// 捕捉阴影
    
    light.zFar = 10; // 设置它最远能照射单位10 的地方,也就是说只能照到 球体的位置
    SCNNode *lightNode = [SCNNode node];
    lightNode.position = SCNVector3Make(0, 0, 0); // 设置光源节点的位置
    lightNode.light  = light;
    [self.gameView.scene.rootNode addChildNode:lightNode]; // 添加到场景中去

}
/*

 6-SCNLight
 灯光篇
 今天我们要学习的SceneKit 游戏框架中的几种光以及如何使用它们！
 
 1.熟悉SCNLight 类 2.理解四种光源的作用 3.学会如何选择在游戏场景中使用光源.
 
 光的介绍
 
 环境光(SCNLightTypeAmbient)
 这种光的特点,没有方向，位置在无穷远处，光均匀的散射到物体上.
 
 点光源(SCNLightTypeOmni)
 有固定的位置，方向360度,可以衰减
 
 平行方向光(SCNLightTypeDirectional)
 只有照射的方向，没有位置,不会衰减
 
 聚焦光源(SCNLightTypeSpot) 可
 光源有固定的位置，也有方向，也有照射区域 ，可以衰减
 
 SCNLight 介绍
 
 我们使用光源,主要用到的类就是SCNLight,我们把这个类的属性分析一下。
 
 创建光对象
 +(instancetype)light;
 
 设置灯光类型,就是上面讲的那个类型
 @property(nonatomic, copy) NSString *type;
 
 灯光的颜色
 @property(nonatomic, retain) id color;
 
 灯光的名字,可以用来索引灯光用
 @property(nonatomic, copy, nullable) NSString *name;
 
 是否支持投射阴影,注意，这个属性只在点光源或者平行方向光源起作用
 @property(nonatomic) BOOL castsShadow;
 
 设置阴影的颜色，默认为透明度为50%的黑色
 @property(nonatomic, retain) id shadowColor;
 
 设置阴影的采样角度 默认值为3
 @property(nonatomic) CGFloat shadowRadius;
 
 设置阴影贴图的大小,阴影贴图越大，阴影越精确，但计算速度越慢。如果设置为{ 0 0}阴影贴图的大小自动选择，默认为{0，0}
 @property(nonatomic) CGSize shadowMapSize NS_AVAILABLE(10_10, 8_0);
 
 设置每一帧计算阴影贴图的次数，默认为一次
 @property(nonatomic) NSUInteger shadowSampleCount NS_AVAILABLE(10_10, 8_0);
 
 设置阴影模式(默认)
 @property(nonatomic) SCNShadowMode shadowMode NS_AVAILABLE(10_10, 8_0);
 // 可选值为下面三种
 SCNShadowModeForward   = 0, 通过Alpha值得变化决定阴影
 SCNShadowModeDeferred  = 1, 根据最后的颜色决定阴影，一般不太用，除非有多个光源作用的情况下
 SCNShadowModeModulated = 2 光没有作用，只投射阴影，一般用于图案作为阴影的情况下，比如镜像渐变图像(黑白)
 
 阴影的深度偏移量
 @property(nonatomic) CGFloat shadowBias NS_AVAILABLE(10_10, 8_0);
 
 平行方向放阴影比例值调节
 @property(nonatomic) CGFloat orthographicScale NS_AVAILABLE(10_10, 8_0);
 
 光作用的范围
 @property(nonatomic) CGFloat zFar NS_AVAILABLE(10_10, 8_0);
 @property(nonatomic) CGFloat zNear NS_AVAILABLE(10_10, 8_0);
 
 光衰减的开始距离和结束距离(Omni or Spot light)
 @property(nonatomic) CGFloat attenuationStartDistance NS_AVAILABLE(10_10, 8_0);// 默认为0
 @property(nonatomic) CGFloat attenuationEndDistance NS_AVAILABLE(10_10, 8_0);// 默认为1
 @property(nonatomic) CGFloat attenuationFalloffExponent NS_AVAILABLE(10_10, 8_0);// 1 表示线性减弱 2表示平方减弱
 
 聚焦光的发射点的方向和光线强度最弱的时候的夹角
 @property(nonatomic) CGFloat spotInnerAngle  NS_AVAILABLE(10_10, 8_0);// 默认为0度
 @property(nonatomic) CGFloat spotOuterAngle  NS_AVAILABLE(10_10, 8_0);// 默认为45度
 
 当你要使用碰撞检测时，请设置下面的属性
 @property(nonatomic) NSUInteger categoryBitMask NS_AVAILABLE(10_10, 8_0);
 
 点光源材质属性(只支持spot类型)
 @property(nonatomic, readonly, nullable) SCNMaterialProperty *gobo NS_AVAILABLE(10_9, 8_0);
 
 你最爱的代码部分
 
 我们已经熟悉了光源类的具体使用方法,下面我们就来验证一下理论的真实性！ 第一步.创建工程
 
 创建工程
 
 第二步.添加游戏框架<SceneKit/SceneKit.h>
 
 第三步.创建一个游戏框架专属的视图(SCNView类型)
 
 self.gameView = [[SCNView alloc]initWithFrame:self.view.bounds];
 self.gameView.backgroundColor = [UIColor blackColor];
 [self.view addSubview:self.gameView];
 运行一下,如果界面是下面这样，表示创建成功
 ![运行结果](http://upload-images.jianshu.io/upload_images/1594482-f87efb77b12fb74d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 
 我们把摄像机控制打开,方便我们观察视图
 
 self.gameView.allowsCameraControl = true;
 
 第四步.设置场景
 
 友情提示
 
 SCNView 对象的scene 属性,系统默认为nil,所以我们必须手动创建scene
 
 self.gameView.scene = [SCNScene scene];
 
 第五步.我们给游戏视图中添加一个正方形块节点和一个球体节点
 
 // 创建正方块
 SCNBox *box = [SCNBox boxWithWidth:0.5 height:0.5 length:0.5 chamferRadius:0];// 正方体
 
 // 创建球体
 SCNSphere *sphere = [SCNSphere sphereWithRadius:0.1];// 设置球体半径为0.1
 
 // 把两个结合体绑定到节点上
 SCNNode *boxNode = [SCNNode node];
 boxNode.geometry = box;
 boxNode.position = SCNVector3Make(0, 0, -11); // 把节点的位置固定在(0,0,-11)
 SCNNode *sphereNode = [SCNNode node];
 sphereNode.geometry = sphere;
 sphereNode.position = SCNVector3Make(0, 0, -10); // 把节点的位置固定在(0,0,-11)
 
 // 添加节点到场景中去
 [self.gameView.scene.rootNode addChildNode:boxNode];
 [self.gameView.scene.rootNode addChildNode:sphereNode];
 
 运行结果: Scenekit_03.gif
 
 第六步.我们给场景中只添加一个环境光
 
 SCNLight *light = [SCNLight light]; // 创建灯光
 light.type = SCNLightTypeAmbient; // 设置灯光类型
 light.color = [UIColor yellowColor]; // 设置灯光颜色
 
 SCNNode *lightNode = [SCNNode node];
 lightNode.light  = light;
 [self.gameView.scene.rootNode addChildNode:lightNode];
 
 运行结果 环境光
 
 问题1:设置颜色为yellowColor 为什么物体不是yellow呢？
 
 因为物体材质中没有黄色成分,比如你传的是一件绿色的衣服,你用黄光照射他,你不可能看见衣服是绿色或者黄色的,这里你可以把物体的颜色变为黄色试试看。
 
 问题2:那为什么和不添加环境光一样的效果呢？
 
 因为系统本身如果我们不提供任何光源，它会自动添加环境光，如果检测到我们添加了光源，它将不会帮我们添加环境光
 
 第七步.我们向游戏场景中只添加一个点光源
 
 SCNLight *light = [SCNLight light];// 创建光对象
 light.type = SCNLightTypeOmni;// 设置类型
 light.color = [UIColor yellowColor]; // 设置光的颜色
 
 SCNNode *lightNode = [SCNNode node];
 lightNode.position = SCNVector3Make(0, 0, 100); // 设置光源节点的位置
 lightNode.light  = light;
 [self.gameView.scene.rootNode addChildNode:lightNode]; // 添加到场景中去
 
 运行结果:  Scenekit_03.gif
 
 我们的点光源的位置为(0,0,100),我们把位置改为(0,100,100),看一下效果，对比一下，你就掌握了这种光的特点
 
 改变位置后
 
 点光源的特显，你应该明白了！我们继续！
 
 第八步.只添加一个平行方向光源
 
 我们一开始说了这种光源的特点:只有方向，没有位置,我们验证一下
 
 SCNLight *light = [SCNLight light];// 创建光对象
 light.type = SCNLightTypeDirectional;// 设置类型
 light.color = [UIColor yellowColor]; // 设置光的颜色
 
 SCNNode *lightNode = [SCNNode node];
 lightNode.position = SCNVector3Make(0, 10, -100); // 设置光源节点的位置
 lightNode.light  = light;
 [self.gameView.scene.rootNode addChildNode:lightNode]; // 添加到场景中去
 
 位置为(0,0,-100)运行结果 Scenekit_03.gif
 
 下面我们把它的位置放在(1000,1000,1000) 看一下结果
 
 位置在(1000,1000,1000)
 
 一点变化也没有,接着下面我们改变一下照射方向,这种光的默认方向为z轴负方向，我们把它设置成Y轴负方向
 
 lightNode.rotation = SCNVector4Make(1, 0, 0, -M_PI/2.0);
 
 看一下运行结果
 
 光照方向Y轴负方向
 
 我相信你已经明白了这种光的特点.
 
 第九步.添加聚焦光源
 
 SCNLight *light = [SCNLight light];// 创建光对象
 light.type = SCNLightTypeSpot;// 设置类型
 light.color = [UIColor yellowColor]; // 设置光的颜色
 light.castsShadow = TRUE;// 捕捉阴影
 SCNNode *lightNode = [SCNNode node];
 lightNode.position = SCNVector3Make(0, 0, -9); // 设置光源节点的位置
 lightNode.light  = light;
 [self.gameView.scene.rootNode addChildNode:lightNode]; // 添加到场景中去
 
 运行结果:
 
 聚焦光源
 
 我们试着使用一下照射范围的属性,让它只照射到球
 
 SCNLight *light = [SCNLight light];// 创建光对象
 light.type = SCNLightTypeSpot;// 设置类型
 light.color = [UIColor yellowColor]; // 设置光的颜色
 light.castsShadow = TRUE;// 捕捉阴影
 
 light.zFar = 10; // 设置它最远能照射单位10 的地方,也就是说只能照到 球体的位置
 SCNNode *lightNode = [SCNNode node];
 lightNode.position = SCNVector3Make(0, 0, 0); // 设置光源节点的位置
 lightNode.light  = light;
 [self.gameView.scene.rootNode addChildNode:lightNode]; // 添加到场景中去
 
 运行: 让学习成为一种习惯
 
 有的朋友要问了，那怎么还能看见后面的立方体的，这是因为物体都存在漫反射，这个属于自然现象，你用手电筒可以去试试！那如何才能让它看不见后面的立方体呢？设置光的发射角度，上代码:
 
 light.spotOuterAngle = 2;
 
 */

@end
