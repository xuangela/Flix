# Project 2 - *Flix*

**Flix** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **16** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User sees an app icon on the home screen and a styled launch screen.
- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.
- [x] User sees an error message when there's a networking error.
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- [x] User can tap a poster in the collection view to see a detail screen of that movie
- [x] User can search for a movie.
- [ ] All images fade in as they are loading.
- [ ] User can view the large movie poster by tapping on a cell.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] Customize the selection effect of the cell.
- [ ] Customize the navigation bar.
- [ ] Customize the UI.

The following **additional** features are implemented:

- [x] trailer plays when after tapping on the poster in the detail screen of the movie
- [x] wifi reconnected alert after successfully connecting to internet after being disconnected

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Using the Reachability package to quickly check if there is a connection
2. A rating system for movies and recommendations based on the personal ratings as well as a to-watch list of movies
3. A way for user to select a default movie theater and display the screening times of any selected movie 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/tpakIO83SI.gif' title='Search bar' width='' alt='Video Walkthrough' />
<img src='http://g.recordit.co/BFcX89s9nL.gif' title='Trailer' width='' alt='Video Walkthrough' />
<img src='http://g.recordit.co/Dcaks08J5F.gif' title='Collection View' width='' alt='Video Walkthrough' />

GIF created with [Recordit](https://recordit.co/).

## Notes

Configuring new laptap and installing Cocoapods and Xcode hardware tools such as the Network Link Conditioner took a while. Since the number of view controllers increased by a lot as compared with Tipster, it took a while to get used to keeping track of how different views and view controllers are semantically linked. 

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [Reachability] (https://developer.apple.com/library/archive/samplecode/Reachability/Listings/Reachability_Reachability_m.html#//apple_ref/doc/uid/DTS40007324-Reachability_Reachability_m-DontLinkElementID_9) - network state monitoring

## License

    Copyright [2020] [Angela Xu]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
