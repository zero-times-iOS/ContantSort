//
//  ViewController.m
//  联系人排序
//
//  Created by 叶长生 on 2018/12/20.
//  Copyright © 2018 Hoa. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
@interface ViewController ()
{
    NSArray<NSDictionary *> * _allDatas;
    NSMutableArray *_sortedArray;
    UILocalizedIndexedCollation *_collation;
    
    NSMutableArray<Person *> * _contants;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置数据源
    NSArray *firstNameArray = @[@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",@"郭",@"松",@"宋",@"长",@"大",@"小"];
    NSArray *sortArray      = @[@"A",@"B",@"Z",@"C",@"B",@"S",@"Z",@"B",@"D",@"F",@"S",@"H",@"B",@"R"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<firstNameArray.count; i++) {
        Person *p = [Person new];
        p.name = [NSString stringWithFormat:@"%@",firstNameArray[i]];
        p.sort = [NSString stringWithFormat:@"%@",sortArray[i]];
        [tempArray addObject:p];
    }
    
    //初始化UILocalizedIndexedCollation
    _collation = [UILocalizedIndexedCollation currentCollation];
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[_collation sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    //将每个人按name分到某个section下
    for (Person *temp in tempArray) {
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [_collation sectionForObject:temp collationStringSelector:@selector(sort)];
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:temp];
    }
    
    //对每个section中的数组按照name属性排序
    for (int index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [_collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(sort)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    //section title
    NSMutableArray * sectionTitleArray = [NSMutableArray array];
    NSMutableArray *tempArr = [NSMutableArray array];
    [newSectionsArray enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (array.count == 0) {
            [tempArr addObject:array];
        }else{
            [sectionTitleArray addObject:[self->_collation sectionTitles][idx]];
        }
    }];
    [newSectionsArray removeObjectsInArray:tempArr];
    
    NSLog(@"%@", newSectionsArray);
}


@end
