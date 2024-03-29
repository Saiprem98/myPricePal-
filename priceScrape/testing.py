import requests
from bs4 import BeautifulSoup as soup
import json
import sys

groceryUrlBeginning = "https://www.mygrocerydeals.com/deals?utf8=%E2%9C%93&authenticity_token=KFo1qPeErMj0RspD%2F8AhWJlc9BChi8x8L6irKF9pfCDTL4%2B7TkK0EgkeC85l933qffsBAuiYEHhOFgqQUy0nJg%3D%3D&remove%5B%5D=chains&remove%5B%5D=categories&remove%5B%5D=collection&remove%5B%5D=collection_id&q="
groceryUrlEnd = "&supplied_location=93107&latitude=34.42&longitude=-119.69999999999999"
walmartUrlBeginning = "https://www.walmart.com/search/?cat_id=0&query="
targetUrlBeginning = "https://www.target.com/s?searchTerm="
amazonUrlBeginning = "https://www.amazon.com/s?k="


# product = input("Please enter the product: ")
product = sys.argv[1]
fileName = product.title().replace(" ", "") + ".json"
product = product.replace(" ", "+").replace(",","").title()

# upci = input("UPCI: ")


# ############################################################Searches mygrocerydeals.com############################################################


url = groceryUrlBeginning + product + groceryUrlEnd     #page URL

uclient = requests.get(url)                     #opening connection to website
# pageHTMl = uclient.read()                #reading HTML
# uclient.close()
content = soup(uclient.text, "html.parser")

#grabs each product
itemContainers = content.findAll("div", {"data-type":"special"})

productName = []
size = []
price = []
dealEnd = []
storeName = []
pictureUrl = []

count = 0                                                                             #counter for going row by row
for container in itemContainers:
    productNameContainer = container.findAll("p", {"class":"deal-productname"})        #Finding product name
    productName.append(productNameContainer[0].text)
    
    sizeContainer = container.findAll("div", {"class":"uom"})                        #Finding size/count of product
    size.append(sizeContainer[0].text.replace(".", "|point|"))
    
    priceContainer = container.findAll("span", {"class":"pricetag"})                #Finding Price
    price.append(priceContainer[0].text.replace(".", "|point|").replace("$", "|dollars|"))
    
    dealEndContainer = container.findAll("div", {"class":"expirydate"})                #Finding deal end date
    dealEnd.append(dealEndContainer[0].text.replace("/", "-"))
    
    storeNameContainer = container.findAll("p", {"class":"deal-storename"})            #Finding store of sale
    storeName.append(storeNameContainer[0].text)
    
    pictureUrlContainer = container.findAll("img", {"class":"deal-productimg"})
    pictureUrl.append(pictureUrlContainer[0]['src'].replace("$", "|dollars|").replace("#", "|hash|").replace("/", "|slash|").replace(".", "|point|"))
    
    count+=1


############################################################Searches walmart.com############################################################

url = walmartUrlBeginning + product     #page URL
print(url)

# uclient = ureq(url)                     #opening connection to website  
# pageHTMl = uclient.read()               #reading HTML
# uclient.close()
# content = soup(pageHTMl)



ret = requests.get(url)

page_soup = soup(ret.text, 'html.parser')
data = page_soup.select("[type='application/json']")[2]
oJson = json.loads(data.text)['searchContent']['preso']['items'] #walmart loads item info as JSON so have to parse through it like that

for item in oJson:
    productName.append(item['title'].replace("<mark>", "").replace("</mark>", ""))

    if('offerPrice' in item['primaryOffer']):
        price.append(str(item['primaryOffer']['offerPrice']).replace(".", "|point|").replace("$", "|dollars|"))
    elif('minPrice' in item['primaryOffer']):
        price.append(str(item['primaryOffer']['minPrice']).replace(".", "|point|").replace("$", "|dollars|"))

    storeName.append("Walmart")

    pictureUrl.append(item['imageUrl'].replace("$", "|dollars|").replace("#", "|hash|").replace("/", "|slash|").replace(".", "|point|"))

    size.append("NA")

    dealEnd.append("NA")

    product = product.replace("+"," ")
data = { product: {
    "Product name": productName,
    "Size or Count": size,
    "Price": price,
    "Deal End": dealEnd,
    "Store Name": storeName,
    "Picture URL": pictureUrl
}
}

with open(fileName, 'w') as f:
    json.dump(data, f, indent = 2)


########################################################Searches Target.com#################################################################

#url = targetUrlBeginning + product
#
#ret = requests.get(url)
#
#page_soup = soup(ret.text, 'html.parser')
#
#print(page_soup)
##data = page_soup.select("[type='application/json']")[2]
##oJson = json.loads(data.text)['searchContent']['preso']['items'] #walmart loads item info as JSON so have to parse through it like that
#
