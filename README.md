Basic yelp
======


This is an iOS 7 demo app displaying search results from [Yelp API](http://www.yelp.com/developers/documentation). It is created as part of [CodePath](http://codepath.com/) course work. (June 17, 2014)
Time spent: approximately 25 hours

Features
---------
#### Required - Search results page
- [x] Table rows should be dynamic height according to the content height
- [x] Custom cells should have the proper Auto Layout constraints
- [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).

#### Required - Search results page
- [x] The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
- [x] The filters table should be organized into sections as in the mock.
- [x] You can use the default UISwitch for on/off states. Optional: implement a custom switch
- [x] Radius filter should expand as in the real Yelp app
- [x] Categories should show a subset of the full list with a "See All" row to expand
- [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.


#### Optional
- [ ] infinite scroll for restaurant results
- [ ] Implement map view of restaurant results
- [ ]  Implement the restaurant detail page.
 

Walkthrough
------------
![Video Walkthrough](anime.gif)

Credits
---------
* [Yelp API](http://www.yelp.com/developers/documentation)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [MBProgressHUD](https://github.com/matej/MBProgressHUD) for loading indicator
