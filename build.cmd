mkdir build\dashel
pushd build\dashel
cmake.exe -G "MinGW Makefiles"^
 -D "CMAKE_BUILD_TYPE=Release"^
 -D "BUILD_SHARED_LIBS=OFF"^
 "%WORKSPACE%\source\dashel"
mingw32-make.exe
popd

mkdir build\enki
pushd build\enki
cmake.exe -G "MinGW Makefiles"^
 -D "CMAKE_BUILD_TYPE=Release"^
 "%WORKSPACE%\source\enki"
mingw32-make.exe
popd

mkdir build\aseba
pushd build\aseba
cmake.exe -G "MinGW Makefiles"^
 -D "CMAKE_BUILD_TYPE=Release"^
 -D "dashel_DIR=%WORKSPACE%\build\dashel"^
 -D "enki_DIR=%WORKSPACE%\build\enki"^
 -D "LIBXML2_INCLUDE_DIR=%ASEBA_DEP%\libxml2\include"^
 -D "LIBXML2_LIBRARIES=%ASEBA_DEP%\libxml2\win32\bin.mingw\libxml2.a"^
 -D "QWT_INCLUDE_DIR=%ASEBA_DEP%\qwt\src"^
 -D "QWT_LIBRARIES=%ASEBA_DEP%\qwt\lib\libqwt5.a"^
 "%WORKSPACE%\source\aseba"
mingw32-make.exe
mkdir strip
del /Q strip
for /f %%F in ('dir *.exe /s /b') do (
	objcopy.exe --strip-all %%F strip\%%~nxF
)
popd

powershell.exe -nologo -noprofile -command^
	"& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%ASEBA_DEP%/blockly/blockly.zip', 'build'); }"

del /Q *.exe
makensis.exe^
 "/DASEBA_DEP=%ASEBA_DEP%"^
 "/DQTDIR=%QTDIR%"^
 -- "%WORKSPACE%\source\package\aseba.nsi"
move "%WORKSPACE%\source\package\*.exe" .
