# FacefARt

![FacefARt Icon](https://raw.githubusercontent.com/hungtruong/FacefARt/master/FacefARt/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60%403x.png)

FacefARt is an app for the iPhone X that demonstrates the potential of the TrueDepth front-facing camera and ARKit to make the user's face fart when they open their mouth.

## Getting Started

A passion for fart apps is the only thing you need to get started.

### Prerequisites

I guess you'll also need an iPhone X and Xcode 9, and the ability to load a debug version of the app onto the device.

## How it works

The FacefARt app works by beginning an ARKit session, running the ARSCNView's session with a ARFaceTrackingConfiguration config. The main view controller is set as the ARSCNView's delegate, which calls the `renderer(_:didUpdate:for:)` method, passing along an `ARFaceAnchor` which contains information about the various anchor points on the user's face.

We only care about the `ARFaceAnchor.BlendShapeLocation.mouthClose` value which gives us the "openness" of the user's mouth. When the user opens their mouth, we start playing a fart sound. When we get an update with the `mouthClose` value such that we detect the user has closed their mouth, we stop the fart sound. It's a really long fart sound so if you leave your mouth open it'll fart for a while.

## Video Demo

[![FacefARt Demo Video](http://img.youtube.com/vi/nAsaInywFn0/maxresdefault.jpg)](https://youtu.be/nAsaInywFn0 "FacefARt")


## Further Reading

* [Creating Face-Based AR Experiences](https://developer.apple.com/documentation/arkit/creating_face_based_ar_experiences) - Apple's sample code on how to use the ARKit Face stuff.

## Authors

* **Hung Truong** - [hungtruong](https://github.com/hungtruong)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Thanks to Apple for not canceling my developer license
* Also thanks to Apple for providing some really good sample code
