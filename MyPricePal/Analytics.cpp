//
//  Analytics.cpp
//  MyPricePal
//
//  Created by Sai Kathika on 5/24/19.
//  Copyright © 2019 CS48. All rights reserved.
//

#include "Analytics.hpp"

using namespace std;
//struct Data{
double products_scanned =0;
double products_added=0;
double products_searched=0 ;
double url = 0;
const char* product_name[100];
int count_product = 0;
void setData(double products_scanned1, double products_added2 , double products_searched3){
    
    products_scanned = products_scanned1;
    products_added =products_added2;
    products_searched=products_searched3;
    
}
void add_products(const char *s){
    product_name[count_product] = s;
    count_product++;
}
//const char *getPersonName(void){
//    char name[200];
//    snprintf(name, sizeof name, "%s %s", "Hello", "Swift!");
//    return strdup(name);
//}
void update_url(){
    url++;
}
void update_products_searched(){
    // call in swift and print updated stats
    products_searched++;
}
void update_products_scanned(){
    // call in swift and print updated stats
    products_scanned++;
}
void update_products_added(){
    // call in swift and print updated stats
    products_added++;
}

void set_searched(double s){
    products_searched = s;
}
void set_scanned(double s){
    products_scanned = s;
}
void set_added(double s){
    products_added = s;
}

double return_url(){
    return url;
}
// return the count back to print in swift
double return_products_searched(){
    
    return products_searched;
}
double return_products_scanned(){
    return products_scanned;
}
double return_products_added(){
    return products_added;
}

//};
float Data(){
    // store products scanned during session
    // items inputed to firebase database
    // store producst searched during session
    return 5.0;
}
