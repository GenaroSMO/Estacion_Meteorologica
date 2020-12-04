function varargout = ej3(varargin)
% EJ3 MATLAB code for ej3.fig
%      EJ3, by itself, creates a new EJ3 or raises the existing
%      singleton*.
%
%      H = EJ3 returns the handle to a new EJ3 or the handle to
%      the existing singleton*.
%
%      EJ3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EJ3.M with the given input arguments.
%
%      EJ3('Property','Value',...) creates a new EJ3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ej3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ej3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ej3

% Last Modified by GUIDE v2.5 07-Feb-2019 21:30:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ej3_OpeningFcn, ...
                   'gui_OutputFcn',  @ej3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ej3 is made visible.
function ej3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ej3 (see VARARGIN)

% Choose default command line output for ej3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ej3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ej3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function puerto_Callback(hObject, eventdata, handles)
% hObject    handle to puerto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of puerto as text
%        str2double(get(hObject,'String')) returns contents of puerto as a double


% --- Executes during object creation, after setting all properties.
function puerto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to puerto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in inicia.
function inicia_Callback(hObject, eventdata, handles)
% funcion iniciar
 global encendido
global puertoComunicacion
global s
global d
d=0;
%Obtenemos la cadena de caracteres que hay en el objeto puerto.
puertoComunicacion=get(handles.puerto, 'string')
%Eliminamos cualquier puerto de comunicación con el nombre deseado.
delete(instrfind({'Port'},{puertoComunicacion}));
%Declaramos al puerto serial con velocidad de 9600 baudios
s = serial(puertoComunicacion,'BaudRate', 9600,'Terminator','CR/LF');
%Enviamos un mensaje de error si no se encuentra el puerto
warning('off','MATLAB:serial:fscanf:unsuccessfulRead');
%Abrimos el puerto Serial
fopen(s);
%Actvamos una bandera que se ha abierto el puerto Serial
encendido=1
fprintf('d: %d \n',d);

% --- Executes on button press in apagar.
function apagar_Callback(hObject, eventdata, handles)
% Apagaremos la conececion con la targeta
global encendido
global puertoComunicacion
global s

%Preguntamos si el botón de conectado se ha presionado
if(encendido==1)
%Cerramos el puerto Serial
fclose(s);
%Eliminamos cualquier puerto de comunicación con el nombre deseado.
delete(instrfind({'Port'},{puertoComunicacion}));
%Desactivamos la bandera encendido
encendido=0;
fprintf('puerto de comunicacion apagado \n');


end

% --- Executes on button press in medir.
function medir_Callback(hObject, eventdata, handles)
% hObject    handle to medir (see GCBO) 
global encendido 
global s 
global d;
%Preguntamos si el botón de conectado se ha presionado 
if encendido==1 
%Leemos el valor del tiempo total de la caja de texto de tiempo. 
tiempoMaximo=str2double(get(handles.tiempo, 'string')); 
%Leemos el valor del tiempo total de la caja de texto de muestreo. 
tiempoMuestreo=0.5; 
%Inicializamos los multiplos del tiempo de Muestreo 
multiplo=0;
i=1; 

%variables de aron
wp=str2num(get(handles.Wp_Valor,'String'));
ws=str2num(get(handles.Ws_Valor,'String'));
rp=str2num(get(handles.Rp_Valor,'String'));
rs=str2num(get(handles.Rs_Valor,'String'));
muestras=str2num(get(handles.Muestras,'String'));
ruido=str2num(get(handles.Ruido,'String'));

con_ruido=[]; 
media_movil=[];
inicio=1;
fin=muestras;
%fin

%Inicializamos el vector con las divisiones de tiempo 
t=zeros(1, tiempoMaximo/tiempoMuestreo); 
%Inicializamos el vector donde se guaradaran los datos, 
%con base a las divisiones de tiempo. 
senal=zeros(1, tiempoMaximo/tiempoMuestreo);
%Inicializamos el temporizador.
tic;
%Inicializamos el ciclo de recopilación de datos.
while ((toc<=tiempoMaximo) )
    %Tiempo subindice i es igual al valor e tiempo en
    %el justo instante del temporizador.
    if (d ~= 0)
        break;
    end
    t(i)=toc;
    %Verificamos los mutliplos de muestreo para realizar la lectura.
    if multiplo<=t(i)
        
        %Escribimos en el puerto seria un caracter 'l' de lectura. fwrite(s, 'l');
        %Leemos el dato entrante en el puerto Serial.
        dato=fscanf(s, '%d');
        if(dato >= 0 && dato <=100 )
            
            fprintf('***************** %d Segundo **************  \n',(i/2));
            %imprimimos edato
            fprintf('humedad: %d \n',dato);
            %hacemos calculo del ruido blanco
            con_ruido=[con_ruido,(dato+wgn(1,1,ruido))];
            fprintf('Ruido: %d \n',(dato+wgn(1,1,ruido)));
        
        
            %Ajustamos el dato entre un valor de 0 a 50.
            senal(i)=dato;
            %Incrementamos el multiplo.
            multiplo=multiplo+tiempoMuestreo;
            %Nos auxiliamos de 2 vectores que graficarán los datos
            %recopilados hasta el valor del subindice i.
            for a=1:i
                t_Auxilar(a)=t(a);
                senal_Auxiliar(a)= senal(a);
            
            end
            %Accedemos a la pantalla1 y graficamos la señal original.
        
            axes(handles.pantalla1);        
            plot(handles.pantalla1,t_Auxilar, senal_Auxiliar, 'Color','r','LineWidth',2);        
            set(handles.pantalla1, 'XLim',[0 tiempoMaximo],'YLim',[0 100]);
        
        
            %Acedemos a la pantalla 2 y graficamos la señal con ruido
            axes(handles.pantalla2);   
            plot(handles.pantalla2,t_Auxilar, con_ruido, 'Color','r','LineWidth',2);
            set(handles.pantalla2, 'XLim',[0 tiempoMaximo],'YLim',[0 90]);
        
        
        
            %accedemosa la pantalla 3 y graficamos
            axes(handles.pantalla3);
            plot(handles.pantalla3,t_Auxilar, senal_Auxiliar, 'Color','r','LineWidth',2);
            set(handles.pantalla3, 'XLim',[0 tiempoMaximo],'YLim',[0 100]);
            hold on     
            
            if(length(con_ruido) >= muestras)
                media_movil=[media_movil,mean(con_ruido(inicio:fin))];
                fprintf('media: %d \n',mean(con_ruido(inicio:fin)))
                inicio=inicio+1;
                fin=fin+1;
                fprintf('t_Auxilar: %d \n',t_Auxilar(i));
               
                %plot(handles.pantalla3,(muestras:0.5:t_Auxilar+0.5), media_movil, 'Color','g','LineWidth',2);
                plot(handles.pantalla3,t_Auxilar, media_movil, 'Color','g','LineWidth',2);
                set(handles.pantalla3, 'XLim',[muestras tiempoMaximo],'YLim',[0 100]);
            else
                fprintf('t_Auxilar: %d \n',t_Auxilar(i));
                fprintf('media_movil: 0 \n');
                 media_movil=[media_movil,0];
                 plot(handles.pantalla3,t_Auxilar, media_movil, 'Color','g','LineWidth',2);
                set(handles.pantalla3, 'XLim',[muestras tiempoMaximo],'YLim',[0 100]);
            end
        
            %accedemos a la panatalla 4 y graficamos la señal original vs butterworth
            axes(handles.pantalla4);
            plot(handles.pantalla4,t_Auxilar, senal_Auxiliar, 'Color','r','LineWidth',2);
            set(handles.pantalla4, 'XLim',[0 tiempoMaximo],'YLim',[0 100]);
            hold on  
            
            [n,wn]=buttord(wp,ws,rp,rs);
            
            [num,den]=butter(n,wn,'low');
            butterworth=filter(num,den,con_ruido);
            %fprintf('t_Auxilar: %d \n',t_Auxilar(i));
            plot(handles.pantalla4,t_Auxilar, (butterworth), 'Color','g','LineWidth',2);
            set(handles.pantalla4, 'XLim',[0 tiempoMaximo],'YLim',[0 100]);
         
            
            %Incrementamos el subíndice i.
            i=i+1;
        end
    end
    
end 




axes(handles.pantalla5);
plot(handles.pantalla5,t_Auxilar,fft(senal_Auxiliar), 'Color','r','LineWidth',2); 
set(handles.pantalla5, 'XLim',[0 tiempoMaximo])
hold on
plot(handles.pantalla5,t_Auxilar,fft(media_movil), 'Color','g','LineWidth',2); 
set(handles.pantalla5, 'XLim',[0 tiempoMaximo])
hold off


axes(handles.pantalla6);
plot(handles.pantalla6,t_Auxilar,fft(senal_Auxiliar), 'Color','r','LineWidth',2);
set(handles.pantalla6, 'XLim',[0 tiempoMaximo])
hold on
plot(handles.pantalla6,t_Auxilar,fft(butterworth), 'Color','g','LineWidth',2); 
set(handles.pantalla6, 'XLim',[0 tiempoMaximo],'YLim')
hold off


end


function tiempo_Callback(hObject, eventdata, handles)
% hObject    handle to tiempo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tiempo as text
%        str2double(get(hObject,'String')) returns contents of tiempo as a double


% --- Executes during object creation, after setting all properties.
function tiempo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tiempo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Muestras_Callback(hObject, eventdata, handles)
% hObject    handle to Muestras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Muestras as text
%        str2double(get(hObject,'String')) returns contents of Muestras as a double


% --- Executes during object creation, after setting all properties.
function Muestras_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Muestras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ruido_Callback(hObject, eventdata, handles)
% hObject    handle to Ruido (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ruido as text
%        str2double(get(hObject,'String')) returns contents of Ruido as a double


% --- Executes during object creation, after setting all properties.
function Ruido_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ruido (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Wp_Valor_Callback(hObject, eventdata, handles)
% hObject    handle to Wp_Valor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Wp_Valor as text
%        str2double(get(hObject,'String')) returns contents of Wp_Valor as a double


% --- Executes during object creation, after setting all properties.
function Wp_Valor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Wp_Valor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ws_Valor_Callback(hObject, eventdata, handles)
% hObject    handle to Ws_Valor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ws_Valor as text
%        str2double(get(hObject,'String')) returns contents of Ws_Valor as a double


% --- Executes during object creation, after setting all properties.
function Ws_Valor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ws_Valor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rs_Valor_Callback(hObject, eventdata, handles)
% hObject    handle to Rs_Valor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rs_Valor as text
%        str2double(get(hObject,'String')) returns contents of Rs_Valor as a double


% --- Executes during object creation, after setting all properties.
function Rs_Valor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rs_Valor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rp_Valor_Callback(hObject, eventdata, handles)
% hObject    handle to Rp_Valor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rp_Valor as text
%        str2double(get(hObject,'String')) returns contents of Rp_Valor as a double


% --- Executes during object creation, after setting all properties.
function Rp_Valor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rp_Valor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Detener.
function Detener_Callback(hObject, eventdata, handles)
global d;

d=1;
fprintf('d: %d \n',d);
% hObject    handle to Detener (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Leer_Archivo.
function Leer_Archivo_Callback(hObject, eventdata, handles)
wp=str2num(get(handles.Wp_Valor,'String'));
ws=str2num(get(handles.Ws_Valor,'String'));
rp=str2num(get(handles.Rp_Valor,'String'));
rs=str2num(get(handles.Rs_Valor,'String'));
muestras=str2num(get(handles.Muestras,'String'));
ruido=str2num(get(handles.Ruido,'String'));



%original
archivo=load('dato.txt');
n=length(archivo);
%con ruido
con_ruido=archivo+wgn(1,n,ruido);

%Butterworth
[n,wn]=buttord(wp,ws,rp,rs);
[num,den]=butter(n,wn,'low');
butterworth=filter(num,den,con_ruido);

%FFT GRAFICAR ORIGINAL vs MEDIA MOVIL
t_original=1:0.5:length(archivo);
arreglo=(1/muestras)*ones(1,muestras);
media_movil=conv(arreglo,archivo);


%Graficar fourier media movil vs original
axes(handles.pantalla1);
plot(handles.pantalla1,archivo, 'Color','r','LineWidth',2); 

%graficar con ruido
axes(handles.pantalla2);
plot(handles.pantalla2,con_ruido, 'Color','g','LineWidth',2); 


%graficar media movil vs original
axes(handles.pantalla3);
plot(handles.pantalla3,archivo, 'Color','r','LineWidth',2); 
hold on
plot(handles.pantalla3,media_movil, 'Color','g','LineWidth',2); 
hold off

%graficar butterworth vs orignal
axes(handles.pantalla4);
plot(handles.pantalla4,archivo, 'Color','r','LineWidth',2); 
hold on
plot(handles.pantalla4,butterworth, 'Color','g','LineWidth',2); 
hold off




%Graficar fourier media movil vs original
axes(handles.pantalla5);
plot(handles.pantalla5,fft(archivo), 'Color','r','LineWidth',2); 
hold on
plot(handles.pantalla5,fft(media_movil), 'Color','g','LineWidth',2); 
hold off




% graficar fft original butterworth
axes(handles.pantalla6);
plot(handles.pantalla6,fft(archivo), 'Color','r','LineWidth',2);
hold on
plot(handles.pantalla6,fft(butterworth), 'Color','g','LineWidth',2); 
hold off
