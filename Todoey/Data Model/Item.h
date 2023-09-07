//
//  Item.h
//  Todoey
//
//  Created by REVE Systems on 7/9/23.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject <NSSecureCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL done;
- (instancetype)initWithTitle:(NSString *)title done:(BOOL)done;

@end

