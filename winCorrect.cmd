@echo off
color 0b
set opn0=Operations
set opn1=Disk
set opn2=Windows
set opn3=Network
set opn4=Fermer
set msg=0

net.exe session 1>NUL 2>NUL || (Echo  WinCorrect " Access refuser " {run as admin}. & pause & Exit /b 1)

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
if %op% GTR 4 goto start
pause

:disk
set /a sec=1
goto head
:sec1

echo.
echo  0. Pour revenir au menu
set d=vide
set /p d=Veuillez choisir un disque : 
if %d% EQU 0 goto start
if not exist %d%: goto err1
chkdsk %d%: /F /R
pause
goto end

:err1
cls
color 04
echo repertoire %d% invalid
pause
color 0b
goto disk


:windows
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

echo Restauration Terminer.
pause

:end
set /a sec=10
goto head
:sec10
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
goto sec%sec%