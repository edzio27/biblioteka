//
//  ProductCell.m
//  TanieChlanie
//
//  Created by Edzio27 Edzio27 on 28.05.2013.
//  Copyright (c) 2013 Edzio27 Edzio27. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 240, 40)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor colorWithRed:0.322 green:0.314 blue:0.345 alpha:1.0];
        self.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:15];
        [self addSubview:self.titleLabel];
        
        self.authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30 , 280, 30)];
        self.authorLabel.backgroundColor = [UIColor clearColor];
        self.authorLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:18];
        self.authorLabel.textColor = [UIColor colorWithRed:0.608 green:0.518 blue:0.953 alpha:1.0];
        self.authorLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.authorLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 40, 200, 25)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textColor = [UIColor colorWithRed:0.322 green:0.314 blue:0.345 alpha:1.0];
        self.dateLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:11];
        [self addSubview:self.dateLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
