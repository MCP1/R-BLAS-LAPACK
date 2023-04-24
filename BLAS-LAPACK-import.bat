@echo off
rem *************************************************************
rem
rem	 Copyright Marcelo Pereira
rem	 Distributed under the GNU General Public License
rem
rem *************************************************************

rem *************************************************************
rem  BLAS-LAPACK-IMPORT.BAT
rem  Copy required files from AMD AOCL and Intel MKL
rem  Required installed software:
rem  Intel OneAPI Base Toolkit (64 bit, MKL option only)
rem  AMD AOCL (Windows 64-bit binary package)
rem *************************************************************

rem base package locations
set AMD_BASE=C:\Program Files\AMD\AOCL-Windows
set INTEL_BASE=C:\Program Files (x86)\Intel\oneAPI

rem XCOPY options for files and directories
set OPT=/D/Q/Y
set XOPT=%OPT%/S

if "%1"=="/?" (
	echo Import BLAS/LAPACK libraries to Lib folder
	echo Usage: BLAS-LAPACK-import [ONEAPI_DIR] [AOCL_DIR] [LIB_DIR]
	goto end
)

if "%1"=="" (
		if exist "%INTEL_BASE%\compiler" (
			if exist "%INTEL_BASE%\mkl" (
				goto amd_path
			)
	)
	echo No Intel FOLDER provided or found, aborting
	pause
	goto end
) else (
	set "INTEL_BASE=%1"
)

:amd_path

set INTEL_COMP=%INTEL_BASE%\compiler\latest\windows\redist\intel64_win\compiler
set INTEL_MKLB=%INTEL_BASE%\mkl\latest\redist\intel64

if "%2"=="" (
		if exist "%AMD_BASE%\amd-blis" (
			if exist "%AMD_BASE%\amd-libflame" (
				goto lsd_path
			)
	)
	echo No AMD FOLDER provided or found, aborting
	pause
	goto end
) else (
	set "AMD_BASE=%2"
)

:lsd_path

set AMD_BLIS=%AMD_BASE%\amd-blis\lib\LP64
set AMD_FLAME=%AMD_BASE%\amd-libflame\lib\LP64

if "%3"=="" (
	if not exist "%~dp0\Lib" (
		mkdir "%~dp0\Lib"
	)
	set "LIB_DEST=%~dp0\Lib"
) else (
	set "LIB_DEST=%3"
)

:import

echo Intel libraries...
XCOPY %OPT% "%INTEL_COMP%\libiomp5md.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\1033\mkl_msg.dll" %LIB_DEST%\1033\
XCOPY %OPT% "%INTEL_MKLB%\mkl_intel_thread.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_sequential.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_rt.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_core.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_def.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_mc.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_mc3.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_avx.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_avx2.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_avx512.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_vml_def.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_vml_mc.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_vml_mc3.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_vml_avx.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_vml_avx2.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_vml_avx512.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\mkl_vml_cmpt.2.dll" %LIB_DEST%\
XCOPY %OPT% "%INTEL_MKLB%\libimalloc.dll" %LIB_DEST%\

echo AMD libraries...
XCOPY %OPT% "%AMD_BLIS%\AOCL-LibBlis-Win-MT-dll.dll" %LIB_DEST%\
XCOPY %OPT% "%AMD_FLAME%\AOCL-LibFlame-Win-MT-dll.dll" %LIB_DEST%\

echo done

:end