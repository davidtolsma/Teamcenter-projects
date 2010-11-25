@echo OFF
cls

set applicationName=listItems
set executableExtension=exe


:: Sets where this program is located at
    set thisScriptLocation=%~dp0
    set clean=%1

set executableFolderName=compiled
set sourceFolderName=source
set objectFolderName=obj

:: Clean all the objects and executables out of the structure
IF "%clean%"=="CLEAN" GOTO :CLEANDIR


call variables.bat
call TcEngEnvironment.bat

:: Delete all object files
del /q %objectFolderName%\*


CALL %IMAN_ROOT%\sample\compile -DIPLIB=none %sourceFolderName%\%applicationName%.c

:: Create objects Directory
CALL :CREATEDIR %objectFolderName%

:: Move all objects to objects folder
move *.obj %objectFolderName%


:: Create executable Directory
CALL :CREATEDIR %executableFolderName%


call %IMAN_ROOT%\sample\linkitk -o %applicationName% %objectFolderName%\%applicationName%.obj

:: Move Link File
move *.ilk %objectFolderName%

:: Move PBD file to executable directory
move *.pdb %executableFolderName%

:: Move the executable to the Executable directory
move %applicationName%.%executableExtension% %executableFolderName%

GOTO :QUIT


:CREATEDIR
    set argument=%*

    :: If the folder does not exist this will create it
    if not exist %thisScriptLocation%..\%argument% md %argument%


    GOTO :EOF

:CLEANDIR
    del /q %objectFolderName%\* 
    del /q %executableFolderName%\* 

    echo.
    echo Directories Cleaned...
    echo.

    GOTO :QUIT

:QUIT

