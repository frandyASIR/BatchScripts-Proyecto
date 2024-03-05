@echo off  
chcp 65001 > nul
rem permite uilizar variables dentro del cofigo if por ejemplo.
setlocal enabledelayedexpansion  



rem ":" define una etiqueta
:inicio
rem limpiar pantalla
cls
echo Bienvenido al Sistema
echo 1. registrarse
echo 2. iniciar Sesion
echo 3. salir
rem creamos una variable que se llama opcion y esta vacia
set "opcion="
rem solicita al usuario que ingrese una opción y lo guarda en la variable opcion  
set /p opcion="Seleccione una opción: "
rem este if compara el valor de la variable opcion, si es igual a uno llamara a la etiquerta para que el usurio pueda registrarse, si es igual a dos podra iniciar sección con la opcion 3 podra salir, si no cumple y pone otra cosa que no sea 1 2 o 3 le dira que la opcion no es valida.
if "%opcion%"=="1" (
    call :registrarse
) else if "%opcion%"=="2" (
    call :iniciarSesion
) else if "%opcion%"=="3" (
    exit /b
) else (
    echo eliga 1 2 o 3.
    pause
    goto inicio
)

:registrarse
cls
echo Vamos a registrar un usuario.
rem creamos una variable llamada usuario
set "usuario="
rem solicita que ingrese el nombre del usuario y lo guarda en la variable usuario.
set /p usuario="Ingrese su nombre de usuario:"

rem Crear el archivo "usuarios.txt" si no existe
if not exist "usuarios.txt" type nul > "usuarios.txt"

rem Verificar si el usuario ya existe, con findstr busca patrones de texto en archivos
findstr /C:"!usuario!:" "usuarios.txt" >nul 

rem busca el nombre del usuario dentro del archivo usuario.txt
if %errorlevel% equ 0 (
    echo Este nombre de usuario ya está registrado. Por favor, elija otro.
    pause
    goto inicio
)

set "contrasena="
set "repContraseña="

set /p "contrasena=Ingrese su contraseña: "
set /p "repContraseña=Repita su contraseña: "

rem Verificar si las contraseñas coinciden
if !contrasena! neq !repContraseña! (
    echo Las contraseñas no coinciden. Por favor, inténtelo de nuevo.
    pause
    goto inicio
)

rem almacena la información del usuario en el archivo "usuarios.txt"
echo !usuario!:!contrasena! >> "usuarios.txt"

echo Registro exitoso.
pause
goto inicio

:iniciarSesion
cls
echo Iniciar Sesión 

set "usuario="
set "contrasena="

set /p "usuario=Ingrese su nombre de usuario: "
set /p "contrasena=Ingrese su contraseña: "

rem Verificar si el usuario existe y la contraseña coincide
findstr /C:"!usuario!:!contrasena!" "usuarios.txt" >nul
if %errorlevel% equ 0 (
    echo ¡Bienvenido, !usuario!
    call :menuUsuario
) else (
    echo Nombre de usuario o contraseña incorrectos.
    pause
    goto inicio
)

:menuUsuario
cls
echo -- Opciones de Usuario Después de Iniciar Sesión --
echo 1. Modificar Contraseña
echo 2. Eliminar Usuario
echo 3. Cerrar Sesión

set "opcion="
set /p "opcion=Seleccione una opción: "

if "%opcion%"=="1" (
    call :modificarContrasena
) else if "%opcion%"=="2" (
    call :eliminarUsuario
) else if "%opcion%"=="3" (
    goto inicio
) else (
    echo Opción no válida. Por favor, seleccione una opción válida.
    pause
    goto menuUsuario
)

:modificarContrasena
cls
echo  Modificar Contraseña 

set "nuevaContrasena="
set "repNuevaContrasena="

set /p "nuevaContrasena=Ingrese su nueva contraseña: "
set /p "repNuevaContrasena=Repita su nueva contraseña: "

rem verificar si las nuevas contraseñas coinciden
if !nuevaContrasena! neq !repNuevaContrasena! (
    echo Las nuevas contraseñas no coinciden. Por favor, inténtelo de nuevo.
    pause
    goto menuUsuario
)

rem actualizar la contraseña almacenada en el archivo "usuarios.txt"
set "tempFile=temp.txt"
rem busca todas las lineas en el archivo usuarios.txt, agrega una nueva linea al archivo temporal con el nombre de usuario seguido de una nueva linea temporal
findstr /v /C:"!usuario!:!contrasena!" "usuarios.txt" > "%tempFile%"
echo !usuario!:!nuevaContrasena! >> "%tempFile%"
move /Y "%tempFile%" "usuarios.txt"

echo Contraseña modificada correctamente.
pause
goto menuUsuario

:eliminarUsuario
cls
echo -- Eliminar Usuario --

rem Eliminar la cuenta del usuario del archivo "usuarios.txt"
findstr /v /C:"!usuario!:!contrasena!" "usuarios.txt" > "%tempFile%"
move /Y "%tempFile%" "usuarios.txt"

echo Ussuario eliminado .
pause
goto inicio
