//
//  ViewController.m
//  联系人排序
//
//  Created by 叶长生 on 2018/12/20.
//  Copyright © 2018 Hoa. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "TableViewCell.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

static NSString * identifiler = @"Cell";

@implementation ViewController
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *_sortedArray;
    UILocalizedIndexedCollation *_collation;
    NSMutableArray<Person *> * _contants;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置数据源
    NSArray *firstNameArray = @[@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",@"郭",@"松",@"宋",@"长",@"大",@"小"];
    NSArray *sortArray      = @[@"A",@"B",@"Z",@"C",@"B",@"S",@"Z",@"B",@"D",@"F",@"S",@"H",@"B",@"R"];
    NSMutableArray *tempArray = [NSMutableArray array];

    int j = 3;
    while (j > 0) {
        for (int i=0; i<firstNameArray.count; i++) {
            Person *p = [Person new];
            p.name = [NSString stringWithFormat:@"%@",firstNameArray[i]];
            p.sort = [NSString stringWithFormat:@"%@",sortArray[i]];
            [tempArray addObject:p];
        }
        j--;
    }
   
    
    //初始化UILocalizedIndexedCollation
    _collation = [UILocalizedIndexedCollation currentCollation];
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[_collation sectionTitles] count];
    //初始化一个数组_sortedArray用来存放最终的数据
    _sortedArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    //初始化27个空数组加入_sortedArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [_sortedArray addObject:array];
    }
    //将每个人按sort分到某个section下
    for (Person *temp in tempArray) {
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [_collation sectionForObject:temp collationStringSelector:@selector(sort)];
        NSMutableArray *sectionNames = _sortedArray[sectionNumber];
        [sectionNames addObject:temp];
    }
    
    //对每个section中的数组按照sort属性排序
    for (int index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = _sortedArray[index];
        NSArray *sortedPersonArrayForSection = [_collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(sort)];
        _sortedArray[index] = sortedPersonArrayForSection;
    }
    
    //section title
    NSMutableArray * sectionTitleArray = [NSMutableArray array];
    NSMutableArray *tempArr = [NSMutableArray array];
    [_sortedArray enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (array.count == 0) {
            [tempArr addObject:array];
        }else{
            [sectionTitleArray addObject:[self->_collation sectionTitles][idx]];
        }
    }];
    [_sortedArray removeObjectsInArray:tempArr];
    
    NSLog(@"%@", _sortedArray);
    
    [_tableView reloadData];
}
# pragma mark - UITableView Delegate datasources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sortedArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_sortedArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiler];
    Person *contact = _sortedArray[indexPath.section][indexPath.row];
    cell.displayTitle.text = contact.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([_sortedArray[section] count]) {
        return _collation.sectionTitles[section];
    } else {
        return nil;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _collation.sectionTitles;// 显示26个字母 + #
}

@end
