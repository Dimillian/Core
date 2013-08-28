iDOSBox
=======

iDOSBox is an iOS port of [DOSBox](http://www.dosbox.com/) written with [Simple DirectMedia Layer (SDL)](http://www.libsdl.org/)

![iDOSBox iPad](/Documentation/idosbox_ipad_keyboard.png "iDOSBox iPad")

Features
--------
* Runs old DOS programs, including classic games
* Supports full keyboard, joystick, graphic, audio emulation all
* Controls optomized for iOS and touchscreens
* Supports both iPhone and iPad, including iOS 7

Using iDOSBox
-------------
iDOSBox will be available shortly in the App Store; in the meantime, it can be 'one click' built from Xcode buy downloading the source from [Github](https://github.com/matthewvilim/iDOSBox)

Contributing
------------
* Developement is ongoing as new features are added and bugs are fixed; fork and pull the project to submit your own changes for review.
* All changes to DOSBox and SDL made made for iOS are marked with preprocessor macro `IDOSBOX`. All changes made to DOSBox or SDL source should use the macro (e.g. `#ifdef IDOSBOX`) to record changes for changing when new versions of DOSBox or SDL are released.
* DOSBox source is located at `Source/DOSBox`; SDL source is located at `Source/SDL`; iDOSBox user interface classes are located in `Source/iDOSBox/UIKit`

iDOSBOXiOS DOSBox port based on DOSBox 0.74 and SDL 1.2

![iDOSBox iPhone](/Documentation/idosbox_iphone_keyboard.png "iDOSBox iPhone")
