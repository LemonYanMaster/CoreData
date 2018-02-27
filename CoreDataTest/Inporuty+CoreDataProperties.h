//
//  Inporuty+CoreDataProperties.h
//  CoreDataTest
//
//  Created by pengpeng yan on 16/3/15.
//  Copyright © 2016年 peng yan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Inporuty.h"

NS_ASSUME_NONNULL_BEGIN

@interface Inporuty (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
