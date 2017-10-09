echo off
set current_path=%cd%
echo "current_path = %current_path%"

cd %current_path%

For /F "tokens=1* delims==" %%A IN (makediddy2.properties) DO (
    IF "%%A"=="mx2cc_path" set mx2cc_path=%%B
)

echo "mx2cc_path   = %mx2cc_path%"

cd %mx2cc_path%
mx2cc_windows.exe makemods %current_path%
pause