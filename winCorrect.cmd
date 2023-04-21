@echo off
color 0b
set opn0=Menu
set opn1=Disk
set opn2=Windows
set opn3=Network
set opn4=Fermer
set msg=0

net.exe session 1>NUL 2>NUL || (Echo WinCorrect " Access denied " { please run as administrator }. & pause & exit /b 1)

:start
set /a op=0
set /a sec=0
goto head
:sec0

echo.
echo  1. Verification de Disque
echo  2. Correction du Systeme d'exploitation ( OS )
echo  3. Netoyage et verification reseau
echo  4. Fermer le script
echo.
set /p op=Veuillez choisir une operation : 

if %op% LSS 1 goto start
if %op% EQU 1 goto disk
if %op% EQU 2 goto windows
if %op% EQU 3 goto network
if %op% EQU 4 goto end
if %op% GTR 5 goto start
pause

:disk
set /a sec=1
goto head
:sec1

echo.
echo  0. Pour revenir au menu
set d=vide
set /p d=Veuillez choisir un disque [D,E,F,...] : 
if %d% EQU 0 goto start

set tr=disk
set msg=le repertoire %d% est invalide
if not exist %d%: goto err
set msg=0

if not exist %d%: goto err1

set /p virchk=Voulez-vous supprimer les fichiers scripts malveillants [Y/N] : 
if /i %virchk% NEQ Y set virchk=N
if /i %virchk% EQU N goto dchk
attrib -s -h -r /s /d %d%:\*.*

set /p virchk=Voulez-vous supprimer les fichiers "JS" [Y/N] : 
if /i %virchk% NEQ Y set virchk=N
if /i %virchk% EQU Y del %d%:\*.js /F /S

set /p virchk=Voulez-vous supprimer les script "BAT" [Y/N] : 
if /i %virchk% NEQ Y set virchk=N
if /i %virchk% EQU Y del %d%:\*.bat /F /S

set /p virchk=Voulez-vous supprimer les fichiers "INF" [Y/N] : 
if /i %virchk% NEQ Y set virchk=N
if /i %virchk% EQU Y del %d%:\*.inf

:dchk
chkdsk %d%: /F /R

pause
goto end


:windows
set /a sec=2
goto head
:sec2

echo connexion internet requise
pause

cls
echo Etape 1 / 3 : Verification simple
sfc /scannow 

cls
echo Etape 2 / 3 : Verification avancer
dism /Online /Cleanup-Image /RestoreHealth 


cls
echo Etape 3 / 3 : Finalisation
sfc /scannow

pause
goto end





:network
set /a sec=3
goto head
:sec3

echo Connexion internet requise
pause

echo Votre connexion internet sera suspendue.
pause

echo Suspension de la connexion internet.
ipconfig /release
TIMEOUT 5 /nobreak

echo Restauration de la connexion internet.
ipconfig /renew
TIMEOUT 5 /nobreak

echo finalisation.
ipconfig /flushdns

echo Restauration terminer.
pause
goto end




:AntiMalware
set /a sec=4
goto head
:sec4

echo.
echo  0. Pour revenir au menu
set d=NONE
set /p d=Veuillez choisir un disque [D,E,F,...] : 
if %d% EQU 0 goto start

set tr=AntiMalware
set msg=le repertoire ( %d%:\ ) est invalide
if not exist %d%: goto err
if %d% EQU C goto err
if %d% EQU c goto err
set msg=0

attrib -H -S -R /S /D %d%:
del /F /Q /S *.com *.lnk *.exe 

pause
goto end


:end
set /a sec=990
goto head
:sec990
echo.
set /p op=Voulez vous fermer le script ? [Y/N]: 
if %op% EQU N goto start
if %op% EQU n goto start
if %op% EQU Y exit
if %op% EQU y exit
goto end


:head
cls
call set opn=%%opn%op%%%
ver
echo WinCorrect [ %opn% ]
if %msg% NEQ 0 echo %msg%
set msg=0
goto sec%sec%

:err
cls
color 04
call set opn=%%opn%op%%%
ver
echo WinCorrect [ %opn% ]
echo.
echo %msg%
set msg=0
pause
color 0b
goto %tr%
