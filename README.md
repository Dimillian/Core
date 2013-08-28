iDOSBox
=======

iDOSBox is an iOS port of [DOSBox](http://www.dosbox.com/) written with [Simple DirectMedia Layer (SDL)](http://www.libsdl.org/)

![iDOSBox iPad screenshot](/Documentation/idosbox_ipad_keyboard.png)

Features
--------
* Runs old DOS programs, including classic games
* Supports full keyboard, joystick, graphic, audio, and file system emulation
* Controls optomized for iOS and touchscreens
* Supports both iPhone and iPad, including iOS 7

Using iDOSBox
-------------
iDOSBox will be available shortly in the App Store for free; in the meantime, it can be 'one click' built from Xcode by downloading the [source](https://github.com/matthewvilim/iDOSBox) from Github.

Apple requires all apps that run emulated code to include the executable bundled with the app; it follows that you can't add your own programs to iDOSBox from the App Store. You're encouraged to download the source, add your own programs as desired, and publish to the App Store.

Contributing
------------
* Developement is ongoing as new features are added and bugs are fixed; fork and pull the project to submit your own changes for review.
* All changes to DOSBox and SDL made made for iOS are marked with preprocessor macro `IDOSBOX`. All changes made to DOSBox or SDL source should use the macro (e.g. `#ifdef IDOSBOX`) to record changes for changing when new versions of DOSBox or SDL are released.
* DOSBox source is located at `Source/DOSBox`; SDL source is located at `Source/SDL`; iDOSBox user interface classes are located in `Source/iDOSBox/UIKit`
* iDOSBox is built as three static libraries, corresponding to the three source folders listed above. To use iDOSBox in your own project, drag and project into your Xcode project and add the libraries as dependencies. Your `UIApplicationDelegate` should inherit from `SDLUikitAppDelegate`. Further details for interfacing with the program are provided in comments in the appropriate files.
* iDOSBox is based on DOSBox 0.74 and SDL 1.2 for iOS.

Screenshots
-----------
![iDOSBox iPhone screenshot](/Documentation/idosbox_iphone_keyboard.png)
![iPhone sample screenshot](/Documentation/idosbox_iphone_sample.png)
