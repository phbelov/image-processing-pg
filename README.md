# image-processing-pg
This is a playground with the demonstration of some image processing techniques, which include contrast, brightness, grayscale, RGB channel values adjustment.

 First of all a little bit of info on available filters:
 1) Brightness
 2) Contrast
 3) Grayscale
 4) ColorBalance
 Each one of the filters has an Intensity property which defines how strong the filter should be. The Intensity value can be positive as well as negative, it is of type Int.
 The ColorBalance class has a 'channel' property which is unique to it. The channel property is of type 'enum' – ColorChannel, which consits of 3 elements: .Red, .Green and .Blue. There's an example below for you to understand how it works in case you'll face some difficulties.
 There are also some predefined filters: contrast2x, contrast05x, brightness2x, greenify, redify, bluify.

 Each one of the filters has an Intensity property which defines how strong the filter should be. The Intensity value can be positive as well as negative, it is of type Int.

 The ColorBalance class has a 'channel' property which is unique to it. The channel property is of type 'enum' – ColorChannel, which consits of 3 elements: .Red, .Green and .Blue. There's an example below for you to understand how it works in case you'll face some difficulties.

 There are also some predefined filters: contrast2x, contrast05x, brightness2x, greenify, redify, bluify.
