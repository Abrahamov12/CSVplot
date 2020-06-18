function varargout = CSVPlot(varargin)
% CSVPLOT MATLAB code for CSVPlot.fig
%      CSVPLOT, by itself, creates a new CSVPLOT or raises the existing
%      singleton*.
%
%      H = CSVPLOT returns the handle to a new CSVPLOT or the handle to
%      the existing singleton*.
%
%      CSVPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSVPLOT.M with the given input arguments.
%
%      CSVPLOT('Property','Value',...) creates a new CSVPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CSVPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CSVPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CSVPlot

% Last Modified by GUIDE v2.5 03-Aug-2018 16:41:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CSVPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @CSVPlot_OutputFcn, ...
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


% --- Executes just before CSVPlot is made visible.
function CSVPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CSVPlot (see VARARGIN)

% Choose default command line output for CSVPlot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CSVPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CSVPlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( '*.csv' );
fileID = fopen( [pathname,filename] );
% h = waitbar(0,'Please wait...');

allText = textscan(fileID,'%s','delimiter','\n');
numberOfLines = length(allText{1});
frewind(fileID);

T = readtable([pathname,filename],'Delimiter',',','Format','%q%f%f');
h = waitbar(0,'Please wait...');
preassureTime      = T{1, 1};
preassureCurrent   = T{1, 2};
preassureTarget    = T{1, 3};
temperatureTime    = T{2, 1};
temperatureCurrent = T{2, 2};
temperatureTarget  = T{2, 3};
i = 2;
while i < numberOfLines-1
    temperatureTime    = [temperatureTime,    T{i, 1}];
    temperatureCurrent = [temperatureCurrent, T{i, 2}];
    temperatureTarget  = [temperatureTarget,  T{i, 3}];
    waitbar(i/numberOfLines,h)
    i = i + 1 ;
    preassureTime      = [preassureTime,      T{i, 1}];
    preassureCurrent   = [preassureCurrent,   T{i, 2}];
    preassureTarget    = [preassureTarget,    T{i, 3}];
    waitbar(i/numberOfLines,h)
    i = i + 1;
end
handles.y2  = datetime(temperatureTime','Format','HH:mm:ss');
handles.x21 = temperatureCurrent';
handles.x22  = temperatureTarget';
handles.y1  = datetime(preassureTime','Format','HH:mm:ss:SSS');
handles.x11   = preassureCurrent';
handles.x12    = preassureTarget';
fclose(fileID);
close(h)

guidata(hObject, handles)

set(handles.text2, 'Visible', 0); %hide help

ax1 = subplot(2,1,1); % temperature
plot(handles.y1,handles.x11)
hold;
plot (handles.y1,handles.x12)
xlabel('Время') 
ylabel('Температура, C\circ') 
grid on

ax2 = subplot(2,1,2); % preassure
plot(handles.y2,handles.x21)
hold;
plot (handles.y2,handles.x22)
xlabel('Время') 
ylabel('Давление, мм рт.ст.') 
grid on
clear T;


% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all
close all


% --------------------------------------------------------------------
function View_Callback(hObject, eventdata, handles)
% hObject    handle to View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Plot_Temperature_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Temperature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(2)
plot(handles.y1,handles.x11)
hold
plot (handles.y1,handles.x12)
xlabel('Время') 
ylabel('Температура, C\circ') 
grid on

% --------------------------------------------------------------------
function Plot_Preassure_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Preassure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(1)
plot(handles.y2,handles.x21)
hold
plot (handles.y2,handles.x22)
xlabel('Время') 
ylabel('Давление, мм рт.ст.') 
grid on

% --------------------------------------------------------------------
function Plot_Both_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Both (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(3)
ax1 = subplot(2,1,1); % preassure
plot(handles.y1,handles.x11)
hold
plot (handles.y1,handles.x12)
xlabel('Время') 
ylabel('Температура, C\circ') 
grid on

ax2 = subplot(2,1,2); % preassure
plot(handles.y2,handles.x21)
hold
plot (handles.y2,handles.x22)
xlabel('Время') 
ylabel('Давление, мм рт.ст.') 
grid on
