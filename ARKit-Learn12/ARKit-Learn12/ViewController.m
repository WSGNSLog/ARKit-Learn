//
//  ViewController.m
//  ARKit-Learn12
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
    
    //创建场景资源对象
    SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:[[NSBundle mainBundle] URLForResource:@"skinning" withExtension:@"dae"] options:nil];
    //创建场景
    SCNView *scnView = [[SCNView alloc]initWithFrame:self.view.bounds];
    scnView.allowsCameraControl = true;
    scnView.backgroundColor = [UIColor blackColor];
    scnView.scene = [sceneSource sceneWithOptions:nil error:nil];
    //获取场景中的某种对象的标识数组
    //我们获取动画类的数组
    NSArray *animationIDs = [sceneSource identifiersOfEntriesWithClass:[CAAnimation class]];
    
    //把每个动画帧放到一个大数组中
    NSUInteger animationCount = [animationIDs count];
    NSMutableArray *longAnimations = [[NSMutableArray alloc]initWithCapacity:animationCount];
    CFTimeInterval maxDuration = 0;
    for (NSInteger index = 0; index<animationCount; index++) {
        CAAnimation *animation = [sceneSource entryWithIdentifier:animationIDs[index] withClass:[CAAnimation class]];
        if (animation) {
            maxDuration = MAX(maxDuration, animation.duration);
   
            [longAnimations addObject:animation];
        }
    }
    
    //创建一个动画组
    CAAnimationGroup *longAnimationsGroup = [[CAAnimationGroup alloc]init];
    longAnimationsGroup.animations = longAnimations;
    longAnimationsGroup.duration = maxDuration;
    
    
    //截取我们要的动画阶段比如(20~24秒)
    
    // 截取20秒之后的动画组
    CAAnimationGroup *idleAnimationGroup = [longAnimationsGroup copy];
    idleAnimationGroup.timeOffset = 20;
    
    // 创建一个重复执行这个动画的动画组
    CAAnimationGroup *lastAnimationGroup;
    lastAnimationGroup = [CAAnimationGroup animation];
    lastAnimationGroup.animations = @[idleAnimationGroup];
    lastAnimationGroup.duration = 24.71 - 20;
    lastAnimationGroup.repeatCount = 10000;
    lastAnimationGroup.autoreverses = YES;
    
    //然后将这个动画组添加到模型节点去就可以了
    SCNNode *scnNode= [scnView.scene.rootNode childNodeWithName:@"avatar_attach" recursively:YES];
    [scnNode addAnimation:lastAnimationGroup forKey:@"animation"];
    SCNNode *skeletonNode = [scnView.scene.rootNode childNodeWithName:@"skeleton" recursively:YES];
    
    [self visualizeBones:YES ofNode:skeletonNode inheritedScale:1];
    [self.view addSubview:scnView];
}

//  调用下面的方法给骨头添加一个小四方块
- (void)visualizeBones:(BOOL)show ofNode:(SCNNode *)node inheritedScale:(CGFloat)scale
{
    scale *= node.scale.x;
    if (show) {
        if (node.geometry == nil)
            node.geometry = [SCNBox boxWithWidth:6.0 / scale height:6.0 / scale length:6.0 / scale chamferRadius:0.5];
    }
    else {
        if ([node.geometry isKindOfClass:[SCNBox class]])
            node.geometry = nil;
    }
    
    for (SCNNode *child in node.childNodes)
        [self visualizeBones:show ofNode:child inheritedScale:scale];
}
/*
 15-骨骼动画
 
 当前有两种模型动画的方式：顶点动画和骨骼动画。顶点动画中，每帧动画其实就是模型特定姿态的一个“快照”。通过在帧之间插值的方法，引擎可以得到平滑的动画效果,在骨骼动画中，模型具有互相连接的“骨骼”组成的骨架结构，通过改变骨骼的朝向和位置来为模型生成动画。 骨骼动画比顶点动画要求更高的处理器性能，但同时它也具有更多的优点，骨骼动画可以更容易、更快捷地创建。不同的骨骼动画可以被结合到一起——比如，模型可以转动头部、射击并且同时也在走路。一些引擎可以实时操纵单个骨骼，这样就可以和环境更加准确地进行交互——模型可以俯身并向某个方向观察或射击，或者从地上的某个地方捡起一个东西。多数引擎支持顶点动画，但不是所有的引擎都支持骨骼动画。
 
 苹果官方
 
 骨骼动画是一种简化复杂几何形状的动画的技术,比如游戏中人的特征,动画骨架是一个简单的控制节点的层次结构,本身没有可见的几何对象,将骨头和几何对象进行结合,当你移动这个骨头控制的节点时允许SceneKit 去自动使几何对象变形。
 
 给张图理解一下
 
 让学习成为一种习惯
 
 相信你已经基本了解骨骼动画的含义了。
 
 接下来学习一个类的使用
 
 SCNKinner 能干什么?
 提供一些方法可以将节点的骨骼动画进行分离,你可以使用这个对象管理从Scene文件导入的骨骼动画与节点和几何对象之间动态关系。这个类在平时开发过程中,不怎么用的,大家了解一下即可!
 
 怎么使用骨骼动画？
 1.一般情况下,游戏设计师使用3D 工具创建一个皮肤模型,包含了骨骼的动画,保存在一个场景文件中,你从场景文件中导入这个骨骼模型,然后让他们运动起来.
 2.另外你也可以直接从场景文件中导入动画对象直接操作骨头节点
 3.您还可以单独创建一个自定义的几何和骨架数据的皮肤模型
 
 我们先找一个带骨骼的模型文件,分析一下它的结构

 
 我们先看一下完整的动画效果
 
 
 
 接下来我们做一个练习
 
 如何将一段完整的动画，分阶段执行,我们刚才看见了这段动画的时间为0~24秒左右。
 
 首先先介绍一个类(SCNSceneSource)
 
 主要用于管理场景文件的读取任务,也可以读取NSData对象哦!你懂了吧,如果这个模型,我们从网络传输的话,可能就需要使用这个类了。
 
 这个类暂时不详细讲解,后面我会补上,今天主要用到它的两个方法。
 
 N0.1
 
 - (NSArray<NSString *> *)identifiersOfEntriesWithClass:(Class)entryClass;
 
 作用:
 
 获取场景中包含的某一类对象的标识(数组),可以获取的类型有 SCNMaterial, SCNScene, SCNGeometry, SCNNode, CAAnimation, SCNLight, SCNCamera, SCNSkinner, SCNMorpher, NSImage
 
 NO.2
 
 - (nullable id)entryWithIdentifier:(NSString *)uid withClass:(Class)entryClass;
 
 作用:
 
 根据对象的ID 和对象的类型，获取对象本身
 
 NO.3
 
 + (nullable instancetype)sceneSourceWithURL:(NSURL *)url options:(nullable NSDictionary<NSString *, id> *)options;
 +
 
 作用:
 
 初始化方法
 
 NO.4
 
 - (nullable SCNScene *)sceneWithOptions:(nullable NSDictionary<NSString *, id> *)options error:(NSError **)error;
 
 作用:
 
 创建场景
 
 走进代码的世界
 1.创建工程(略)
 2.加载场景文件(前面讲了很多次了,你该会用了,这里就不赘述了)
 3.添加框架SceneKit/Scenekit.h
 4.创建场景资源对象
 
 SCNSceneSource *sceneSource = [SCNSceneSource sceneSourceWithURL:[[NSBundle mainBundle] URLForResource:@"skinning" withExtension:@"dae"] options:nil];
 
 5.创建场景
 
 scnView.scene  = [sceneSource sceneWithOptions:nil error:nil];
 
 6.获取场景中的某种对象的标识数组
 
 // 我们获取动画类的数组
 NSArray *animationIDs =  [sceneSource identifiersOfEntriesWithClass:[CAAnimation class]];
 
 7.把每个动画帧放到一个大数组中
 
 NSUInteger animationCount = [animationIDs count];
 NSMutableArray *longAnimations = [[NSMutableArray alloc] initWithCapacity:animationCount];
 CFTimeInterval maxDuration = 0;
 for (NSInteger index = 0; index < animationCount; index++) {
 CAAnimation *animation = [sceneSource entryWithIdentifier:animationIDs[index] withClass:[CAAnimation class]];
 if (animation) {
 maxDuration = MAX(maxDuration, animation.duration);
 [longAnimations addObject:animation];
 }
 }
 
 8.创建一个动画组
 
 CAAnimationGroup *longAnimationsGroup = [[CAAnimationGroup alloc] init];
 longAnimationsGroup.animations = longAnimations;
 longAnimationsGroup.duration = maxDuration;
 
 9.截取我们要的动画阶段比如(20~24秒)
 
 // 截取20秒之后的动画组
 CAAnimationGroup *idleAnimationGroup = [longAnimationsGroup copy];
 idleAnimationGroup.timeOffset = 20 ;
 // 创建一个重复执行这个动画的动画组
 CAAnimationGroup *lastAnimationGroup;
 lastAnimationGroup = [CAAnimationGroup animation];
 lastAnimationGroup.animations = @[idleAnimationGroup];
 lastAnimationGroup.duration = 24.71 -20;
 lastAnimationGroup.repeatCount = 10000;
 lastAnimationGroup.autoreverses = YES;
 
 10.然后将这个动画组添加到模型节点去就可以了
 
 SCNNode *cNode = [scnView.scene.rootNode childNodeWithName:@"avatar_attach" recursively:YES];
 [cNode addAnimation:lastAnimationGroup forKey:@"animation"];
 
 运行一下:
 
 帅爆了,有没有
 
 提示:
 
 模型中的骨头只是一个位置,没有大小和形状的,如果你想要查看骨头在什么位置怎么办呢?
 
 // 查找骨头节点
 _skeletonNode = [_characterNode childNodeWithName:@"skeleton" recursively:YES];
 //  调用下面的方法给骨头添加一个小四方块
 - (void)visualizeBones:(BOOL)show ofNode:(SCNNode *)node inheritedScale:(CGFloat)scale
 {
 scale *= node.scale.x;
 if (show) {
 if (node.geometry == nil)
 node.geometry = [SCNBox boxWithWidth:6.0 / scale height:6.0 / scale length:6.0 / scale chamferRadius:0.5];
 }
 else {
 if ([node.geometry isKindOfClass:[SCNBox class]])
 node.geometry = nil;
 }
 
 for (SCNNode *child in node.childNodes)
 [self visualizeBones:show ofNode:child inheritedScale:scale];
 }
 
 效果如下:
 
 让学习成为一种习惯
 
 SWIFT 版本
 为什么写这个,后续文章我想用Swift写,因为这门语言很优秀,请大家务必抓紧时间学习!
 
 第一步.获取资源
 
 let source = SCNSceneSource(url: file!, options: nil)
 
 第二步 获取动画标志数组
 
 let animationIDs = source?.identifiersOfEntries(withClass: CAAnimation.self)
 var animationArray:[CAAnimation] = []
 for id in animationIDs!{
 let animation = source?.entryWithIdentifier(id, withClass: CAAnimation.self)
 animationArray.append(animation!)
 }
 
 第三步 创建动画数组
 
 let animationGroup = CAAnimationGroup()
 animationGroup.animations = animationArray
 animationGroup.duration = 21.33
 animationGroup.repeatCount = 1000
 animationGroup.beginTime = 0
 
 第四步.添加动画组
 
 rightHetun.addAnimation(animationGroup, forKey: "an")
 
 什么玩意,难道我们做个游戏，光添加动画就这么复杂?
 
 其实不是的，实际开发过程中,我们不需要这么做的，处分你要对文件中的骨骼动画,进行时间上的调整，我们才会使用这种方法
 
 下面教大家一种更为简单的方式，添加骨骼动画，找一个带骨骼动画的文件
 
 let file = Bundle.main.url(forResource: "hetun", withExtension: "dae")
 let source = SCNSceneSource(url: file!, options: nil)
 let  hetun = try! source?.scene(options: nil).rootNode
 // 调整位置
 hetun?.scale = SCNVector3Make(0.01, 0.01, 0.01)
 hetun?.rotation = SCNVector4Make(0, 1, 0, -Float.pi/2)
 hetun?.position = SCNVector3Make(0, 0, 0)
 
 解释一下
 
 我们只要获取到文件的根节点,根节点中包含文件所有的元素,然后将rootnode添加到指定的位置即可,这样我们就完成了,是不是很简单呢？
 

 */

@end
