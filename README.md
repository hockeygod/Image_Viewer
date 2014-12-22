Image_Viewer
============

Crunchy Roll Code Challenge: Image Viewer

Create an image viewer app:

* You can find a mockup of the app here: https://projects.invisionapp.com/share/XWNJ2I67
  * the app only needs to support iOS 7 on iPhone
* Retrieve the list of images from here: http://dl.dropbox.com/u/89445730/images.json
  * The data is formatted as a json-encoded string.
  * The data is an array of images.
  * Each image is represented as a dictionary with three elements:
    * “original” the url for the original image
    * “thumbnail” the url for a smaller version of the image
    * “caption” a short string describing the image.
  * The original and thumbnail images may have various aspect ratios and widths and heights.
* Display the list of thumbnails and captions in a tableView
  * Each cell should contain a thumbnail and its caption.
  * The image and caption should both be left aligned.
  * The image should be on the left, the caption on the right.
  * The thumbnail should be displayed as a square of reasonable size. Either the full width or
the full height of the image must be visible.
  * There should be reasonable padding among the image, caption, and cell boundaries.
* When you tap on a cell in the tableView, the image should load in the image view.
  * The image should be displayed at actual size, centered on the screen both vertically and
horizontally.
  * If the image is larger than the screen, allow the user to scroll.
  * If the image is smaller than the screen, scrolling should be disabled.
  * The user should not be able to scroll past the image boundaries.
  * When the user taps the screen, toggle the display of the status and navigation bar.
* The navigation bar on the image view should have a left and a right button
  * The left button should reveal the tableView
  * The right button should pop up and alertView that contains the caption
    * Do not show the right button if there is no caption