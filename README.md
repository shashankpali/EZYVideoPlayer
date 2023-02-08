# EZYVideoPlayer

![Video Player](https://user-images.githubusercontent.com/11850361/203596236-e4f2b348-7e21-4509-a20a-4e1c7df8de67.png)

[![CI Status](https://img.shields.io/travis/shashankpali/EZYVideoPlayer.svg?style=flat)](https://travis-ci.org/shashankpali/EZYVideoPlayer)
[![Version](https://img.shields.io/cocoapods/v/EZYVideoPlayer.svg?style=flat)](https://cocoapods.org/pods/EZYVideoPlayer)
[![License](https://img.shields.io/cocoapods/l/EZYVideoPlayer.svg?style=flat)](https://cocoapods.org/pods/EZYVideoPlayer)
[![Platform](https://img.shields.io/cocoapods/p/EZYVideoPlayer.svg?style=flat)](https://cocoapods.org/pods/EZYVideoPlayer)

`EZYVideoPlayer` will do all the heavy lifting that we required to create the `HLS` video player. It has all the basic and advanced functionality that a modern video player has. Just drag and drop `UIView` and inhirite it from `EZYVideoPlayer` this is all that we need to do. The `EZYVideoPlayer` is made up with `core components` and `Layers` hence it is high in performance.
The simplicity of `EZYVideoPlayer` make it the UI elegant and clear to understood by users.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Pod Installation

EZYVideoPlayer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EZYVideoPlayer'
```

## Direct Installation

Download [.zip file](https://github.com/shashankpali/EZYVideoPlayer/archive/refs/heads/main.zip) and extract it. There you will find the `EZYVideoPlayer` folder open it and copy `Classes` to your respective project.

## Integration Methods

### Storyboard/Xib

Just follow these simple steps and create a gradient inside your xib or storyboard!


#### Initial Step (Use this step if downloaded by pod)

###### while assigning EZYVideoPlayer to UIView on StoryBoard/Xib don't forget to select module 

|             Step              |                   Description                     |
|-------------------------------|---------------------------------------------------|
|<img width="241" alt="Screenshot 2022-11-23 at 7 54 05 PM" src="https://user-images.githubusercontent.com/11850361/203571390-e2ee65c3-82b6-4893-b370-c1b642fb484d.png">              |                                                   |
|<img width="241" alt="Screenshot 2022-11-23 at 7 53 05 PM" src="https://user-images.githubusercontent.com/11850361/203571741-c35c1bde-d8f3-4569-ac00-63a1db615f68.png">              | It will reflect warning if module is not selected.|

#### Final Step - Add Video URL

|             Step              |                         Description                                |
|-------------------------------|--------------------------------------------------------------------|
|<img width="251" alt="Screenshot 2022-11-23 at 8 01 40 PM" src="https://user-images.githubusercontent.com/11850361/203573190-632e5f2d-38df-4923-9a78-7c107526a880.png">              |                                                                    |
|<img width="251" alt="Screenshot 2022-11-23 at 8 01 59 PM" src="https://user-images.githubusercontent.com/11850361/203573281-a12c4447-4a27-4ee1-92e1-b7b649fa1e74.png">              | You can add any video url for the example purpose I used this one. |

That's it. This is all we need to do...!!!

### Result
![res](https://user-images.githubusercontent.com/11850361/203582368-0cd2c369-3408-4e47-b859-9364ffbc030d.png)


## Author

Shashank Pali

## License

EZYVideoPlayer is available under the MIT license. See the LICENSE file for more info.
