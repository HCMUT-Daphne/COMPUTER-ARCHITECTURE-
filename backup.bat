@echo off
setlocal

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set "datetime=%datetime:~0,8%_%datetime:~8,6%"

set "folder_name1=D:\OneDrive\data9_backup\backup_%datetime%_milestone2"
set "folder_name2=E:\backup\backup_%datetime%_milestone2"

set "source_dir=V:\venmac\milestone2"

"C:\Program Files\7-Zip\7z.exe" a -tzip -p"pp77zip" "%folder_name1%" "%source_dir%\*"
"C:\Program Files\7-Zip\7z.exe" a -tzip -p"pp77zip" "%folder_name2%" "%source_dir%\*"

pause