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
handles.matrix = [];

handles.coordinates = [];

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
set(handles.edit1, 'String', 'Matrix loaded!');
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the mat-file');
file = load(FileName)
handles.coordinates = cell2mat(struct2cell(file))
set(handles.edit1, 'String', 'Coordinates loaded!');
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f = figure;
t = uitable(f,'unit','normalized', 'Position',[0 0 1 1], 'Data', handles.matrix);
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try

if(isempty(handles.matrix) || isempty(handles.coordinates))
    warndlg('The Matrix and/or the Coordinates are missing!');
    return;
end

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
        % reset axes
         cla(handles.axes1);
         
         if size(handles.matrix, 1) < 11
           try
               % run algorithm
              [t, tl, p] = TSP_BruteForce(handles.matrix);

              % Exception Handling: No valid tour
              if(tl == -1)
                 text = get(handles.edit1, 'String');
                 errorMsg = 'No valid tour found!!!';
                 set(handles.edit1, 'String', sprintf('%s \n\n%s', text, errorMsg)); 
              end

              %output
              set(handles.text5, 'String', sprintf('Execution time: %f', p));
              set(handles.text6, 'String', sprintf('Tour length: %f', tl));
              set(handles.text7, 'String', sprintf('Tour: %s', sprintf('%d ', t)));

              % draw Tour
              tour=[];
              for(f = 1 : length(t)-1)
                  tour=[tour; t(f) t(f+1)];
              end
              drawTsp(tour, handles.coordinates, handles.axes1);
              
          catch 
              warndlg('An Exception occured!');
          end
        else
            text = get(handles.edit1, 'String');
            errorMsg = 'TSP is too big for the Brute Force Algorithm!!!';
            set(handles.edit1, 'String', sprintf('%s \n\n%s', text, errorMsg));
        end
    case 'Integer Programming'
         
        % reset axes
        cla(handles.axes1);
        
        % run algorithm
        [tour, tourlenght, processtime, solutiongab] = TSP_IntegerProgramm(handles.matrix, handles.edit1);
        tourString = getTourStringFromIntegerProgrammTour(tour);
        
        % output
        set(handles.text5, 'String', sprintf('Execution time: %f', processtime));
        set(handles.text6, 'String', sprintf('Tour length: %f', tourlenght));
        set(handles.text7, 'String', sprintf('Tour: %s', sprintf('%d ', tourString)));

        % draw tour
        drawTsp(tour, handles.coordinates, handles.axes1);
         

    case 'Best Successor'
          % reset axes
          cla(handles.axes1);
          % run algorithm
          [t, tl, p] = TSP_BestSuccessor(handles.matrix);
          
          % Exception Handling: No tour found
          if(tl == -1)
             text = get(handles.edit1, 'String');
             errorMsg = 'No valid Tour found!!!';
             set(handles.edit1, 'String', sprintf('%s \n\n%s', text, errorMsg)); 
          end
          
          %output
          set(handles.text5, 'String', sprintf('Execution time: %f', p));
          set(handles.text6, 'String', sprintf('Tour length: %f', tl));
          set(handles.text7, 'String', sprintf('Tour: %s', sprintf('%d ', t)));
        
          % draw Tour
          tour=[];
          for(f = 1 : length(t)-1)
              tour=[tour; t(f) t(f+1)];
          end
          drawTsp(tour, handles.coordinates, handles.axes1);
          
    case 'Christofides'
        % reset axes;
        cla(handles.axes1);
      
      % Exception Handling: To big TSPs
      if size(handles.matrix, 1) < 15
          try
              % run algorithm
              [mst, oddEdges, t, tl, p] = TSP_Christofides(handles.matrix);

              % Exception Handling: triangle inequality
              if(tl == -1)
                 cs = get(handles.edit1, 'String');
                 errorMsg = 'Matrix does not satisfy the triangle inequality!!!';
                 set(handles.edit1, 'String', sprintf('%s \n\n%s', cs, errorMsg)); 
              end
              
              %output
              text = get(handles.edit1, 'String');
              mstString = '';
              for(i = 1:length(mst))
                mstString = sprintf('%s\n%d,%d', mstString,mst(i,1), mst(i,2));
              end
              
              edges = '';
              for(i = 1:length(oddEdges))
                edges = sprintf('%s\n%d,%d', edges,oddEdges(i,1), oddEdges(i,2));
              end
              set(handles.edit1, 'String', sprintf('%s \n\nMST:%s\n\noddLevel:%s', text, mstString, edges));
              
              set(handles.text5, 'String', sprintf('Execution time: %f', p));
              set(handles.text6, 'String', sprintf('Tour length: %f', tl));
              set(handles.text7, 'String', sprintf('Tour: %s', sprintf('%d ', t)));
              
              % draw Tour
              tour=[];
              for(f = 1 : length(t)-1)
                  tour=[tour; t(f) t(f+1)];
              end
              drawTsp(tour, handles.coordinates, handles.axes1);
              
          catch 
              warndlg('An Exception occured!');
          end
      else
         text = get(handles.edit1, 'String');
         errorMsg = 'TSP is too big for Christofides!!!';
         set(handles.edit1, 'String', sprintf('%s \n\n%s', text, errorMsg));
      end
      
    case 'Opt2'
        % reset axes;
       cla(handles.axes1);
       
       % Start Tour Dialog Window 
       prompt = {'Enter Start Tour:'};
       dlg_titel = 'Start Tour Input';
       num_lines = 1;
       input = inputdlg(prompt, dlg_titel, num_lines);

       % Check if a Start TOur was given otherwise use best successor
       % algorithmm to create a first solution
       if(~isempty(input{1}))
          start = str2num(input{1});
       else
          start = TSP_BestSuccessor(handles.matrix);
       end

       % run algorithm 
      [t, tl, p] = TSP_2opt(start, handles.matrix);

      cs = get(handles.edit1, 'String');
      st = '';
      % Check if given Start Tour has enough nodes
      if(tl == -1)
          msg = 'Start tour includes to less or to much nodes!';
          st = sprintf('Start Tour: %s\n\n%s', sprintf('%d ', start), msg);
      else
          st = sprintf('Start Tour: %s', sprintf('%d ', start));
      end
      set(handles.edit1, 'String', sprintf('%s \n\n%s', cs, st));

      % output
      set(handles.text5, 'String', sprintf('Execution time: %f', p));
      set(handles.text6, 'String', sprintf('Tour length: %f', tl));
      set(handles.text7, 'String', sprintf('Tour: %s', sprintf('%d ', t)));

      % draw Tour
      tour=[];
      for(f = 1 : length(t)-1)
          tour=[tour; t(f) t(f+1)];
      end
      drawTsp(tour, handles.coordinates, handles.axes1);
          
    case 'Opt3'
        % reset axes;
       cla(handles.axes1);
       
       % Start Tour Dialog Window 
       prompt = {'Enter Start Tour:'};
       dlg_titel = 'Start Tour Input';
       num_lines = 1;
       input = inputdlg(prompt, dlg_titel, num_lines);

       % Check if a Start TOur was given otherwise use best successor
       % algorithmm to create a first solution
       if(~isempty(input{1}))
          start = str2num(input{1});
       else
          [start, a, c]  = TSP_BestSuccessor(handles.matrix);
       end

       % run algorithm
      [t, tl, p] = TSP_3opt(start, handles.matrix);

      cs = get(handles.edit1, 'String');
      st = '';
      % Check if given Start Tour has enough nodes
      if(tl == -1)
          msg = 'Start tour includes to less or to much nodes!';
          st = sprintf('Start Tour: %s\n\n%s', sprintf('%d ', start), msg);
      else
          st = sprintf('Start Tour: %s', sprintf('%d ', start));
      end
      set(handles.edit1, 'String', sprintf('%s \n\n%s', cs, st));

      % output
      set(handles.text5, 'String', sprintf('Execution time: %f', p));
      set(handles.text6, 'String', sprintf('Tour length: %f', tl));
      set(handles.text7, 'String', sprintf('Tour: %s', sprintf('%d ', t)));

      % draw Tour
      tour=[];
      for(f = 1 : length(t)-1)
          tour=[tour; t(f) t(f+1)];
      end
      drawTsp(tour, handles.coordinates, handles.axes1);
          
    case 'Run All'
          TSP_RunAll(handles.matrix, handles.edit1, handles.axes1);
          
        
    otherwise
        printToGui(app, 'Error: please select a algorithm!');
end
catch
    warndlg('An Exception occured!');
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
