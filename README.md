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

Usage
-----
iDOSBox will be available shortly in the App Store for free; in the meantime, it can be 'one click' built from Xcode by downloading the [source](https://github.com/matthewvilim/iDOSBox) from Github.

Apple requires all apps that run emulated code to include the executable bundled with the app; it follows that you can't add your own programs to iDOSBox from the App Store. You're encouraged to download the source, add your own programs as desired, and publish to the App Store.

Contributing
------------
* Developement is ongoing as new features are added and bugs are fixed; fork and pull the project to submit your own changes for review. Bug reports and feature requests are welcome too!
* All changes to DOSBox and SDL made for iOS are marked with the preprocessor macro `IDOSBOX`. Your own changes must use the macro too (e.g. `#ifdef IDOSBOX`) for logging and readability purposes as DOSBox and SDL will likely need to be updated at some point in the future when new versions are released.
* DOSBox source is located at `Source/DOSBox`; SDL source is located at `Source/SDL`; iDOSBox user interface classes are located in `Source/iDOSBox/UIKit`.
* iDOSBox is built as three static libraries, corresponding to the three source folders listed above. To use iDOSBox in your own project, drag the project into your own Xcode project and add the libraries as dependencies. Your `UIApplicationDelegate` should inherit from `SDLUikitAppDelegate`. Further details for interfacing with DOS are provided in comments in the demo project at `IDBDemo/Source`.
* iDOSBox is based on DOSBox 0.74 and SDL 1.2 for iOS. SDL 2 is not supported because it is not backwards compatible with DOSBox which uses SDL 1.2.

Screenshots
-----------
![iDOSBox iPhone screenshot](/Documentation/idosbox_iphone_keyboard.png)
![iPhone sample screenshot](/Documentation/idosbox_iphone_sample.png)
