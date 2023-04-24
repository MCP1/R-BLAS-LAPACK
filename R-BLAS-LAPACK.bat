@echo off
rem *************************************************************
rem
rem	 Copyright Marcelo Pereira
rem	 Distributed under the GNU General Public License
rem
rem *************************************************************

rem *************************************************************
rem  R-BLAS-LAPACK.BAT
rem  Replace BLAS/LAPACK low-performance libraries in R
rem  Replace required R files with Intel MKL and AMD AOCL ones
rem *************************************************************

rem file names to link
set R_BLAS=Rblas.dll
set R_LAPACK=Rlapack.dll
set AMD_BLIS=AOCL-LibBlis-Win-MT-dll.dll
set AMD_FLAME=AOCL-LibFlame-Win-MT-dll.dll
set INTEL_OMP=libiomp5md.dll
set INTEL_MKL=mkl_rt.2.dll
set INTEL_THR=mkl_intel_thread.2.dll

rem argument
if "%~1"=="/?" (
	echo Change R BLAS/LAPACK libraries
	echo Usage: R-BLAS-LAPACK R_DIR [R,Intel,AMD] [LIB_DIR]
	goto end
)

if "%~1"=="" (
	echo ERROR: R destination directory must be provided
	echo Usage: R-BLAS-LAPACK R_DIR [R,Intel,AMD] [LIB_DIR]
	goto end
)

rem R executable location
set "R_BIN=%~1bin\x64"

if "%2"=="" (
	set CPU=R
) else (
	set CPU=%2
)

set "LIB_DIR=%~dp0Lib"

if "%3"=="" (
	if exist "%LIB_DIR%" goto import

	echo No LIB FOLDER provided or found, aborting
rem 	goto end
) else (
	set "LIB_DIR=%~3"
)

:import

rem source files
set AMD_BLIS_SRC=%LIB_DIR%\%AMD_BLIS%
set AMD_FLAME_SRC=%LIB_DIR%\%AMD_FLAME%
set INTEL_OMP_SRC=%LIB_DIR%\%INTEL_OMP%
set INTEL_MKL_SRC=%LIB_DIR%\%INTEL_MKL%
set INTEL_THR_SRC=%LIB_DIR%\%INTEL_THR%

if not exist "%R_BIN%" (
	echo ERROR: R destination directory does not exist: "%R_BIN%"
	goto end
)

if not exist "%INTEL_OMP_SRC%" (
	echo ERROR: Intel OpenMP library does not exist: "%INTEL_OMP_SRC%"
	goto end
)

if "%CPU%"=="AMD" (
	if not exist "%AMD_BLIS_SRC%" (
		echo ERROR: AMD BLISS library does not exist: "%AMD_BLIS_SRC%"
		goto end
	)
	if not exist "%AMD_FLAME_SRC%" (
		echo ERROR: AMD Flame library does not exist: "%AMD_FLAME_SRC%"
		goto end
	)
	goto rename
) else if "%CPU%"=="Intel" (
	if not exist "%INTEL_MKL_SRC%" (
		echo ERROR: Intel MKL library does not exist: "%INTEL_MKL_SRC%"
		goto end
	)
	if not exist "%INTEL_THR_SRC%" (
		echo ERROR: Intel Thread library does not exist: "%INTEL_THR_SRC%"
		goto end
	)
	goto rename
) else if "%CPU%"=="R" (
	if not exist "%R_BIN%\%R_BLAS%.bak" (
		echo ERROR: R Original BLAS library does not exist: "%R_BIN%\%R_BLAS%.bak"
		goto end
	)
	if not exist "%R_BIN%\%R_LAPACK%.bak" (
		echo ERROR: R Original LAPACK library does not exist: "%R_BIN%\%R_LAPACK%.bak"
		goto end
	)
	goto no_rename
) else (
	echo ERROR: invalid option
	goto end
)

:rename

rem create backups once
if not exist "%R_BIN%\%R_BLAS%.bak" (
	ren "%R_BIN%\%R_BLAS%" "%R_BLAS%.bak"
)

if not exist "%R_BIN%\%R_LAPACK%.bak" (
	ren "%R_BIN%\%R_LAPACK%" "%R_LAPACK%.bak"
)

:no_rename

rem remove old files
if exist "%R_BIN%\%R_BLAS%" (
	del /F "%R_BIN%\%R_BLAS%"
)

if exist "%R_BIN%\%R_LAPACK%" (
	del /F "%R_BIN%\%R_LAPACK%"
)

if exist "%R_BIN%\%AMD_BLIS%" (
	del /F "%R_BIN%\%AMD_BLIS%"
)

if exist "%R_BIN%\%INTEL_OMP%" (
	del /F "%R_BIN%\%INTEL_OMP%"
)

if exist "%R_BIN%\%INTEL_THR%" (
	del /F "%R_BIN%\%INTEL_THR%"
)

rem handle options
if "%CPU%"=="R" (
	ren "%R_BIN%\%R_BLAS%.bak" "%R_BLAS%"
	ren "%R_BIN%\%R_LAPACK%.bak" "%R_LAPACK%"
	goto end
)

if "%CPU%"=="AMD" (
	mklink "%R_BIN%\%R_BLAS%" "%AMD_BLIS_SRC%" > nul
	mklink "%R_BIN%\%R_LAPACK%" "%AMD_FLAME_SRC%" > nul
	goto path
)

if "%CPU%"=="Intel" (
	mklink "%R_BIN%\%R_BLAS%" "%INTEL_MKL_SRC%" > nul
	mklink "%R_BIN%\%R_LAPACK%" "%INTEL_MKL_SRC%" > nul
	mklink "%R_BIN%\%INTEL_THR%" "%INTEL_THR_SRC%" > nul
	goto path
)

:path

rem get current system path before
for /f "tokens=2*" %%a in (
	'reg query "HKLM\System\CurrentControlSet\Control\Session Manager\Environment" /V Path ^| findstr /I "\<Path\>"'
) do set "SYSPATH=%%b"

rem check if not already in path
setLocal EnableDelayedExpansion
set "SUBPATH=!SYSPATH:%LIB_DIR%=!"

if not "%SUBPATH%"=="%SYSPATH%" set LIB_DIR=

rem add to path if possible
if not "!LIB_DIR!"=="" (
	if not "%SYSPATH%"=="" (
		setx path "%SYSPATH%;!LIB_DIR!" /M > nul
	) else (
		echo ERROR: could not add to PATH: "%LIB_DIR%"
	)
)

:end
