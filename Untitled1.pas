PROGRAM  proyecto1;
//EL SIGUIENTE SOFTWARE EMULA UN ADMINISTRADOR DE MANGAS Y ANIMES.
USES crt;

CONST
    posX = 10;

TYPE
    password = array[1..10]of string;

    cuentas = record  // REGISTRO DE UNA CUENTA DE UN CLIENTE.
      clave_usuario: integer;
      contrasenia_usuario: string [10];
    end;

    animes = record // REGISTRO DE UN ANIME.
     nombre_anime: string[20];
     plataforma_anime: string[20];
     vistas_anime: integer;
     info_anime: string;
    end;

    manga = record // REGISTRO DE UN MANGA.
     nombre_manga: string[20];
     manga_tomo: integer;
     manga_editorial_manga: string[20];
     manga_prestado: string;
    end;

    cliente = record // REGISTRO DE UN CLIENTE
     nombre: string[10];
     apellido: string[10];
     dni: string[8];
     manga: string[15];
     tomo: integer;
     fecha_hoy: string;
     fecha_devolucion: string;
    end;

VAR
   // SE DECLARAN LAS VARIABLES DE TIPO ARCHIVO CON SU RESPECTIVA DECLARATIVA EN TIPO REGISTRO.
   archivo_cuentas: FILE OF cuentas;
   registro_cuentas: cuentas;
   archivo_animes: FILE OF animes;
   registro_animes: animes;
   archivo_mangas: FILE OF manga;
   registro_manga: manga;
   archivo_clientes: FILE OF cliente;
   registro_clientes: cliente;
   vista_usuario: integer;
   pas: password;

PROCEDURE incializar;
VAR
 i: integer;
 BEGIN
  FOR i:= 1 TO 10 DO
   BEGIN
    pas[i]:= '';
   END;
 END;

PROCEDURE crear_archivo_cuentas(); // CREAMOS EL ARCHIVO CUENTAS, DEJANDOLO VACIO.
 BEGIN
  rewrite(archivo_cuentas);
  close(archivo_cuentas);
 END;

PROCEDURE crear_archivo_animes(); // CREAMOS EL ARCHIVO ANIMES, DEJANDOLO VACIO.
 BEGIN
  rewrite(archivo_animes);
  close(archivo_animes);
 END;

PROCEDURE crear_archivo_mangas(); // CREAMOS EL ARCHIVO MANGAS, DEJANDOLO VACIO.
 BEGIN
  rewrite(archivo_mangas);
  close(archivo_mangas);
 END;

PROCEDURE crear_archivo_clientes(); // CREAMOS EL ARCHIVO CLIENTES, DEJANDOLO VACIO.
 BEGIN
  rewrite(archivo_clientes);
  close(archivo_clientes);
 END;

FUNCTION verificar_estado_archivo_cuentas():boolean; // ESTA FUNCION VERIFICA QUE EN EL ARCHIVO CUENTAS SI ESTA VACIO INDIQUE AL USUARIO DE QUE NO HAY REGISTROS Y QUE NO PODRA CONTINUAR.
 BEGIN
 reset(archivo_cuentas);
 IF filesize(archivo_cuentas) = 0 THEN
  verificar_estado_archivo_cuentas:= true
 ELSE
  verificar_estado_archivo_cuentas:= false;
 close(archivo_cuentas);
 END;

PROCEDURE ordenar_ranking();
VAR
 i,j: integer;
 registro_auxiliar: animes;
 BEGIN
  FOR i:= 0 TO filesize(archivo_animes) - 2 DO
  BEGIN
   FOR j:= i + 1 TO filesize(archivo_animes) - 1 DO
   BEGIN
   seek(archivo_animes,i);
   read(archivo_animes,registro_animes);
   seek(archivo_animes,j);
   read(archivo_animes,registro_auxiliar);
   IF registro_animes.vistas_anime < registro_auxiliar.vistas_anime THEN
   BEGIN
   seek(archivo_animes,i);
   write(archivo_animes,registro_auxiliar);
   seek(archivo_animes,j);
   write(archivo_animes,registro_animes);
   END;
   END;
  END;
 END;

PROCEDURE carga_animes; // CARGAMOS EL ARCHIVO CON LA CANTIDAD DE REGISTROS QUE SE DESEE.
VAR
 opcion: string;
 BEGIN
  REPEAT
  clrscr;
  writeln('-------------------------------------------------------');
  writeln('|Presione * para dar por finalizado la carga de animes|');
  writeln('----------');
  writeln('');
  reset(archivo_animes);
  writeln('||||||||||||||||||||||||||||||||||||||||||||||||||||||');
  writeln('------------------------------------------------------');
  writeln('Ingrese nombre del anime: ');
  readln(registro_animes.nombre_anime);
  WHILE registro_animes.nombre_anime <> '*' DO
   BEGIN
    writeln('----------------------------------------------------');
    writeln('Ingrese nombre de plataforma donde se emite: ');
    readln(registro_animes.plataforma_anime);
    writeln('----------------------------------------------------');
    writeln('Ingrese la cantidad de vistas: ');
    readln(registro_animes.vistas_anime);
    writeln('----------------------------------------------------');
    writeln('Ingrese sinopsis del anime: ');
    readln(registro_animes.info_anime);
    seek(archivo_animes,filesize(archivo_animes));
    write(archivo_animes,registro_animes);
    writeln();
    clrscr;
    writeln('|||||||||||||||||||||||||||||||||||||||||||||');
    writeln('---------------------------------------------');
    writeln('Ingrese nombre del anime: ');
    readln(registro_animes.nombre_anime);
   END;
  ordenar_ranking;
  close(archivo_animes);
  writeln();
  clrscr;
  textcolor(green);
  writeln('******************************************');
  writeln('** Anime cargado al registro con exito! **');
  writeln('******************************************');
  writeln();
  writeln('------------------------------------------');
  writeln();
  writeln('Desea volver a cargar otro anime [s/n]?:');
  readln(opcion);
  UNTIL (opcion = 'n');
 END;

PROCEDURE listar_ranking();
 BEGIN
  WHILE NOT EOF(archivo_animes) do
   BEGIN
   read(archivo_animes,registro_animes);
   writeln('|| ',registro_animes.nombre_anime,'  ||  ',registro_animes.plataforma_anime,'  ||  ',registro_animes.vistas_anime);
   writeln('-------------------------------------------------------');
   END;
 END;

PROCEDURE animes_mas_vistos();
 BEGIN
  reset(archivo_animes);
  writeln('=======================================================');
  writeln('          *** RANKING DE ANIMES MAS VISTOS ***         ');
  writeln('=======================================================');
  writeln('     anime     |      plataforma      |      vistas    ');
  writeln('-------------------------------------------------------');
  writeln();
  listar_ranking;
  close(archivo_animes);
  writeln();
  writeln('Pulse enter para continuar al menu principal...');
  readln();
 END;

PROCEDURE busca_info_anime(nombre_anime: string);
VAR
 f: boolean;
 BEGIN
  reset(archivo_animes);
  f:= false;
  REPEAT
    read(archivo_animes,registro_animes);
    IF nombre_anime = registro_animes.nombre_anime THEN
     f:= true;
   UNTIL eof(archivo_animes) OR (f = true);
  IF f = true THEN
   BEGIN
   clrscr;
   textcolor(brown);
   writeln('=================================================================================================');
   writeln('///////////////////////////////////',registro_animes.nombre_anime,'///////////////////////////////////////////////');
   writeln('=================================================================================================');
   writeln(registro_animes.info_anime);
   writeln('=================================================================================================');
   END;
  close(archivo_animes);
 END;

PROCEDURE informacion_anime();
VAR
 nombre_anime: string;
 BEGIN
 writeln('_______________________________________________________');
 writeln('-------------------------------------------------------');
 write('Ingrese el nombre del anime para saber su sinopsis: ');
 readln(nombre_anime);
 busca_info_anime(nombre_anime);
 writeln();
 writeln('Pulse tecla enter para volver al menu...');
 readln();
 END;

FUNCTION verificar_biblioteca():boolean;
 BEGIN
  reset(archivo_mangas);
  IF filesize(archivo_mangas) = 0 THEN
   verificar_biblioteca:= true
  ELSE
   verificar_biblioteca:= false;
 END;

PROCEDURE carga_de_mangas();
VAR
 opcion: string;
 BEGIN
 REPEAT
  reset(archivo_mangas);
  writeln('=========================');
  write('Ingrese nombre de manga: ');
  readln(registro_manga.nombre_manga);
  WHILE registro_manga.nombre_manga <> '*' DO
   BEGIN
   writeln();
   writeln('--------------------');
   write('Ingrese nro de tomo: ');
   readln(registro_manga.manga_tomo);
   writeln();
   writeln('--------------------');
   write('Ingrese editorial: ');
   readln(registro_manga.manga_editorial_manga);
   writeln();
   writeln('---------------------');
   writeln('Disponible[s/n]? :');
   readln(registro_manga.manga_prestado);
   writeln();
   seek(archivo_mangas,filesize(archivo_mangas));
   write(archivo_mangas,registro_manga);
   writeln('==========================');
   write('Ingrese nombre de manga: ');
   readln(registro_manga.nombre_manga);
   END;
   close(archivo_mangas);
   writeln();
   clrscr;
   textcolor(lightgreen);
   writeln('------------------------------------------------------');
   writeln('| *** Manga/s guardado/s con exito en el archivo *** |');
   writeln('------------------------------------------------------');
   writeln();
   textcolor(lightcyan);
   writeln('------------------------------------------------------');
   writeln('Desea volver a cargar mas mangas? [s/n]: ');
   readln(opcion);
  UNTIL (opcion = 'n');
 END;

PROCEDURE listar_mangas_disponibles();
 BEGIN
  reset(archivo_mangas);
 writeln('=======================================================');
 writeln('_-_ _,,      ,,       ,,            ,                 ');
 writeln('  -/  )   * ||       ||  *        ||               _  ');
 writeln(' ~||_<   \\ ||/|, \\ || \\  /\\  =||=  _-_   _-_  < \,');
 writeln('  || \\  || || || || || || || ||  ||  || \\ ||    /-||');
 writeln('  ,/--|| || || |, || || || || ||  ||  ||/   ||   (( ||');
 writeln(' _--_-+  \\ \\/   \\ \\ \\ \\,/   \\, \\,/  \\,/  \/\\');
 writeln('(                                                     ');
 writeln('======================================================');
 writeln();
  WHILE NOT eof(archivo_mangas) DO
   BEGIN
    read(archivo_mangas,registro_manga);
    writeln('=================================================');
    writeln('|///////////////////////////////////////////////|');
    writeln('=================================================');
    writeln('| Nombre      | ',registro_manga.nombre_manga,'   |');
    writeln('| Tomo        | ',registro_manga.manga_tomo,'           |');
    writeln('| Editorial   | ',registro_manga.manga_editorial_manga,'|');
    writeln('=================================================');
   END;
   close(archivo_mangas);
   writeln();
   writeln('Pulse enter para continuar al menu principal...');
   readln();
 END;

PROCEDURE eleccion_mangas();
 BEGIN
  IF verificar_biblioteca = true THEN
    BEGIN
    textcolor(lightred);
    writeln('==================================================================');
    writeln('|////////////////////////////////////////////////////////////////|');
    writeln('|/ No hay mangas cargados por ahora. volvera al menu principal //|');
    writeln('|////////////////////////////////////////////////////////////////|');
    writeln('==================================================================');
    writeln();
    writeln('Pulse enter para continuar...');
    readln();
    END
  ELSE
    BEGIN
     listar_mangas_disponibles();
    END;
 END;

FUNCTION verificar_prestado(nombre: string; tomo: integer):boolean;
VAR
 flag: boolean;
 BEGIN
  flag:= false;
  REPEAT
   read(archivo_mangas,registro_manga);
   IF nombre = registro_manga.nombre_manga THEN
    BEGIN
    IF tomo = registro_manga.manga_tomo THEN
     IF registro_manga.manga_prestado = 's' THEN
     flag:= true;
    END;
  UNTIL eof(archivo_mangas) OR (flag = true);
  IF flag = true THEN
   verificar_prestado:= true
  ELSE
   verificar_prestado:= false;
 END;

PROCEDURE cargar_cliente();
 BEGIN
  reset(archivo_clientes);
   clrscr;
   writeln('*******************************');
   writeln('Ingrese nombre del cliente:    ');
   readln(registro_clientes.nombre);
   writeln();
   writeln('Ingrese apellido del cliente: ');
   readln(registro_clientes.apellido);
   writeln();
   writeln('Ingrese dni del cliente: ');
   readln(registro_clientes.dni);
   writeln();
   writeln('Ingrese manga que llevara: ');
   readln(registro_clientes.manga);
   writeln();
   writeln('Ingrese nro de tomo del manga: ');
   readln(registro_clientes.tomo);
   writeln();
   writeln('Ingrese fecha de hoy: ');
   readln(registro_clientes.fecha_hoy);
   writeln();
   writeln('Ingrese fecha de devolucion: ');
   readln(registro_clientes.fecha_devolucion);
   writeln('******************************');
   seek(archivo_clientes,filesize(archivo_clientes));
   write(archivo_clientes,registro_clientes);
  close(archivo_clientes);
  writeln();
  textcolor(lightgreen);
  clrscr;
 END;

PROCEDURE mostrar_ticket(tomo: integer; nombre: string);
VAR
 nombre_cli,apell_cli,fh,fd,doc_cli: string;
 f: boolean;
 BEGIN
  reset(archivo_clientes);
  f:= false;
  REPEAT
  read(archivo_clientes,registro_clientes);
  IF (nombre = registro_clientes.manga) AND (tomo = registro_clientes.tomo) THEN
   BEGIN
   f:= true;
   nombre_cli:= registro_clientes.nombre;
   apell_cli:= registro_clientes.apellido;
   doc_cli:= registro_clientes.dni;
   fh:= registro_clientes.fecha_hoy;
   fd:= registro_clientes.fecha_devolucion;
   END;
  UNTIL eof(archivo_clientes) OR (f = true);
  close(archivo_clientes);
  IF f = true THEN
   BEGIN
   writeln('_________________________________________________________________________________');
   writeln('||.............................................................................||');
   writeln('=================================================================================');
   writeln('|| - - - - - - - - - - - - - - - - - TICKET - - - - - - - - - - - - - - - - -  ||');
   writeln('||-----------------------------------------------------------------------------||');
   writeln('|| NOMBRE: ',nombre_cli,'                                                      ||');
   writeln('|| APELLIDO: ',apell_cli,'                                                     ||');
   writeln('|| DNI: ',doc_cli,'                                                            ||');
   writeln('|| MANGA: ',nombre,'                                                           ||');
   writeln('|| TOMO: ',tomo,'                                                              ||');
   writeln('|| FECHA DE HOY: ',fh,'                                                        ||');
   writeln('|| FECHA DE DEVOLUCION: ',fd,'                                                 ||');
   writeln('|| ------------------------------------------------------------------------------');
   writeln('|| * * * * * * * * * * * * * GRACIAS POR SU TIEMPO * * * * * * * * * * * * * * ||');
   writeln('||===============================================================================');
   writeln();
   writeln('**********************************');
   writeln('* Disfrute de una buena lectura! *');
   writeln('**********************************');
   END;
 END;

PROCEDURE actualizar_disponibilidad_manga(nombre: string; tomo: integer);
VAR
 f: boolean;
 BEGIN
  f:= false;
  REPEAT
  seek(archivo_mangas,filepos(archivo_mangas) - 1);
  read(archivo_mangas,registro_manga);
  IF nombre = registro_manga.nombre_manga THEN
   IF tomo = registro_manga.manga_tomo THEN
    BEGIN
     f:= true;
    END;
  UNTIL eof(archivo_mangas) OR (f = true);
  IF f = true then
   BEGIN
   registro_manga.manga_prestado:= 'n';
   seek(archivo_mangas,filepos(archivo_mangas) - 1);
   write(archivo_mangas,registro_manga);
   END;
 END;

PROCEDURE pedir_prestado();
VAR
 tomo: integer;
 nombre: string[20];
 opcion: string;
 BEGIN
 REPEAT
  clrscr;
  reset(archivo_mangas);
  writeln('========================================');
  write('Titulo del manga que esta buscando? :');
  readln(nombre);
  writeln('----------------------------------------');
  write('Ingrese nro de tomo que esta buscando: ');
  readln(tomo);
  IF verificar_prestado(nombre,tomo) = true THEN
   BEGIN
   cargar_cliente();
   writeln();
   mostrar_ticket(tomo,nombre);
   actualizar_disponibilidad_manga(nombre,tomo);
   END
  ELSE
   BEGIN
   clrscr;
   writeln();
   textcolor(lightred);
   writeln('=================================================================');
   writeln('|///////////////////////////////////////////////////////////////|');
   writeln('|/ El tomo de ese manga que estas buscando no esta disponible //|');
   writeln('|///////////////////////////////////////////////////////////////|');
   writeln('=================================================================');
   END;
   close(archivo_mangas);
   writeln();
   textcolor(green);
   writeln('--------------------------------------');
   writeln('Desea volver a elegir un manga[s/n]?: ');
   readln(opcion);
  UNTIL (opcion = 'n');
 END;


PROCEDURE bibilioteca_de_mangas();
VAR
 opcion: integer;
 BEGIN
  REPEAT
   clrscr;
   textcolor(lightmagenta);
   gotoxy(whereX + 18, whereY);
   writeln('================================================================');
   gotoxy(whereX + 18, whereY);
   writeln('######### #           ######        #      #        ########## ');
   gotoxy(whereX + 18, whereY);
   writeln('        # #   ###                  #       #   ###  #        # ');
   gotoxy(whereX + 18, whereY);
   writeln('        # ####      ##########    #        ####             #  ');
   gotoxy(whereX + 18, whereY);
   writeln(' ########  #        #        #   #         #               #   ');
   gotoxy(whereX + 18, whereY);
   writeln('        #  #               ##   #     #    #              #    ');
   gotoxy(whereX + 18, whereY);
   writeln('        #  #             ##    #########   #            ##     ');
   gotoxy(whereX + 18, whereY);
   writeln('########   #######    ##                #   #######   ##       ');
   gotoxy(whereX + 18, whereY);
   writeln('===============================================================');
   writeln();
   textcolor(yellow);
   writeln();
   gotoxy(whereX + 30, whereY);
   writeln('--------------');
   gotoxy(whereX + 30, whereY);
   writeln('Menu principal');
   gotoxy(whereX + 30, whereY);
   writeln('--------------');
   gotoxy(whereX + 30, whereY);
   writeln();
   gotoxy(whereX + 30, whereY);
   writeln('-------------------------------');
   gotoxy(whereX + 30, whereY);
   writeln('|      1. Carga de mangas     |');
   gotoxy(whereX + 30, whereY);
   writeln('-------------------------------');
   gotoxy(whereX + 30, whereY);
   writeln('|      2. ver biblioteca      |');
   gotoxy(whereX + 30, whereY);
   writeln('-------------------------------');
   gotoxy(whereX + 30, whereY);
   writeln('|          3.Prestar          |');
   gotoxy(whereX + 30, whereY);
   writeln('-------------------------------');
   gotoxy(whereX + 30, whereY);
   writeln('|       4. Devoluciones       |');
   gotoxy(whereX + 30, whereY);
   writeln('-------------------------------');
   gotoxy(whereX + 30, whereY);
   writeln('| 5. Volver al menu principal |');
   gotoxy(whereX + 30, whereY);
   writeln('-------------------------------');
   writeln();
   gotoxy(whereX + 30, whereY);
   writeln('--------------');
   gotoxy(whereX + 30, whereY);
   write('Ingrese opcion: ');
   readln(opcion);
   CASE opcion OF
     1:BEGIN
        clrscr;
        carga_de_mangas();
       END;
      2:BEGIN
        clrscr;
        eleccion_mangas();
       END;
      3:BEGIN
        clrscr;
        pedir_prestado();
       END;
    {  4:BEGIN
        clrscr;
        devoluciones();
        END; }
   END;
  UNTIL (opcion = 5) ;
 END;


PROCEDURE menu_principal();
VAR
 opcion: integer;
 BEGIN
  REPEAT
   clrscr;
   textcolor(green);
   writeln('======================');
   writeln('|| Usuario || ',vista_usuario,' ||');
   writeln('======================');
   writeln();
   textcolor(brown);
   writeln('===================================================================================');
   writeln('|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
   writeln('===================================================================================');
   writeln('|| ___                                                                           ||');
   writeln('|| -   -_,  |\                                ,                                  ||');
   writeln('||(  ~/||    \\            *        *        ||          _         *             ||');
   writeln('||(  / ||   / \\ \\/\\/\\ \\ \\/\\ \\  _-_, =||= ,._-_  < \,  _-_ \\  /\\ \\/\\  ||');
   writeln('|| \/==||  || || || || || || || || || ||_.   ||   ||    /-|| ||   || || || || || ||');
   writeln('|| /_ _||  || || || || || || || || ||  ~ ||  ||   ||   (( || ||   || || || || || ||');
   writeln('||(  - \\,  \\/  \\ \\ \\ \\ \\ \\ \\ ,-_-   \\,  \\,   \/\\ \\,/ \\ \\,/  \\ \\ ||');
   writeln('===================================================================================');
   writeln('|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
   writeln('===================================================================================');
   writeln();
   textcolor(magenta);
   writeln('///////////////////////');
   writeln('// MENU DE OPCIONES //');
   writeln('/////////////////////');
   writeln();
   writeln('============================================');
   writeln('|1| -      Cargar animes vistos        - |1|');
   writeln('============================================');
   writeln('|2| -      Biblioteca de mangas        - |2|');
   writeln('============================================');
   writeln('|3| -  Listado de animes mas vistos    - |3|');
   writeln('============================================');
   writeln('|4| -  Sinopsis de tu anime favorito   - |4|');
   writeln('============================================');
   writeln('|5| -       cerrar sesion              - |5|');
   writeln('============================================');
   writeln();
   writeln('---------------------------------------');
   writeln('Elija la opcion que usted desee:       ');
   writeln('---------------------------------------');
   readln(opcion);
   CASE opcion OF
      1:BEGIN
        clrscr;
        carga_animes();
        END;
      2:BEGIN
        clrscr;
        bibilioteca_de_mangas();
        END;
      3:BEGIN
        clrscr;
        animes_mas_vistos();
        END;
      4:BEGIN
        clrscr;
        informacion_anime();
        END;
     {5:BEGIN
        END; }
   END;
 UNTIL (opcion = 5);
 END;

FUNCTION clave_usuario_encontrado(cla_us:integer):boolean;
VAR
 flag:boolean;
 BEGIN
  flag:= false;
  reset(archivo_cuentas);
  REPEAT
   read(archivo_cuentas,registro_cuentas);
   IF cla_us = registro_cuentas.clave_usuario THEN
    flag:= true;
  UNTIL eof(archivo_cuentas) OR (flag = true);
  IF flag = true THEN
   clave_usuario_encontrado:= true
  ELSE
   clave_usuario_encontrado:= false;
 END;

FUNCTION busca_password(pass: string): boolean;
VAR
 f: boolean;
 BEGIN
  f:= false;
  REPEAT
   seek(archivo_cuentas,filepos(archivo_cuentas) - 1);
   read(archivo_cuentas,registro_cuentas);
   IF pass = registro_cuentas.contrasenia_usuario THEN
   f:= true;
  UNTIL eof(archivo_cuentas) OR (f = true);
  IF f = true THEN
   busca_password:= true
  ELSE
   busca_password:= false;
 END;

FUNCTION ingresar_password(): string;
VAR
 caracter,aux,password_completo: string;
 i:integer;
 BEGIN
 incializar;
 i:= 0;
 writeln('Ingresar password (maximo 10 caracteres): ');
 caracter:= readkey;
 WHILE caracter <> #13 DO
  BEGIN
   IF caracter <> #8 THEN
    BEGIN
     gotoxy(whereX,whereY);
     IF (whereX <= posX) OR (whereX = posX) THEN
     BEGIN
     write('*');
     i:= i + 1;
     pas[i]:= caracter;
     END;
    END
   ELSE
    BEGIN
    gotoxy(whereX - 1,whereY);
    write(' ', #8);
    pas[i]:='';
    IF (i >= 1) AND (i <= 10) THEN
     i:= i - 1
    ELSE
     i:= 0;
    END;
    caracter:= readkey;
  END;
  aux:='';
  FOR i:= 1 TO 10 DO
  BEGIN
  password_completo:=concat(aux,pas[i]);
  aux:= password_completo;
  END;
 ingresar_password:= password_completo;
 END;

PROCEDURE iniciar_sesion();
VAR
   cla_us: integer;
   pass: string;
 BEGIN
   IF verificar_estado_archivo_cuentas = true THEN
    BEGIN
     textcolor(lightred);
     writeln('============================================================================');
     writeln('|//////////////////////////////////////////////////////////////////////////|');
     writeln('|// Aun no hay registros de cuentas. Por lo tanto no se puede continuar ///|');
     writeln('|//////////////////////////////////////////////////////////////////////////|');
     writeln('============================================================================');
     writeln();
     delay(2000);
     clrscr;
    END
   ELSE
    BEGIN
    textcolor(lightgreen);
    writeln('/////////////////////////////');
    writeln('-----------------------------');
    writeln('Ingrese su clave de usuario: ');
    readln(cla_us);
    writeln('/////////////////////////////');
    writeln('-----------------------------');
    IF clave_usuario_encontrado(cla_us) = true THEN
     BEGIN
      vista_usuario:= cla_us;
      pass:= ingresar_password();
      IF busca_password(pass) = true THEN
      BEGIN
      textcolor(lightgreen);
      writeln();
      clrscr;
     gotoxy(whereX, whereY + 5);
     gotoxy(whereX + 25, whereY);
     writeln('==================================================');
     gotoxy(whereX + 25, whereY);
     writeln('||                               |\             ||');
     gotoxy(whereX + 25, whereY);
     writeln('||  _           _     _           \\            ||');
     gotoxy(whereX + 25, whereY);
     writeln('|| _-_  < \, ,._-_  / \\  < \, \\/\\  / \\  /\\ ||');
     gotoxy(whereX + 25, whereY);
     writeln('||||    /-||  ||   || ||  /-|| || || || || || ||||');
     gotoxy(whereX + 25, whereY);
     writeln('||||   (( ||  ||   || || (( || || || || || || ||||');
     gotoxy(whereX + 25, whereY);
     writeln('||\\,/  \/\\  \\,  \\_-|  \/\\ \\ \\  \\/  \\,/ ||');
     gotoxy(whereX + 25, whereY);
     writeln('||                  /  \                        ||');
     gotoxy(whereX + 25, whereY);
     writeln('||                 <---->                       ||');
     gotoxy(whereX + 25, whereY);
     writeln('==================================================');
     writeln();
      gotoxy(whereX + 10,  whereY);
      writeln('==========================================================================|');
      gotoxy(whereX + 10,  whereY);
      writeln('|*************************************************************************|');
      gotoxy(whereX + 10,  whereY);
      writeln('|** Ha iniciado la sesion correctamente! Sera llevado al menu principal **|');
      gotoxy(whereX + 10,  whereY);
      writeln('|*************************************************************************|');
      gotoxy(whereX + 10,  whereY);
      writeln('==========================================================================|');
      writeln();
      delay(2000);
      menu_principal();
      END
     ELSE
      BEGIN
      clrscr;
      textcolor(lightred);
      writeln();
      gotoxy(whereX, whereY + 5);
      gotoxy(whereX + 35,  whereY);
      writeln('==============================|');
      gotoxy(whereX + 35,  whereY);
      writeln('| _-_  ,._-_ ,._-_  /\\ ,._-_ |');
      gotoxy(whereX + 35,  whereY);
      writeln('||| \\  ||    ||   || ||  ||  |');
      gotoxy(whereX + 35,  whereY);
      writeln('|||/    ||    ||   || ||  ||  |');
      gotoxy(whereX + 35,  whereY);
      writeln('|\\,/   \\,   \\,  \\,/   \\, |');
      gotoxy(whereX + 35,  whereY);
      writeln('==============================|');
      writeln();
      gotoxy(whereX + 10,  whereY);
      writeln('================================================================================');
      gotoxy(whereX + 10,  whereY);
      writeln('|//////////////////////////////////////////////////////////////////////////////|');
      gotoxy(whereX + 10,  whereY);
      writeln('|// La contraseña es incorrecta. Se lo regresara al menu de acceso principal //|');
      gotoxy(whereX + 10,  whereY);
      writeln('|//////////////////////////////////////////////////////////////////////////////|');
      gotoxy(whereX + 10,  whereY);
      writeln('================================================================================');
      writeln();
      gotoxy(whereX + 35,  whereY);
      delay(2000);
      END
    END
   ELSE
    BEGIN
    clrscr;
    textcolor(lightred);
    gotoxy(whereX, whereY + 5);
    gotoxy(whereX + 35,  whereY);
    writeln('==============================|');
    gotoxy(whereX + 35,  whereY);
    writeln('| _-_  ,._-_ ,._-_  /\\ ,._-_ |');
    gotoxy(whereX + 35,  whereY);
    writeln('||| \\  ||    ||   || ||  ||  |');
    gotoxy(whereX + 35,  whereY);
    writeln('|||/    ||    ||   || ||  ||  |');
    gotoxy(whereX + 35,  whereY);
    writeln('|\\,/   \\,   \\,  \\,/   \\, |');
    gotoxy(whereX + 35,  whereY);
    writeln('==============================|');
    writeln();
    gotoxy(whereX + 10,  whereY);
    writeln('====================================================================================');
    gotoxy(whereX + 10,  whereY);
    writeln('|//////////////////////////////////////////////////////////////////////////////////|');
    gotoxy(whereX + 10,  whereY);
    writeln('|// Clave de usuario no encontrado. Se lo regresara al menu de acceso principal ///|');
    gotoxy(whereX + 10,  whereY);
    writeln('|//////////////////////////////////////////////////////////////////////////////////|');
    gotoxy(whereX + 10,  whereY);
    writeln('====================================================================================');
    writeln();
    gotoxy(whereX + 35,  whereY);
    delay(2000);
    END
   END;
 END;

FUNCTION busca_password_usuario(password_completo: string): boolean;
VAR
 f: boolean;
 BEGIN
  f:= false;
  REPEAT
   seek(archivo_cuentas,filepos(archivo_cuentas) - 1);
   read(archivo_cuentas,registro_cuentas);
   IF password_completo = registro_cuentas.contrasenia_usuario THEN
   f:= true;
  UNTIL eof(archivo_cuentas) OR (f = true);
  IF f = true THEN
   busca_password_usuario:= true
  ELSE
   busca_password_usuario:= false;
 END;

PROCEDURE crear_password();
VAR
 caracter,aux,password_completo: string;
 i:integer;
 BEGIN
 incializar;
 i:= 0;
 writeln('Cree password (maximo 10 caracteres): ');
 caracter:= readkey;
 WHILE caracter <> #13 DO
  BEGIN
   IF caracter <> #8 THEN
    BEGIN
     gotoxy(whereX,whereY);
     IF (whereX <= posX) OR (whereX = posX) THEN
     BEGIN
     write(caracter);
     i:= i + 1;
     pas[i]:= caracter;
     END;
    END
   ELSE
    BEGIN
    gotoxy(whereX - 1,whereY);
    write(' ', #8);
    pas[i]:='';
    IF (i >= 1) AND (i <= 10) THEN
     i:= i - 1
    ELSE
     i:= 0;
    END;
    caracter:= readkey;
  END;
  aux:='';
  FOR i:= 1 TO 10 DO
  BEGIN
  password_completo:=concat(aux,pas[i]);
  aux:= password_completo;
  END;
  IF busca_password_usuario(password_completo) = true THEN
   BEGIN
   textcolor(lightred);
   writeln();
   writeln();
   clrscr;
   writeln('|========================================|');
   writeln('|////////////////////////////////////////|');
   writeln('|// Password de usuario ya registrado. //|');
   writeln('|////////////////////////////////////////|');
   writeln('|========================================|');
   writeln();
   END
  ELSE
   BEGIN
   registro_cuentas.contrasenia_usuario:= password_completo;
   seek(archivo_cuentas,filesize(archivo_cuentas));
   write(archivo_cuentas,registro_cuentas);
   writeln();
   writeln();
   textcolor(lightgreen);
   clrscr;
   writeln('=================================');
   writeln('*********************************');
   writeln('**** CUENTA CREADA CON EXITO ****');
   writeln('*********************************');
   writeln('=================================');
   END;
 END;

FUNCTION busca_numero_usuario(numero_usuario: integer): boolean;
VAR
 f: boolean;
 BEGIN
  f:= false;
  REPEAT
   read(archivo_cuentas,registro_cuentas);
   IF numero_usuario = registro_cuentas.clave_usuario then
    f:= true;
  UNTIL eof(archivo_cuentas) OR (f = true);
  IF f = true then
   busca_numero_usuario:= true
  ELSE
   busca_numero_usuario:= false;
 END;

PROCEDURE crear_password_nuevo();
VAR
 caracter,aux,password_completo: string;
 i:integer;
 BEGIN
 incializar;
 i:= 0;
 writeln('Cree password (maximo 10 caracteres): ');
 caracter:= readkey;
 WHILE caracter <> #13 DO
  BEGIN
   IF caracter <> #8 THEN
    BEGIN
     gotoxy(whereX,whereY);
     IF (whereX <= posX) OR (whereX = posX) THEN
     BEGIN
     write('*');
     i:= i + 1;
     pas[i]:= caracter;
     END;
    END
   ELSE
    BEGIN
    gotoxy(whereX - 1,whereY);
    write(' ', #8);
    pas[i]:='';
    IF (i >= 1) AND (i <= 10) THEN
     i:= i - 1
    ELSE
     i:= 0;
    END;
    caracter:= readkey;
  END;
  aux:='';
  FOR i:= 1 TO 10 DO
  BEGIN
  password_completo:=concat(aux,pas[i]);
  aux:= password_completo;
  END;
  registro_cuentas.contrasenia_usuario:= password_completo;
  seek(archivo_cuentas,filesize(archivo_cuentas));
  write(archivo_cuentas,registro_cuentas);
  writeln();
  writeln();
  clrscr;
  textcolor(lightgreen);
  writeln('=================================');
  writeln('*********************************');
  writeln('**** CUENTA CREADA CON EXITO ****');
  writeln('*********************************');
  writeln('=================================');
  delay(2000);
 END;

FUNCTION estado_archivo_cuentas(): boolean;  //VERIFICA QUE EL ARCHIVO CUENTAS.DAT ESTE VACIO PARA ASI PODER AGREGAR UN PRIMER REGISTRO.
 BEGIN                                      //ES NECESARIO, YA QUE SI EL NUMERO DE USUARIO SE INGRESA Y HACE UNA BUSQUEDA PARA VER SI EXISTE, LO HARA EN UN ARCHIVO VACIO, LO CUAL
  IF filesize(archivo_cuentas) = 0 THEN    // DARA UN ERROR.
   estado_archivo_cuentas:= true
 ELSE
   estado_archivo_cuentas:= false;
 END;

PROCEDURE registrarse();
VAR
 numero_usuario: integer;
 BEGIN
  clrscr;
  textcolor(lightgreen);
  reset(archivo_cuentas);
  IF estado_archivo_cuentas = true then
   BEGIN
   writeln('----------------------------------');
   writeln('//////////////////////////////////');
   writeln('----------------------------------');
   write('Cree numero de usuario: ');
   readln(numero_usuario);
   registro_cuentas.clave_usuario:= numero_usuario;
   writeln();
   crear_password_nuevo();
   END
  ELSE
   BEGIN
   writeln('----------------------------------');
   writeln('//////////////////////////////////');
   writeln('----------------------------------');
   write('Cree numero de usuario: ');
   readln(numero_usuario);
   IF busca_numero_usuario(numero_usuario) = true THEN
    BEGIN
    writeln();
    textcolor(lightred);
    clrscr;
    writeln('|======================================|');
    writeln('|//////////////////////////////////////|');
    writeln('|// Numero de usuario ya registrado. //|');
    writeln('|//////////////////////////////////////|');
    writeln('|======================================|');
    delay(2000);
    END
   ELSE
    BEGIN
    registro_cuentas.clave_usuario:= numero_usuario;
    writeln();
    crear_password();
    END
    END;
    close(archivo_cuentas);
   textcolor(lightgreen);
 END;

PROCEDURE mostrar_archivo_cuentas;
 BEGIN
  reset(archivo_cuentas);
  while not eof(archivo_cuentas) do
   begin
    read(archivo_cuentas,registro_cuentas);
    writeln(registro_cuentas.clave_usuario,registro_cuentas.contrasenia_usuario);
   end;
  close(archivo_cuentas);
 END;

PROCEDURE acceso_principal();
VAR
 opcion: integer;
 BEGIN
 REPEAT
  clrscr;
  gotoxy(whereX + 5,whereY);
  textcolor(green);
  writeln('|============================================================================================|');
  gotoxy(whereX + 5,whereY);
  writeln('|********************************************************************************************|');
  textcolor(brown);
  gotoxy(whereX + 5,whereY);
  writeln('|============================================================================================|');
  gotoxy(whereX + 5,whereY);
  writeln('|                                                 |\                                         |');
  gotoxy(whereX + 5,whereY);
  writeln('|  _          *                        _           \\                   _           _     _  |');
  gotoxy(whereX + 5,whereY);
  writeln('| < \, \\/\\ \\ \\/\\/\\  _-_         < \, \\/\\  / \\       \\/\\/\\  < \, \\/\\  / \\  < \ |');
  gotoxy(whereX + 5,whereY);
  writeln('| /-|| || || || || || || || \\        /-|| || || || ||       || || ||  /-|| || || || ||  /-|||');
  gotoxy(whereX + 5,whereY);
  writeln('|(( || || || || || || || ||/         (( || || || || ||       || || || (( || || || || || (( |||');
  gotoxy(whereX + 5,whereY);
  writeln('| \/\\ \\ \\ \\ \\ \\ \\ \\,/         \/\\ \\ \\  \\/        \\ \\ \\  \/\\ \\ \\ \\_-|  \/\\|');
  gotoxy(whereX + 5,whereY);
  writeln('|                                                                                  /  \      |');
  gotoxy(whereX + 5,whereY);
  writeln('|                                                                                 <---->     |');
  gotoxy(whereX + 5,whereY);
  writeln('|============================================================================================|');
  textcolor(green);
  gotoxy(whereX + 5,whereY);
  writeln('|********************************************************************************************|');
  gotoxy(whereX + 5,whereY);
  writeln('|============================================================================================|');
  writeln();
  textcolor(brown);
  gotoxy(whereX + 35,whereY);
  writeln('=======================');
  gotoxy(whereX + 35,whereY);
  writeln('| 1 INICIAR SESION  1 |');
  gotoxy(whereX + 35,whereY);
  writeln('=======================');
  gotoxy(whereX + 35,whereY);
  writeln('| 2   REGISTRESE    2 |');
  gotoxy(whereX + 35,whereY);
  writeln('=======================');
  gotoxy(whereX + 35,whereY);
  writeln('| 3     SALIR       3 |');
  gotoxy(whereX + 35,whereY);
  writeln('=======================');
  writeln();
  gotoxy(whereX + 28,whereY);
  textcolor(lightblue);
  writeln('--------------------------------------');
  gotoxy(whereX + 28,whereY);
  write('Escoja una opcion para poder avanzar: ');
  readln(opcion);
  CASE opcion OF
    1:begin
       clrscr;
       iniciar_sesion;
      END;
    2:BEGIN
       clrscr;
       registrarse;
      END;
    3:BEGIN
      clrscr;
      mostrar_archivo_cuentas;
      END;
  END;
 UNTIL (opcion = 3);
 END;

PROCEDURE pantalla_carga();
VAR
 i: integer;
 BEGIN
 i:= 0;
 REPEAT
 clrscr;
 textcolor(green);
 i:= i + 1;
 gotoxy(whereX, whereY + 10);
 delay(90);
 gotoxy(whereX + 25, whereY);
 writeln('=====================================================');
 delay(90);
 gotoxy(whereX + 25,  whereY);
 writeln('||                                    |\          ||');
 delay(90);
  gotoxy(whereX + 25, whereY);
 writeln('||       _           _     _           \\         ||');
 delay(90);
 gotoxy(whereX + 25,  whereY);
 writeln('|| _-_  < \, ,._-_  / \\  < \, \\/\\  / \\  /\\   ||');
 delay(90);
 gotoxy(whereX + 25,  whereY);
 writeln('|| ||    /-||  ||   || ||  /-|| || || || || || || ||');
 delay(90);
 gotoxy(whereX + 25,  whereY);
 writeln('|| ||   (( ||  ||   || || (( || || || || || || || ||');
 delay(90);
 gotoxy(whereX + 25,  whereY);
 writeln('|| \\,/  \/\\  \\,  \\_-|  \/\\ \\ \\  \\/  \\,/  ||');
 delay(90);
 gotoxy(whereX + 25,  whereY);
 writeln('||                  /  \                          ||');
 delay(90);
 gotoxy(whereX + 25,  whereY);
 writeln('||                 <---->                         ||');
 delay(90);
 gotoxy(whereX + 25,  whereY);
 writeln('====================================================');
 Delay(500);
 UNTIL (i = 5);
 END;

BEGIN
assign(archivo_cuentas,'archivo_cuentas.dat');
assign(archivo_animes,'archivos_animes.dat');
assign(archivo_mangas,'archivos_mangas.dat');
assign(archivo_clientes,'archivo_clientes.dat');
crear_archivo_cuentas();
crear_archivo_animes();
crear_archivo_mangas();
crear_archivo_clientes();
pantalla_carga();
acceso_principal();
readkey;
END.



