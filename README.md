AppStoreWindow
==============

Implements an App Store window look-a-like. This means we have a window without title and
a toolbar in that window which uses the extra space from title for its toolbaritems.

This implementation is lite weigh and builds on top of the NSToolbar classes.
To define a appstore window you can use the xcode uibuilder. Just set the class
of the window to UnifiedToolbarWindow and the class of the toolbaritems to
UnifiedToolbarItem (you can use the default toolbarItems objects to place icons without text
on the normal locations).


You can check the usage of the classes by opening this project.
