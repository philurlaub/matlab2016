function varargout = TSP_Gui2(varargin)
% TSP_GUI2 MATLAB code for TSP_Gui2.fig
%      TSP_GUI2, by itself, creates a new TSP_GUI2 or raises the existing
%      singleton*.
%
%      H = TSP_GUI2 returns the handle to a new TSP_GUI2 or the handle to
%      the existing singleton*.
%
%      TSP_GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TSP_GUI2.M with the given input arguments.
%
%      TSP_GUI2('Property','Value',...) creates a new TSP_GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TSP_Gui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TSP_Gui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TSP_Gui2

% Last Modified by GUIDE v2.5 20-Jun-2016 15:55:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TSP_Gui2_OpeningFcn, ...
                   'gui_OutputFcn',  @TSP_Gui2_OutputFcn, ...
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


% --- Executes just before TSP_Gui2 is made visible.
function TSP_Gui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TSP_Gui2 (see VARARGIN)

% Choose default command line output for TSP_Gui2
handles.output = hObject;
handles.matrix = [0 7 6 9 11 10 6 4 8;
 7 0 4 7 9 14 13 11 14;
 6 4 0 3 5 10 12 10 10;
 9 7 3 0 5 10 13 13 12;
 11 9 5 5 0 5 8 11 7;
 10 14 10 10 5 0 4 7 6;
 6 13 12 13 8 4 0 3 2;
 4 11 10 13 11 7 3 0 5;
 8 14 10 12 7 6 2 5 0];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TSP_Gui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TSP_Gui2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the mat-file');
file = load(FileName)
handles.matrix = cell2mat(struct2cell(file))
set(handles.edit1, 'String', 'Data input finished!');
guidata(hObject, handles);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = figure;
t = uitable(f, 'Data', handles.matrix);
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TSP_helper;
alg = get(handles.popupmenu1, 'String'); 

[valid, msg] = checkMatrix(handles.matrix);
if(valid)
    set(handles.edit1, 'String', sprintf('%s!',alg{get(handles.popupmenu1, 'Value')}));
else
    set(handles.edit1, 'String', sprintf('%s!\n\n%s',alg{get(handles.popupmenu1, 'Value')}, msg));
end

switch (alg{get(handles.popupmenu1, 'Value')})
    case 'Brute Force'
          [t, tl, p] = TSP_BruteForce(handles.matrix);
                 
          if(tl == -1)
             text = get(handles.edit1, 'String');
             errorMsg = 'No valid tour found!!!';
             set(handles.edit1, 'String', sprintf('%s \n\n%s', text, errorMsg)); 
          end
          
          set(handles.text5, 'String', sprintf('Execution time: %f', p));
          set(handles.text6, 'String', sprintf('Tour length: %d', tl));
          set(handles.text7, 'String', sprintf('Tour: %s', sprintf('%d ', t)));
    
    case 'Integer Programming'
        
        [tour, tourlenght, processtime, solutiongab] = TSP_IntegerProgramm(handles.matrix);
        tourString = getTourStringFromIntegerProgrammTour(tour);
        
        set(handles.text5, 'String', sprintf('Execution time: %f', processtime));
        set(handles.text6, 'String', sprintf('Tour length: %f', tourlenght));
        set(handles.text7, 'String', sprintf('Tour: %s', sprintf('%d ', tourString)));


        drawTsp(tour, example3_coordinates, handles.axes1);
         

    case 'Best Successor'
          [t, tl, p] = TSP_BestSuccessor(handles.matrix);
          
          if(tl == -1)
             text = get(handles.edit1, 'String');
             errorMsg = 'No valid Tour found!!!';
             set(handles.edit1, 'String', sprintf('%s \n\n%s', text, errorMsg)); 
          end
          
          set(handles.text5, 'String', sprintf('Execution time: %f', p));
          set(handles.text6, 'String', sprintf('Tour length: %d', tl));
          set(handles.text7, 'String', sprintf('Tour: %s', sprintf('%d ', t)));
        
    case 'Christofides'
      try
          [mst, oddEdges, t, tl, p] = TSP_Christofides(handles.matrix);
          
          if(tl == -1)
             cs = get(handles.edit1, 'String');
             errorMsg = 'Matrix does not satisfy the triangle inequality!!!';
             set(handles.edit1, 'String', sprintf('%s \n\n%s', cs, errorMsg)); 
          end
          set(handles.text5, 'String', sprintf('Execution time: %f', p));
          set(handles.text6, 'String', sprintf('Tour length: %d', tl));
          set(handles.text7, 'String', sprintf('Tour: %s', sprintf('%d ', t)));
      catch ex
          msgText = getReport(ex);
          w = warndlg(msgText);
      end
    case 'Opt2'
        
           prompt = {'Enter Start Tour:'};
           dlg_titel = 'Start Tour Input';
           num_lines = 1;
           input = inputdlg(prompt, dlg_titel, num_lines);
           
           if(~isempty(input{1}))
              start = str2num(input{1});
           else
              start = TSP_BestSuccessor(handles.matrix);
           end
                     
          [t, tl, p] = TSP_2opt(start, handles.matrix);
          
          cs = get(handles.edit1, 'String');
          st = '';
          if(tl == -1)
              msg = 'Start tour includes to less or to much nodes!';
              st = sprintf('Start Tour: %s\n\n%s', sprintf('%d ', start), msg);
          else
              st = sprintf('Start Tour: %s', sprintf('%d ', start));
          end
          set(handles.edit1, 'String', sprintf('%s \n\n%s', cs, st));
          
          set(handles.text5, 'String', sprintf('Execution time: %f', p));
          set(handles.text6, 'String', sprintf('Tour length: %d', tl));
          set(handles.text7, 'String', sprintf('Tour: %s', sprintf('%d ', t)));
          
    case 'Opt3'
        
           prompt = {'Enter Start Tour:'};
           dlg_titel = 'Start Tour Input';
           num_lines = 1;
           input = inputdlg(prompt, dlg_titel, num_lines);
           
           if(~isempty(input{1}))
              start = str2num(input{1});
           else
              [start, a, c]  = TSP_BestSuccessor(handles.matrix);
           end
                    
          [t, tl, p] = TSP_3opt(start, handles.matrix);
          
          cs = get(handles.edit1, 'String');
          st = '';
          if(tl == -1)
              msg = 'Start tour includes to less or to much nodes!';
              st = sprintf('Start Tour: %s\n\n%s', sprintf('%d ', start), msg);
          else
              st = sprintf('Start Tour: %s', sprintf('%d ', start));
          end
          set(handles.edit1, 'String', sprintf('%s \n\n%s', cs, st));
          
           
          set(handles.text5, 'String', sprintf('Execution time: %f', p));
          set(handles.text6, 'String', sprintf('Tour length: %d', tl));
          set(handles.text7, 'String', sprintf('Tour: %s', sprintf('%d ', t)));
          
    case 'Run All'
          TSP_RunAll(handles.matrix, handles.edit1, handles.axes1);
          
        
    otherwise
        printToGui(app, 'Error: please select a algorithm!');
end
guidata(hObject, handles);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
