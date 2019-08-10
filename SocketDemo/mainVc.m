//
//  mainVc.m
//  SocketDemo
//
//  Created by 罗玉洁 on 2019/8/9.
//  Copyright © 2019 罗玉洁. All rights reserved.
//

#import "mainVc.h"

@interface mainVc ()
@property(nonatomic,strong)NSMutableArray *titleArray;
@end


@implementation mainVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"调试入口";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
   NSString *path= [[NSBundle mainBundle] pathForResource:@"titleArray"ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    if (data) {
        self.titleArray = [NSMutableArray arrayWithArray:data[@"tltleArray"]];
    }
    
}
#pragma mark - Getter/Setter
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray=[NSMutableArray array];
    }
    return _titleArray;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = self.titleArray[indexPath.row][@"title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = self.titleArray[indexPath.row];
    NSString *destination = [item objectForKey:@"destination"];
  
    if (destination) {
        UIViewController *myVc =  [[NSClassFromString(destination) alloc]init];
     
        if (myVc) {
        
              [self.navigationController pushViewController:myVc animated:YES];
        }
      
    }
    
}



@end
