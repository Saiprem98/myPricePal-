//
//  Analytics.hpp
//  MyPricePal
//
//  Created by Sai Kathika on 5/24/19.
//  Copyright © 2019 CS48. All rights reserved.
//

//#ifndef Analytics_hpp
#include <stdio.h>
#ifdef __cplusplus
extern "C" {
#endif
    float Data();
    void setData(double products_scanned, double items_inputed, double products_searched);
    void set_searched(double s);
    void set_scanned(double s);
    void set_added(double s);
    void update_products_searched();
    void update_products_scanned();
    void update_products_added();
    double return_products_scanned();
    double return_products_searched();
    double return_products_added();
    const char *getPersonName(void);
    void add_products(const char *s);
    void update_url();
    double return_url();
#ifdef __cplusplus
}
#endif /* TestData_hpp */
