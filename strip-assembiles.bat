@echo off 

set toPublicize=Assembly-CSharp.dll assembly_valheim.dll assembly_utils.dll assembly_postprocessing.dll assembly_sunshafts.dll assembly_steamworks.dll assembly_simplemeshcombine.dll assembly_lux.dll assembly_guiutils.dll assembly_googleanalytics.dll
set toIgnore=Mono.Security.dll mscorlib.dll System.Configuration.dll System.Core.dll System.dll System.Xml.dll

set exePath=%1
echo exePath: %exePath% 

@REM Remove quotes
set exePath=%exePath:"=%

set managedPath=%exePath:.exe=_Data\Managed%
echo managedPath: %managedPath%

set outPath=%~dp0\package\lib

@REM Strip all assembiles, but keep them private.
%~dp0\tools\NStrip.exe "%managedPath%" -o %outPath%

@REM Strip and publicize assemblies from toPublicize.
(for %%a in (%toPublicize%) do (
  echo a: %%a

  %~dp0\tools\NStrip.exe "%managedPath%\%%a" -o "%outPath%\%%a" -cg -p --cg-exclude-events
))

@REM Removing unused packages
(for %%a in (%toIgnore%) do (
  echo a: %%a

  del /f "%outPath%\%%a"
))

pause
