 *************************************************************

	 Copyright Marcelo Pereira
	 Distributed under the GNU General Public License

 *************************************************************

These scripts allow the extraction of distributable libraries from Intel and
AMD for accelerating Linear Algebra operations in R by replacing the default
BLAS/LAPACK libraries shipped with R for Windows.

The scripts below must be executed in a terminal window, both PowerShell and CMD
can be used. The terminal window MUST be opened with administrator (Admin)
rights using Windows Start menu, or right-clicking on it and choosing "Terminal
(Admin)" on the context menu.

The provided syntax assume the current directory is the same where
the script files were downloaded/installed. On the terminal window use:

 cd [INST_DIR]

to change the current directory to INST_DIR, the download/install directory.


BLAS-LAPACK-import.bat
----------------------

BLAS-LAPACK-import.bat extracts the required dynamic libraries from the official
installations of Intel OneAPI Math Kernel Library (MKL) and AMD AOCL BLIS and
libFLAME libraries (required only for AMD EPYC/Ryzen processors). After
extraction, the original packages can be uninstalled.

If OneAPI MKL and AOCL are installed on the default locations, the script
should be able to find them. If not, one may pass the locations to the script
command line:

 BLAS-LAPACK-import [ONEAPI_DIR] [AOCL_DIR] [LIB_DIR]

If no LIB_DIR destination directory is supplied, the extraction is done to the
"lib" subdirectory of the directory containing the script.


R-BLAS-LAPACK.bat
-----------------

R-BLAS-LAPACK.bat configures the BLAS/LAPACK used by R in Windows. It can take
3 arguments:

 R-BLAS-LAPACK R_DIR [R,Intel,AMD] [LIB_DIR]

The first argument, the R installation directory (R_DIR) for the version being
modified, must be provided (e.g. "C:\Program Files\R\R-4.4.1"). Quotes are
required if the path contains spaces. If R_DIR is in the default location
(e.g. "C:\Program Files\R\R-4.4.1"), the command above must be run in a
administrative terminal/command prompt.

The second argument can be one of: "R", to revert to the original R libraries;
"Intel", to install the Intel MKL libraries; or "AMD", to install the AMD
libraries. If not provided, the default is "R" (restore to original libraries).

If a non-default extraction directory was used (i.e. not "Lib" subdirectory),
inform its full path as the third argument to the script.

When options "Intel" or "AMD" are used, the script replaces the BLAS/LAPACK
libraries which come with R, by renaming the Rblas.dll and Rlapack.dll in
R_DIR\bin\x64 and creating symbolic links to the correct Intel/AMD equivalents
in the LIB_DIR directory, and adding the LIB directory to the system PATH
environment variable (required). The original R configuration can be restored
using option "R".

The provided R script R-benchmark-25.R can be used to evaluate the performance
of BLAS/LAPACK libraries.

It is recommended to revert the original libraries before uninstalling R.
Non-original libraries are not removed by R uninstaller, they are left behind
together with part of the old R directory structure.

Please note that the script adds your library directory to the PATH environment
variable, if it is not already included. However, due to a Windows limitation,
the script can only do that if the new PATH content, including the library
directory, has a length equal or less than 1024 characters. If this is not the
case, the script will issue a warning, and the PATH variable MUST be adjusted
manually. To do so, in a terminal execute:

 sysdm.cpl

In the open window choose the Advanced tab, and click on the "Environment
Variables..." button. In the new window that opens, scroll the "System
variables" list to select the "Path" item, and click on the "Edit..." button.
On the new window, click the "New" button, type the path to the library
directory (this was show on the warning message), and click on the "OK" button
three times to close all the opened windows.

When reverting to the original R libraries with the "R" option, the library path
is not removed from the PATH environment variable. In this case, it can be
manually removed if not used by other software, by using the instructions above.