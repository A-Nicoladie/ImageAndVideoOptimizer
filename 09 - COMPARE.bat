@ECHO OFF

REM ###########################################################################
REM ##                                                                       ##
REM ##             IAVO - Image And Video Optimizer for Windows              ##
REM ##                                                                       ##
REM ###########################################################################
REM ##                                                                       ##
REM ##  Author: Alexandre NICOLADIE                                          ##
REM ##    Date: 2021-09-22                                                   ##
REM ## License: CC0                                                          ##
REM ## Version: 1.0.0                                                        ##
REM ##   Email: 90625228+A-Nicoladie@users.noreply.github.com                ##
REM ##                                                                       ##
REM ###########################################################################

ECHO.
ECHO =================================
ECHO         IAVO Version 1.0.0       
ECHO ============= START =============

REM ################################################################## SETTINGS

REM If 'ConvertFiles' not equal 0 then gif, tiff, tif and bmp files will be
REM converted into png and optimized
SET ConvertFiles="1"

REM Output folder
SET OutputFolder=01-optimized

REM Backup folder
SET BackupFolder=00-original

REM PNG quality [0-100] Worst=0 ... 100=Best
REM HIGHT  = 99
REM MEDIUM = 96
REM LOW    = 89
SET QHDPNG=99
SET QMDPNG=96
SET QLDPNG=89

REM JPG quality [0-100] Worst=0 ... 100=Best
REM HIGHT  = 85
REM MEDIUM = 75
REM LOW    = 65
SET QHDJPG=85
SET QMDJPG=75
SET QLDJPG=65

REM MP4 quality [0-100] Worst=100 ... 0=Best
REM HIGHT  = 25
REM MEDIUM = 28
REM LOW    = 31
SET QHDMP4=25
SET QMDMP4=28
SET QLDMP4=31

REM File suffix
SET QHD=_0HD
SET QMD=_1MD
SET QLD=_2LD


ECHO.
ECHO PARAMETERS
ECHO ----------

IF %ConvertFiles=="0" (
    ECHO - Convertion in PNG : OFF
) ELSE (
    ECHO - Convertion in PNG : ON   ^(GIF TIFF BMP^)
)
ECHO.
ECHO - Output folder : ".\%OutputFolder"
ECHO - Backup folder : ".\%BackupFolder"
ECHO.
ECHO - PNG Quality (Worst=0 ... 100=Best)
ECHO   - LOW : %QLDPNG%
ECHO   - MED : %QMDPNG%
ECHO   - HIG : %QHDPNG%
ECHO.
ECHO - JPG Quality (Worst=0 ... 100=Best)
ECHO   - LOW : %QLDJPG%
ECHO   - MED : %QMDJPG%
ECHO   - HIG : %QHDJPG%
ECHO.
ECHO - MP4 Quality (Worst=100 ... 0=Best)
ECHO   - LOW : %QLDMP4%
ECHO   - MED : %QMDMP4%
ECHO   - HIG : %QHDMP4%
ECHO.
ECHO - Files suffix
ECHO   - LOW : %QLD%
ECHO   - MED : %QMD%
ECHO   - HIG : %QHD%

REM ############################################################ Create folders

IF NOT EXIST .\%OutputFolder% MKDIR .\%OutputFolder%
IF NOT EXIST .\%BackupFolder% MKDIR .\%BackupFolder%

REM ###################################################### Convert files in PNG
IF %ConvertFiles%=="0" GOTO EndPngConvert

ECHO.
ECHO.
ECHO --== Convert into PNG ==--
ECHO.

REM Extensions to convert  
SET pngExt=.gif .Gif .GIF .tiff .Tiff .TIFF .tif .Tif .TIF .bmp .Bmp .BMP

FOR %%a IN (*.*) DO (CALL:ConvertIntoPNG "%%a" "%%~xa")
GOTO EndPngConvert


:ConvertIntoPNG
REM Files without extension
IF %2=="" GOTO:EOF

ECHO %pngExt% | FINDSTR /C:%2>NUL && (
    REM Convert with the best quality
    ".\bin\ImageMagik\convert" -strip -interlace Plane -quality 100 "%~1" ".\%~n1.png"
    ECHO Convert "%~1" in "%~n1.png"
    REM Backup the original file
    MOVE "%~1" ".\%BackupFolder%\%~1">NUL
    REM Optimize the new png file and don't keep the non-optimized file
    CALL:OptimizePngFiles "%~n1.png" "0"
)
REM Next file in FOR loop
GOTO:EOF


:EndPngConvert


REM ############################################################ Optimize files 
ECHO.
ECHO.
ECHO --== Optimize PNG and JPG files ==--
ECHO.

SET pngExt=.png .Png .PNG
SET jpgExt=.jpg .Jpg .JPG .jpeg .Jpeg .JPEG

FOR %%a IN (*.*) DO (CALL:StartOptimize "%%a" %%~xa)
GOTO EndOptimize


:StartOptimize
REM Files without extension
IF "%2"=="" GOTO:EOF

REM Optimize JPG files
ECHO.%jpgExt% | FINDSTR /C:"%2">NUL && (
    CALL:OptimizeJpgFiles %1
)

REM Optimize PNG files
ECHO.%pngExt% | FINDSTR /C:"%2">NUL && (
    CALL:OptimizePngFiles %1 1
)
GOTO:EOF


REM --== OptimizePngFiles ==--
REM %1 = FileName
REM %2 = Keep original file ("0" = no / "0" != yes))
:OptimizePngFiles
ECHO Optimize %1
".\bin\pngquant\pngquant.exe" --force --verbose --ordered --speed=1 --quality=%QHDPNG% --strip --skip-if-larger --output ".\%OutputFolder%\%~n1%QHD%.png" "%~n1.png" 2>NUL
".\bin\pngquant\pngquant.exe" --force --verbose --ordered --speed=1 --quality=%QMDPNG% --strip --skip-if-larger --output ".\%OutputFolder%\%~n1%QMD%.png" "%~n1.png" 2>NUL
".\bin\pngquant\pngquant.exe" --force --verbose --ordered --speed=1 --quality=%QLDPNG% --strip --skip-if-larger --output ".\%OutputFolder%\%~n1%QLD%.png" "%~n1.png" 2>NUL
CALL:MoveFile %1 %2
GOTO:EOF


:OptimizeJpgFiles
ECHO Optimize %1
".\bin\jpegoptim\jpegoptim.exe" --strip-all --all-progressive -m%QHDJPG% --stdout %1 > ".\%OutputFolder%\%~n1%QHD%.jpg" 2>NUL
".\bin\jpegoptim\jpegoptim.exe" --strip-all --all-progressive -m%QMDJPG% --stdout %1 > ".\%OutputFolder%\%~n1%QMD%.jpg" 2>NUL
".\bin\jpegoptim\jpegoptim.exe" --strip-all --all-progressive -m%QLDJPG% --stdout %1 > ".\%OutputFolder%\%~n1%QLD%.jpg" 2>NUL
CALL:MoveFile %1 "1"
GOTO:EOF


REM --== MoveFile ==--
REM %1 = FileName
REM %2 = Keep original file ("0" = no / "0" != yes)
:MoveFile
REM If the file is not in the output folder = the file can't be optimized
IF NOT EXIST ".\%OutputFolder%\%~n1*.*" COPY %1 ".\%OutputFolder%\%~1">NUL
REM Keep the file ?
IF %2=="0" DEL %1 
IF NOT %2=="0" MOVE %1 ".\%BackupFolder%\%~1">NUL
GOTO:EOF


:EndOptimize


REM ########################################################### Optimize videos 
ECHO.
ECHO.
ECHO --== Optimize video files ==--
ECHO.

SET vidExt=.mp4 .Mp4 .MP4 .mov .Mov .MOV .avi .Avi .AVI .divx .Divx .DIVX .mkv .Mkv .MKV .mpg .Mpg .MPG .webm .WEBM .Webm

FOR %%a IN (*.*) DO (CALL:ProcessVideoFile "%%a" %%~xa)
GOTO EndVideoTreatment


:ProcessVideoFile
REM Files without extension
IF "%2"=="" GOTO:EOF

ECHO.%vidExt% | FINDSTR /C:"%2">NUL && (
    ECHO Optimize %1    
    ".\bin\HandBrakeCLI\HandBrakeCLI.exe" -Z "Fast 1080p30" -q %QHDMP4% -i "%~1" -o ".\%OutputFolder%\%~n1_0XD.mp4" 2>NUL
    ".\bin\HandBrakeCLI\HandBrakeCLI.exe" -Z "Fast 1080p30" -q %QMDMP4% -i "%~1" -o ".\%OutputFolder%\%~n1_1HD.mp4" 2>NUL
    ".\bin\HandBrakeCLI\HandBrakeCLI.exe" -Z "Fast 1080p30" -q %QLDMP4% -i "%~1" -o ".\%OutputFolder%\%~n1_2LD.mp4" 2>NUL
    MOVE "%~1" ".\%BackupFolder%\%~1">NUL
)
REM Next file in FOR loop
GOTO:EOF


:EndVideoTreatment


:END
ECHO.
ECHO ============== END ==============

PAUSE