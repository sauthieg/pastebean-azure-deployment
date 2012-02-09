@REM *** This script will run whenever Windows Azure starts this role instance.
@REM *** This is where you can describe the deployment logic of your server, JRE and applications.
@REM *** See this project's samples directory for ready made examples.

@REM If you want the output to show in a console window instead, comment out 
@REM the above and un-comment this:
@REM start cscript "util\unzip.vbs" "HelloWorld.zip" "%ROLEROOT%\approot"

@REM If instead of embedding certain large or rarely changing files in the deployment 
@REM package itself, you'd rather download them from some public URL location, then 
@REM use the download.vbs utility script, like this:

SET BLOB_URL=http://jonas.blob.core.windows.net
SET JAVA_VERSION=1.7.0_02
SET JONAS_VERSION=5.2.2
IF NOT EXIST "ow2-jonas-%JONAS_VERSION%-light.zip" cscript /nologo "util\download.vbs" "%BLOB_URL%/demo/ow2-jonas-%JONAS_VERSION%-light.zip"
IF NOT EXIST "jdk%JAVA_VERSION%.zip" cscript /nologo "util\download.vbs" "%BLOB_URL%/demo/jdk%JAVA_VERSION%.zip"

@REM Prepare directory (shorter names)
@REM ------------------------------------------------------------
rd "C:\%ROLENAME%"
mklink /D "C:\%ROLENAME%" "%ROLEROOT%\approot"
cd /d "C:\%ROLENAME%"

@REM Unpack Java SDK + OW2 JOnAS 
@REM ------------------------------------------------------------
IF NOT EXIST "jdk%JAVA_VERSION%" cscript /nologo "util\unzip.vbs" "jdk%JAVA_VERSION%.zip" "%CD%"
IF NOT EXIST "ow2-jonas-%JONAS_VERSION%" cscript /nologo "util\unzip.vbs" "ow2-jonas-%JONAS_VERSION%-light.zip" "%CD%"

@REM Set required environment variables 
@REM ------------------------------------------------------------
SET JONAS_ROOT=C:\%ROLENAME%\ow2-jonas-%JONAS_VERSION%
SET JAVA_HOME=C:\%ROLENAME%\jdk%JAVA_VERSION%
SET PATH=%PATH%;%JAVA_HOME%\bin;%JONAS_ROOT%\bin

@REM Overwrite some JOnAS files
@REM ------------------------------------------------------------
COPY /Y "conf\*" "%JONAS_ROOT%\conf"
COPY /Y "lib\ext\*" "%JONAS_ROOT%\lib\ext"

@REM Place application's modules in the deploy/ directory
@REM ------------------------------------------------------------
COPY /Y "deploy\*" "%JONAS_ROOT%\deploy"

@REM Spawn a JOnAS process and exit the current shell
@REM ------------------------------------------------------------
%JONAS_ROOT%\bin\jonas.bat start
