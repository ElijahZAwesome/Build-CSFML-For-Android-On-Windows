@echo off
IF [%1] == [] (
	echo Please provide the path to your ndk
	pause
	exit /b
)

set ndk_path_valid=0
FOR %%i IN (%1) DO IF EXIST %%~si\NUL set ndk_path_valid=1

if [%ndk_path_valid%] NEQ [1] (
	echo The path you provided to your NDK is not a directory
	pause
	exit /b
)

pushd "%~dp0"

CALL check-requirements.bat
IF ERRORLEVEL 1 exit /b

set ndk_path=%1

IF [%2] == [] set install_path=%~dp0SFML
IF [%2] == [] set install_path_csfml=%~dp0CSFML
IF [%2] NEQ [] set install_path=%2
IF [%3] NEQ [] set install_path_csfml=%3
echo Downloading SFML to %install_path%

if not exist "%install_path%" md "%install_path%"
pushd "%install_path%"
git clone https://github.com/acsbendi/SFML

cd SFML
md build
cd build

REM 64 bit abis (arm64-v8a and x86_64) currently fail due to not finding OpenAL, so they are not included
set abis=x86 armeabi-v7a
(for %%a in (%abis%) do ( 
   md %%a
   echo @echo off> %%a\rebuild-temp.txt
   echo set current_abi=%%a>> %%a\rebuild-temp.txt
   echo set ndk_path=%ndk_path%>> %%a\rebuild-temp.txt
))

popd
(for %%a in (%abis%) do ( 
   type %~dp0rebuild.bat >> "%install_path%\SFML\build\%%a\rebuild-temp.txt"
   type "%install_path%\SFML\build\%%a\rebuild-temp.txt" > "%install_path%\SFML\build\%%a\rebuild.bat"
   del "%install_path%\SFML\build\%%a\rebuild-temp.txt"
))

xcopy %~dp0rebuild-all.bat "%install_path%\SFML\build\"

popd

echo Building SFML...

start /W "Building SFML" "%install_path%/SFML/build/rebuild-all.bat"

echo Downloading CSFML to "%install_path_csfml%"

if not exist "%install_path_csfml%" md "%install_path_csfml%"
pushd "%install_path_csfml%"

git clone https://github.com/ElijahZAwesome/CSFML

cd CSFML
md build
cd build

(for %%a in (%abis%) do ( 
   md %%a
   echo @echo off> %%a\rebuild-temp.txt
   echo set current_abi=%%a>> %%a\rebuild-temp.txt
   echo set ndk_path=%ndk_path%>> %%a\rebuild-temp.txt
))

popd
(for %%a in (%abis%) do ( 
   type %~dp0rebuild-csfml.bat >> "%install_path_csfml%\CSFML\build\%%a\rebuild-temp.txt"
   type "%install_path_csfml%\CSFML\build\%%a\rebuild-temp.txt" > "%install_path_csfml%\CSFML\build\%%a\rebuild.bat"
   del "%install_path_csfml%\CSFML\build\%%a\rebuild-temp.txt"
))

xcopy %~dp0rebuild-all.bat "%install_path_csfml%\CSFML\build\"

popd

echo Building CSFML...

start /W "Building CSFML" "%install_path_csfml%/CSFML/build/rebuild-all.bat"

echo Building CSFML is complete! If the build was successful, you can find your binaries in "%install_path_csfml%/CSFML/build/<architecture>/lib/".