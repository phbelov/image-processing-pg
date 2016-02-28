import UIKit

let image = UIImage(named: "sample.png")!

// Process the Image!

// First of all a little bit of info on available filters:
// 1) Brightness
// 2) Contrast
// 3) Grayscale
// 4) ColorBalance
// Each one of the filters has an Intensity property which defines how strong the filter should be. The Intensity value can be positive as well as negative, it is of type Int.
// The ColorBalance class has a 'channel' property which is unique to it. The channel property is of type 'enum' – ColorChannel, which consits of 3 elements: .Red, .Green and .Blue. There's an example below for you to understand how it works in case you'll face some difficulties.
// There are also some predefined filters: contrast2x, contrast05x, brightness2x, greenify, redify, bluify.


// You can create a Filter by declaring a variable of the appropriate class like so:

var filter = Contrast(intensity: 50)

// Let's declare a variable of class RGBAImage

var imageRGBA = RGBAImage(image: image)!
GaussBlur(sourceImage: imageRGBA, radius: 3).myProcess()

// Filter class has a method called 'applyTo(image : RGBAImage)'. So you can apply a filter to image in this way:

filter.applyTo(imageRGBA)

// Where imageRGBA is an image of class RGBAImage.

// I've also extended the RGBAImage class by creating a method called applyFilter. This method can take a filter as an argument. For example:

imageRGBA.applyFilter(Contrast(intensity: 50)).toUIImage()

// You can apply multiple filters as well by calling applyFilter function more than once:

imageRGBA.applyFilter(Grayscale(intensity: 10)).applyFilter(ColorBalance(intensity: 75, channel: .Blue)).toUIImage()

//Next, I've created a class 'ImageProcessor' which is made for processing the images. There's a property called image inside the class. However, I made it optional. You can either set this property or not. Below you see that I create a constant called 'imgPrcssr' and assign an image by using an initializer.
var newImageRGBA = RGBAImage(image: image)!
let imgPrcssr = ImageProcessor(image: newImageRGBA)

// You can apply as many filters as you wish using ImageProcessor. Here I used it with predefined filters (greenify, redify, bluify) and with an instance of Contrast class:
imgPrcssr.process(greenify, redify, bluify, Contrast(intensity: -50))

// As I said earlier it is not necessary to set the 'image' property of the ImageProcessor class. The 'process' method can handle an image that you need to process, besides the filters you want to apply to it.

imgPrcssr.process(newImageRGBA, filters: greenify, Grayscale(intensity: 10))


