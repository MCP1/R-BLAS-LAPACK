 *************************************************************

	 Copyright Marcelo Pereira
	 Distributed under the GNU General Public License

 *************************************************************

These scripts allow the extraction of distributable libraries from Intel and
AMD for accelerating Linear Algebra operations in R by replacing the default
BLAS/LAPACK libraries shipped with R for Windows.

BLAS-LAPACK-import.bat
----------------------

BLAS-LAPACK-import.bat extracts the required dynamic libraries from the official
installations of Intel OneAPI MKL and AMD AOCL (required only for AMD Ryzen 
processors). After extraction, the original packages can be uninstalled. 

If OneAPI MKL and AOCL are installed on the default locations, the script
should be able to find them. If not, one may pass the locations to the script
command line:

 BLAS-LAPACK-import [ONEAPI_DIR] [AOCL_DIR] [LIB_DIR]
 
If no LIB_DIR destination directory is supplied, the extraction is done to the
"Lib" subdirectory of the directory containing the script.


R-BLAS-LAPACK.bat
-----------------

R-BLAS-LAPACK.bat configures the BLAS/LAPACK used by R in Windows. It can take
3 arguments:

 R-BLAS-LAPACK R_DIR [R,Intel,AMD] [LIB_DIR]

The first argument, the R installation directory (R_DIR) for the version being
modified, must be provided (e.g. "C:\Program Files\R\R-4.3.0"). Quotes are 
required if the path contains spaces.

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