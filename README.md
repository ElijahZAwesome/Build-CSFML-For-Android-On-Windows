# Build CSFML For Android On Windows
Batch scripts to build CSFML for Android, using the latest Android NDK

I made this to attempt to get SFML.NET working on Android.

# Requirements

Successfully building SFML requires that you have the following in your `PATH`:
* `cmake` (minimum version is **3.7.2**)
* `git`
* the directory where MinGW is installed (for example, `C:\Program Files\mingw32\bin`). You can check this by trying to run `mingw32-make` in CMD.

# How to use it

### ● If you have NDK installed:

Run `build-csfml.bat` followed by the absolute path to your NDK. For example, if your NDK is located at D:\NVPACK\android-ndk-r19, then you have to run `build-sfml.bat D:\NVPACK\android-ndk-r19`.
        
### ● If you don't have NDK installed:

You can install the newest version before building SFML, by executing `download-ndk-and-build-sfml.bat`. You can also specify where to install ndk, by providing an absolute path to the script. For example, if you want to install it in D:\Android, then you should run `download-ndk-and-build-sfml.bat D:\Android`. After downloading the NDK, this script will also run `build-csfml.bat` and thus build CSFML.

## Created scripts

The following scripts are created in ./SFML/build and ./CSFML/build and its subdirectories. They are also run by `build-csfml.bat` when it builds SFML for the first time. You can use them to rebuild SFML in case you modify something in it.

#### ● `rebuild-all.bat`: 
Rebuilds SFML for all ABIs.

#### ● `rebuild.bat` (in each ABI's directory): 
Rebuilds SFML/CSFML for the ABI corrisponding to script's directory.


