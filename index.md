---
layout: default
---
### Features
- The popular "New input system" by [Yoshubs](https://gamebanana.com/members/1908070)
- Accuracy System with decimals.
- Built-in miss counter.
- Dialogues with no coding whatsoever
- Stages with no coding whatsoever
- Custom songs with no coding whatsoever
- Custom charts with no coding whatsoever
- Custom characters with no coding whatsoever
- Downscroll
- And much, much more!

## PLEASE NOTE:
To Build Mag Engine, You Should Have Minor Knowledge Of The Command Line/cmd, If You Don't, Do Not Worry Because ninjamuffin99 Is Here To Save The Day, He Made A Guide: https://ninjamuffin99.newgrounds.com/news/post/1090480

## Dependencies For Compiling
First, Install Haxe 4.1.5. PLEASE use 4.1.5 instead of the latest version because the latest version is broken with [git](https://git-scm.com/downloads), which you will need to build Mag Engine.
Second, AFTER installing Haxe, [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) (Haxe's 2D Game Engine).
Third, Install git.
FOR WINDOWS: Go to [The Git Website](https://git-scm.com/downloads) and install the program from there.
FOR LINUX: install the git package in cmd: | sudo apt install git (ubuntu) | - and - | sudo pacman -S git (arch), etc. |


# Building The Engine (If You're Using The Source Code)
First, Type These Commands In Order In The Command Line
haxelib install lime
haxelib run lime setup
haxelib install flixel
haxelib install flixel-tools
haxelib run flixel setup
haxelib install openfl
haxelib run openfl setup
haxelib install newgrounds
haxelib install hscript
haxelib install thx.color 0.19.1 

### FOR WINDOWS
You'll need to install Visual Studio 2019. While installing it, don’t click on any of the options to install workloads or anything. Go to the individual components tab and install the following:

- MSVC v142 - VS 2019 C++ x64/x86 build tools
- Windows SDK (10.0.17763.0)

This will install around 4 GB of components, but it's required for Windows.


### FOR macOS
(I Know Nothing About Build To Mac So This Is Kade's Tutorial)

If you are running macOS, you’ll need to install Xcode. You can download it from the macOS App Store or from the [Xcode website](https://developer.apple.com/xcode/).

If you get an error telling you that you need a newer macOS version, you need to download an older version of Xcode from the More Software Downloads section of the Apple Developer website.


## Cloning The Mag Engine Repository

Since you already installed git in a previous step, you will use it to clone mag engine's repository.

Type "cd" to where you want to store the source code (eg. C:\Users\username\Desktop or ~/Desktop)
Type "git clone https://github.com/magnumsrtisswag/MagEngine-Public-Main.git"
Type "cd" into the source code: "cd MagEngine-Public-Main"

# BUILDING THE GAME/.EXE FILE

Run lime build "target", replace "target" with the platform you want to build to (windows, mac, linux, html5) (eg. lime build windows)
The build will be in "Mag-Engine-Public-Main/export/release/"target"/bin, with <target> being the target you built to in the previous step. (eg. Mag-Engine-Public-Main/export/release/windows/bin)
Incase you added the -debug flag the files will be inside Kade-Engine/export/debug/<target>/bin.
If you are planning on making your mod public, though, you should only release the "release" version, NOT the "debug" version.
Only the bin folder is necessary to run the game. The other ones in export/release/"target" aren't.
  
![Image](logo.png)
