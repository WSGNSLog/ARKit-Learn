//
//  ViewController.m
//  ARKit-Learn04
//
//  Created by shiguang on 2018/2/27.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import <SceneKit/SceneKit.h>

@interface ViewController ()

@property (nonatomic,weak) SCNView *scnview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSCNView];
    [self createScene];
    
    
}
- (void)setupSCNView{
    
    SCNView *scnview = [[SCNView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    scnview.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    scnview.backgroundColor = [UIColor lightGrayColor];
    scnview.allowsCameraControl = true;
    [self.view addSubview:scnview];
    self.scnview = scnview;
    
}
- (void)createScene{
    
    SCNScene *scene = [SCNScene scene];
    self.scnview.scene = scene;
    // 创建节点，添加到scene的根节点上
    SCNNode *node = [SCNNode node];
    [scene.rootNode addChildNode:node];
    
    // 创建一个球体几何绑定到节点上去
    SCNSphere *sphere = [SCNSphere sphereWithRadius:0.5];
    node.geometry = sphere;
    
    //给节点添加节点
    // 创建子节点 给子节点添加几何形状
    SCNNode *childNode = [SCNNode node];
    //设置节点的位置
    childNode.position = SCNVector3Make(-0.5, 0, 1);
    //设置几何形状，我们选择立体字体
    SCNText *text = [SCNText textWithString:@"让学习成为一种习惯" extrusionDepth:0.03];
   //设置字体颜色
    text.firstMaterial.diffuse.contents = [UIColor cyanColor];
    //设置字体大小
    text.font = [UIFont systemFontOfSize:.15];
    //给节点绑定几何物体
    childNode.geometry = text;
    [node addChildNode:childNode];
    
}
/*

5-理解游戏场景和节点的概念

你必须知道的概念

概念图

场景

简单的说，就是把人物，地图，道具等放在一个空间里,组成一个大的环境,这个大的环境就被称为场景!

节点

在SceneKit 节点是个抽象的概念,节是个看不见,摸不到的东西，没有几何形状,但是它有位置，以及自身坐标系。通俗的讲，在场景中创建一个添加节点后,你就可以在这个节点上放我们游戏元素了，比如人物模型，灯光，摄像机等等! 节点上可以添加节点的,每个节点都有自身坐标系。如图，我们把节点2添加到节点1上去。

实战目标

1.掌握如何添加节点到场景中 2.给节点绑定几何物体 3.给节点添加节点

开始吧

第一步.创建工程

和创建普通工程没啥区别

让学习成为一种习惯

我们已经完成了创建工程的任务,有的人就问了,你不是要将SceneKit 游戏开发，怎么创建的是应用工程,往下看,就这么任性!

第二步，添加我们的游戏框架到我们的控制器ViewController中

添加游戏框架

到这里,准备工作已经全部做完,开始敲代码啦！

第三步:创建一个游戏引擎专属View视图(SCNView)

@property(nonatomic,strong)SCNView *gameView; // 设置一个引用属性

- (void)addSCNView{
    // 1.创建一个边长为300 的视图，放在屏幕中心
    self.gameView = [[SCNView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    self.gameView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    // 2.设置背景颜色为黑色
    self.gameView.backgroundColor = [UIColor blackColor];
    // 3.添加到父视图中去
    [self.view addSubview:self.gameView];
}

此刻运行一下程序结果如下图

运行结果

第四步.添加场景

-(void)createScene{
    SCNScene *scene = [SCNScene scene];
    self.gameView.scene = scene;
}

此时，如果你运行程序，就和上面的效果一样，没有变化，因为我们的场景中什么都没有。

第五步.添加节点

// 创建节点，添加到scene的根节点上
SCNNode *node = [SCNNode node];
[scene.rootNode addChildNode:node];

提示:

scene.rootNode 有些朋友很好奇，为什么Scene也有一个节点，上面说个，没有节点你没法放游戏元素上去，并且它有自身坐标系，这就是为什么scene也有一个根节点的原因。

此时你运行程序也和上面结果一样,因为节点没有几何形状!

第六步.给节点绑定一个几何形状的物体

// 创建一个球体几何绑定到节点上去
SCNSphere *sphere = [SCNSphere sphereWithRadius:0.5];
node.geometry = sphere;

运行一下

运行结果

此时我们已经完成了实战任务的1和2,继续加油!

第七步.给节点添加节点

// 创建子节点 给子节点添加几何形状
SCNNode *childNode = [SCNNode node];
// 设置节点的位置
childNode.position = SCNVector3Make(-0.5, 0, 1);
// 设置几何形状，我们选择立体字体
SCNText *text = [SCNText textWithString:@"让学习成为一种习惯" extrusionDepth:0.03];
// 设置字体颜色
text.firstMaterial.diffuse.contents = [UIColor redColor];
// 设置字体大小
text.font = [UIFont systemFontOfSize:0.15];
// 给几点绑定几何物体
childNode.geometry = text;
[node addChildNode:childNode];

友情提示:

extrusionDepth 字体的深度 firstMaterial.diffuse.contents 不知道没关系，后面会讲的,单词意思就可以理解.firstMaterial 第一个材质 diffuse 自身发散的contents内容，我们设置为red 也可以设置图片的!

我们用一键大招让你自由旋转物体

self.gameView.allowsCameraControl = true;

*/

@end
