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
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 240, 40)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor colorWithRed:0.322 green:0.314 blue:0.345 alpha:1.0];
        self.titleLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:15];
        [self addSubview:self.titleLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, 30 , 70, 30)];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:18];
        self.priceLabel.textColor = [UIColor colorWithRed:0.608 green:0.518 blue:0.953 alpha:1.0];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.priceLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 200, 25)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textColor = [UIColor colorWithRed:0.322 green:0.314 blue:0.345 alpha:1.0];
        self.dateLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:11];
        [self addSubview:self.dateLabel];
        
        self.productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 66, 66)];
        [self addSubview:self.productImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
