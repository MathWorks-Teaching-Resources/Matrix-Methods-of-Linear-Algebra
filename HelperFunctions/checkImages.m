function errors = checkImages(mlxfile, varargin)

% checkImages - check if images have defined alt-text
%
% Syntax:
% -------
% errors = checkImages(mlxfile)
% errors = checkImages(mlxfile, showInfo  = tf)
%
% Input arguments:
% mlxfile - a string or character array. The name of the file.
% tf      - true or false. Default is true.
%
% Output argument:
% ----------------
% errors - a string array or [].
%          If errors is non-empty. it contains the error messages.
%          An error message is of the following form:
%             "penny.mlx: File 'test.mlx' not found."
%             or
%             "penny.mlx: Image 'foo.png' has no alt-text."
% 
% Description:
% ------------
% checkImages(mlxfile) 
% Checks all images in mlxfile to see if they have default alt-text (*.png)
% or user-defined alt-text.
%
% WARNING: This code assumes the only image file type allowed in a Live
% Script is a .png
%
% checkHyperlinks(mlxfile, showInfo  = false)
% By default, showInfo is set to true which means that information are 
% displayed on the screen. Set showInfo to false to suppress the display 
% of such information.

%-------------------------------------------------------------------------
% Argument checking
%-------------------------------------------------------------------------
if ~(ischar(mlxfile) || isstring(mlxfile))
    error("First argument should be a string or character array.");
end

if ~exist(mlxfile, "file")
    error("Can't find file '%s'.", mlxfile);
end

p = inputParser;
addParameter(p, "showInfo",  true, @islogical);
parse(p, varargin{:});

options = p.Results;

%-------------------------------------------------------------------------

try
    % Call main function
    errors = checkImagesInternal(mlxfile, options);
catch ME
    throw(ME);
end

%-------------------------------------------------------------------------

if options.showInfo
    if isempty(errors)
        fprintf("\nAll images have valid alt-text.\n\n");
    else
        n = numel(errors);
        if n == 1
            fprintf("\n1 image has no alt-text.\n\n");
            disp(errors)
        else
            fprintf("\n%d images have no alt-text.\n\n", n);
            disp(errors)
        end
    end
end

end % checkHyperlinks
%-------------------------------------------------------------------------

function errors = ...
 checkImagesInternal(mlxfile, options)

mlxfile = normalize(mlxfile); 

text = readDocumentXML(mlxfile);

if options.showInfo
    fprintf("\nScanning %s ...\n", mlxfile);
end

errors = [];

xmlTagBegin = '<w:attr w:name="altText" w:val="'; xmlTagEnd = '"/>';
altTextVals = extractBetween(text, xmlTagBegin, xmlTagEnd);

%-------------------------------------------------------------------------
% Check images for altText
%-------------------------------------------------------------------------
%
% Link  : <w:customXml w:element="image">
%           <w:customXmlPr>
%               <w:attr w:name="height" w:val="83"/>
%               <w:attr w:name="width" w:val="124"/>
%               <w:attr w:name="verticalAlign" w:val="baseline"/>
%               <w:attr w:name="altText" w:val="Computer-Thoughtbubble.png"/>
%               <w:attr w:name="relationshipId" w:val="rId1"/>
%           </w:customXmlPr>
%        </w:customXml>
% Anchor: <w:customXml w:element="image">
%           <w:customXmlPr>
%               <w:attr w:name="height" w:val="83"/>
%               <w:attr w:name="width" w:val="124"/>
%               <w:attr w:name="verticalAlign" w:val="baseline"/>
%               <w:attr w:name="altText" w:val="A computer thinking of a mouse."/>
%               <w:attr w:name="relationshipId" w:val="rId1"/>
%           </w:customXmlPr>
%        </w:customXml>
%-------------------------------------------------------------------------
for k = 1:length(altTextVals)
    at = string(altTextVals{k});
    if checkText(at)
        errors = [errors; at]; %#ok<AGROW> 
    end
end
end % end checkImagesInternal

%-------------------------------------------------------------------------
function tf = checkText(at)
    stdFileExts = [".png" ".jpeg" ".jpg" ".pdf" ".svg"];
    tf = any(contains(at,stdFileExts));
end

%-------------------------------------------------------------------------
function text = readDocumentXML(mlxfile)
% Create a temporary folder
[~,folder,ext] = fileparts(mlxfile);
if ~strcmp(ext, ".mlx")
    error("First argument should be a filename with the extension .mlx");
end
folder = fullfile(tempdir, folder);
% Try to unzip the mlxfile
try
    % Unzip mlxfiles
    unzip(mlxfile, folder);
    % Make sure that the temporarly created folder is deleted when done
    obj = onCleanup(@() rmDir(folder));
catch ME
    error("'%s' is not a Live Code file or a corrupted Live Code file.", mlxfile);
end

% Read the entire content of <folder>/matlab/document.xml 
try
    text = fileread(fullfile(folder, "matlab", "document.xml"));
catch ME
    throw(ME);
end

end % readDocumentXML

%-------------------------------------------------------------------------

function rmDir(folder)
if exist(folder, "dir")
    rmdir(folder, "s");
end
end % rmDir

%-------------------------------------------------------------------------

function errors = addError(errors, errmsg)
if isempty(errors) 
    if ~isempty(errmsg)
        errors = errmsg;
    end
elseif ~isempty(errmsg)
    errors = [errors, errmsg]; 
end
end % addError

%-------------------------------------------------------------------------

function errmsg = existFile(file, mlxfile, showInfo)
if ~exist(file, "file")
    if showInfo
        fprintf("      Error: File '%s' not found.\n", file);
    end
    errmsg = sprintf("%s: File '%s' not found.", mlxfile, file);
else
    errmsg = [];
end
end % existFile

%-------------------------------------------------------------------------

function filename = normalize(filename)
filename = which(filename);
end % normalize
