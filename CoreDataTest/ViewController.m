//
//  ViewController.m
//  CoreDataTest
//
//  Created by pengpeng yan on 16/3/15.
//  Copyright © 2016年 peng yan. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Inporuty.h"
#import "Inporuty+CoreDataProperties.h"

@interface ViewController ()
@property(nonatomic,strong)NSManagedObjectContext *context;//上下文
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建数据库
    [self setupContext];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 50);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"添加信息" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:button];
    
    UIButton * button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(100, 180, 100, 50);
    button2.backgroundColor=[UIColor orangeColor];
    [button2 setTitle:@"读取信息" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(readClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton * button3=[UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame=CGRectMake(100, 260, 100, 50);
    button3.backgroundColor=[UIColor orangeColor];
    [button3 setTitle:@"删除信息" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton * button4=[UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame=CGRectMake(100, 340, 100, 50);
    button4.backgroundColor=[UIColor orangeColor];
    [button4 setTitle:@"更新信息" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(updateClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton * button5=[UIButton buttonWithType:UIButtonTypeCustom];
    button5.frame=CGRectMake(100, 420, 100, 50);
    button5.backgroundColor=[UIColor orangeColor];
    [button5 setTitle:@"模糊查询" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(linkSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    

    
}



- (void)setupContext{
   //1.创建数据库，关联数据，模型文件   NSPrivateQueueConcurrencyType这个方法创建的是多线程的上下文
         //    [self.context performBlock:^{ //异步方法
         //        //要执行的读取操作
         //        //线程安全用这个方法操作
         //    }]
    
        //    [self.context performBlockAndWait:^{ //同步方法
        //        <#code#>
        //    }]
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    //2.关联模型文件
    //穿一个nil会把所有的bundle的模型文件都关联起来
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];

    //3.持久化数据存储
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //存储数据库的名字
    NSError * error = nil;
   
    //获取docment目录
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //数据库保存的路径
    NSString *sqlite = [doc stringByAppendingPathComponent:@"company.sqilte"];
    
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlite] options:nil error:&error];
    
    
    context.persistentStoreCoordinator = store;
    self.context = context;
  
}

//添加信息
- (void)addClick:(UIButton *)btn{
    
//    [self.context performBlock:^{
//        NSLog(@"%@=====",[NSThread currentThread]);    //number = 2,在子线程上处理CRUD
//    }];
 
//   NSLog(@"%@=====",[NSThread currentThread]);         //number = 1  主线程上处理

    Inporuty *p1 = [NSEntityDescription insertNewObjectForEntityForName:@"Inporuty" inManagedObjectContext:self.context];
    Inporuty *p2 = [NSEntityDescription insertNewObjectForEntityForName:@"Inporuty" inManagedObjectContext:self.context];
    Inporuty *p3 = [NSEntityDescription insertNewObjectForEntityForName:@"Inporuty" inManagedObjectContext:self.context];
    NSError * error = nil;
    p1.name = @"小强";
    p1.age = @30;
    p1.height = @171;
    
    p2.name = @"大华";
    p2.age = @28;
    p2.height = @165;
    
    p3.name = @"小明";
    p3.age = @28;
    p3.height = @175;


    //通过上下文保存数据
    if (!error) {
        [self.context save:&error];
        NSLog(@"保存成功");
    }else{
        NSLog(@"保存失败");

    }
}

//读取信息
- (void)readClick:(UIButton *)btn{
  //1创建一个读取请求对象
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Inporuty"];
  
  //2谓词查找
  //NSPredicate *search = [NSPredicate predicateWithFormat:@"name=%@  AND height > %@",@"小强",@(170)];
    NSPredicate *search = [NSPredicate predicateWithFormat:@"height > %@",@(160)];
    request.predicate = search;
    
  //3.上下文查找
    NSError *error = nil;
    NSArray *arr = [self.context executeFetchRequest:request error:&error];
    
    if (!error) {
        for (Inporuty *p in arr) {
            NSLog(@"p==%@===%@===%@",p.name,p.age,p.height);
        }
    }else{
        NSLog(@"%@",error);
    }
    
//    [self.context performBlock:^{
//        //要执行的读取操作
//        //线程安全用这个方法操作
//    }]
    
}

//删除信息
- (void)deleteClick:(UIButton *)btn{
   //1创建一个读取请求对象
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Inporuty"];
    
   //2过滤查询//->根据具体情况
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",@"小强"];
    request.predicate = predicate;
    
    //3查找到一个数组
    NSError * error = nil;
    NSArray *array = [self.context executeFetchRequest:request error:&error];
    
    //4遍历删除
    if (!error) {
        for (Inporuty *p in array) {
            [self.context deleteObject:p];
             NSLog(@"%@",array);
        }
    }else{
        NSLog(@"%@",error);
    }
    //5同步数据库
    //所有操作暂时都是再内存里面，如果需要保存到数据库 需要使用save
    [self.context save:&error];
   
}

//更改信息
- (void)updateClick:(UIButton *)btn{
    //1创建一个读取请求对象
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Inporuty"];
    
    //2过滤查询//->根据具体情况
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",@"大华"];
    request.predicate = predicate;
    
    //3查找到一个数组
    NSError * error = nil;
    NSArray *array = [self.context executeFetchRequest:request error:&error];
    
    //更新数据
    if (array.count == 1) {
        Inporuty *p = array[0];
        p.name = @"萌萌";
        NSLog(@"%@--%@--%@",p.name,p.age,p.height);
    }
    
    //保存数据
    [self.context save:nil];
    
    NSLog(@"%@",array);

}

#pragma amrk - 模糊查询
-(void)linkSearchClick:(UIButton *)btn{
    
    //1.创建一个请求对象
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"Inporuty"];
    //过滤查询//->查询以萌开头的 BEGINSWITH固定写法
    //NSPredicate * cade = [NSPredicate predicateWithFormat:@"name BEGINSWITH %@",@"萌"];
    
    //查询以大厦结尾的 ENDSWITH固定写法
    //NSPredicate * cade = [NSPredicate predicateWithFormat:@"name ENDSWITH %@",@"大厦"];
    
    //名字包含 ** CONTAINS固定写法
    NSPredicate * cade = [NSPredicate predicateWithFormat:@"name CONTAINS %@",@"小"];
    
    request.predicate = cade;
    
    NSError * errer = nil;
    NSArray * array = [self.context executeFetchRequest:request error:&errer];
    
    if (!errer) {
        for (Inporuty  * emp in  array) {
            NSLog(@"emp==%@===%@===%@",emp.name,emp.age,emp.height);
        }
    }else{
        NSLog(@"%@",errer);
    }
    
    
}















@end
