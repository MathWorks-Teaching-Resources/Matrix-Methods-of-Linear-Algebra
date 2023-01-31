
function errors = checkHyperlinks(mlxfile, varargin)

% checkHyperlinks - check if hyperlinks are valid
%
% Syntax:
% -------
% errors = checkHyperlinks(mlxfile)
% errors = checkHyperlinks(mlxfile, fullcheck = tf)
% errors = checkHyperlinks(mlxfile, showInfo  = tf)
% errors = checkHyperlinks(mlxfile, fullcheck = tf, showInfo = tf)
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
%             "penny.mlx: ID 'H_3E47FD11' not found."
% 
% Description:
% ------------
% checkHyperlinks(mlxfile) 
% Checks all hyperlinks in the file 'mlxfile' and in all .mlx files 
% references by 'mlxfiles'. In addition, statistical information are 
% displayed on the screen.
%
% checkHyperlinks(mlxfile, fullcheck = false)
% By default, fullcheck is set to true which means that all .mlx files 
% referenced by 'mlxfile' are checked. To check only the hyperlinks in the 
% file 'mlxfile', set fullCheck to false.
%
% checkHyperlinks(mlxfile, showInfo  = false)
% By default, showInfo is set to true which means that information are 
% displayed on the screen. Set showInfo to false to suppress the display 
% of such information.
% 
% checkHyperlinks(mlxfile) is equivalent to 
% checkHyperlinks(mlxfile, fullcheck = true, showInfo = true)
% 
% Examples:
% ---------
% >> checkHyperlinks("penny.mlx");
%
% >> checkHyperlinks("./demo/penny.mlx", fullcheck = false);
%
% >> errors = checkHyperlinks("penny.mlx", showInfo = false);
%


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
addParameter(p, "fullCheck", true, @islogical);
parse(p, varargin{:});

options = p.Results;

%-------------------------------------------------------------------------

try
    % Call main function
    errors = checkHyperlinksInternal(mlxfile, {}, {}, {}, options);
catch ME
    throw(ME);
end

%-------------------------------------------------------------------------

if options.showInfo
    if isempty(errors)
        fprintf("\nAll hyperlinks are valid.\n\n");
    else
        n = numel(errors);
        if n == 1
            fprintf("\n1 hyperlink is not valid.\n\n");
        else
            fprintf("\n%d hyperlinks are not valid.\n\n", n);
        end
    end
end

end % checkHyperlinks

%-------------------------------------------------------------------------

function [errors, alreadyChecked, alreadyCheckedAnchor] = ...
 checkHyperlinksInternal( ...
  mlxfile, checkAnchors, alreadyChecked, alreadyCheckedAnchor, options ...
)

mlxfile = normalize(mlxfile); 

if ~isempty(checkAnchors)
    %---------------------------------------------------------------------
    % Only check if anchors exist
    %---------------------------------------------------------------------
    if ~isempty(intersect(alreadyCheckedAnchor, mlxfile))
       % mlxfile was already checked. Nothing to do.
       errors = [];
       return;
    end
    errors = checkAnchorsIDs(mlxfile, checkAnchors, options);
    % The following statements are needed to avoid infinite loops,
    % because hyperlinks can go back and forth between files.
    alreadyCheckedAnchor = [alreadyCheckedAnchor, mlxfile];
    alreadyCheckedAnchor = unique(alreadyCheckedAnchor);
    return;
end

if ~isempty(intersect(alreadyChecked, mlxfile))
    % mlxfile was already checked. Nothing to do.
    errors = [];
    return;
end

text = readDocumentXML(mlxfile);

if options.showInfo
    fprintf("\nScanning %s ...\n", mlxfile);
end

errors = []; checkfiles = {}; checkmlxfiles = {};

xmlTagBegin = '<w:hyperlink'; xmlTagEnd = '>';
links = extractBetween(text, xmlTagBegin, xmlTagEnd);

%-------------------------------------------------------------------------
% Check internal hyperlinks
%-------------------------------------------------------------------------
%
% Link  : <w:hyperlink w:anchor="internal:<id>">
% Anchor: <w:bookmarkStart w:id="<id>" ... />
%-------------------------------------------------------------------------
exclude = @(str) ~contains(str, 'w:docLocation');
IDs = links(cellfun(exclude, links));
IDs = extractBetween(IDs, 'w:anchor="internal:', '"');
if isempty(IDs) 
    if options.showInfo
        fprintf("   No internal hyperlinks found.\n");
    end
else
    n = numel(IDs);
    if options.showInfo
        fprintf("   %d internal hyperlink(s) found.\n", n);
        fprintf("      Checking internal hyperlinks:\n");
    end
    err = false;
    bookmarks = extractBetween(text, '<w:bookmarkStart', '/>');
    for i=1:n
        bookmark = sprintf('w:id="%s"', IDs{i});
        if ~any(contains(bookmarks, bookmark))
            if options.showInfo
                fprintf("      Error: ID '%s' not found.\n", IDs{i});
            end
            errmsg = sprintf("%s: ID '%s' not found.", mlxfile, IDs{i});
            errors = addError(errors, errmsg);
            errors = [errors, errmsg]; %#ok
            err = true;
        end
    end
    if options.showInfo && ~err
        fprintf("      Internal hyperlinks are valid.\n");
    end
end

%-------------------------------------------------------------------------
% Check hyperlinks to other files
%-------------------------------------------------------------------------
%
% Link: <w:hyperlink w:docLocation="matlab:open('<filename>')">
% Anchor: No anchor in <filename>. It's just the filename.
%-------------------------------------------------------------------------
exclude = @(str) ~contains(str, 'w:anchor="internal:');
IDs = links(cellfun(exclude, links));
try
    files = extractBetween(IDs, 'w:docLocation="matlab:open(''', ''')"');
catch
    include = @(str) contains(str, 'w:docLocation="matlab:open(''');
    IDlimited = IDs(cellfun(include,IDs));
    files = extractBetween(IDlimited, 'w:docLocation="matlab:open(''', ''')"');
end
if isempty(IDs) 
    if options.showInfo
        fprintf("   No hyperlinks to other files found.\n");
    end
else
    n = numel(files);
    if options.showInfo
        fprintf("   %d hyperlink(s) to external file(s) found.\n", n);
        fprintf("      Checking hyperlinks:\n");
    end
    for i=1:n
        [~,~,ext] = fileparts(files{i});
        if ext == ".mlx"
            checkmlxfiles{end+1} = files{i}; %#ok
        else
            checkfiles{end+1} = files{i}; %#ok
        end
    end
end

%-------------------------------------------------------------------------
% Check if referenced files - mlx and non-mlx files - exist.
%-------------------------------------------------------------------------
allfiles = union(checkmlxfiles, checkfiles);
err = false; n = numel(allfiles); fileNotFound = {};
for i=1:n
    errmsg = existFile(allfiles{i}, mlxfile, options.showInfo);
    errors = addError(errors, errmsg);
    if ~isempty(errmsg)
        err = true; 
        fileNotFound = [fileNotFound, allfiles{i}]; %#ok
    end
end
if n > 0 && options.showInfo && ~err
    fprintf("      External files exist, therefore hyperlinks are valid.\n");
end

%-------------------------------------------------------------------------
% Check hyperlinks to a location in another .mlx file
%-------------------------------------------------------------------------
%
% Link  : <w:hyperlink w:anchor="internal:<id>" 
%                      w:docLocation="matlab:open('<filename>')">
% In the file <filename>:
% Anchor: <w:bookmarkStart w:id="<id>" ... />
%-------------------------------------------------------------------------
include = @(str) contains(str, 'w:anchor="internal:') && ...
                 contains(str, 'w:docLocation');
IDs = links(cellfun(include, links));
files   = extractBetween(IDs, 'w:docLocation="matlab:open(''', ''')"');
anchors = extractBetween(IDs, 'w:anchor="internal:', '"'); 
if isempty(IDs) 
    if options.showInfo
        fprintf("   No hyperlinks to a location in another .mlx file found.\n");
    end
else
    checkAnchorFiles = {};
    n = numel(files);
    if options.showInfo
        fprintf("   %d hyperlink(s) to a location in another .mlx file found.\n", n);
        fprintf("      Checking hyperlinks:\n");
    end
    for i=1:n
        file = normalize(files{i});
        idx = find(contains(checkAnchorFiles, file) > 0); 
        if isempty(idx)
            checkAnchorFiles{end+1} = file; %#ok
            checkAnchors{end+1} = {anchors{i}}; %#ok
        else
           checkAnchors{idx} = [checkAnchors{idx}, anchors{i}];
        end
    end
    checkAnchorFiles = setdiff(checkAnchorFiles, fileNotFound);
    err = false; alreadyCheckedAnchor = {};
    for i=1:numel(checkAnchorFiles)
        [errmsg, alreadyChecked, alreadyCheckedAnchor] = ...
          checkHyperlinksInternal( ...
            checkAnchorFiles{i}, checkAnchors{i}, alreadyChecked, ...
            alreadyCheckedAnchor, options ...
        );
        if ~isempty(errmsg)
            err = true;
            errors = addError(errors, errmsg);
        end
    end
    if options.showInfo && ~err
        fprintf("      External hyperlinks are valid.\n");
    end
end

%-------------------------------------------------------------------------
if ~options.fullCheck
    return
end

%------------------------------------------------------------------------
% Now do a check of all referenced mlx files.
%------------------------------------------------------------------------

% The following statements are needed to avoid infinite loops,
% because hyperlinks can go back and forth between files.
alreadyChecked = [alreadyChecked, mlxfile];
alreadyChecked = unique(alreadyChecked);
checkmlxfiles = setdiff(checkmlxfiles, alreadyChecked);
checkmlxfiles = setdiff(checkmlxfiles, fileNotFound);

for i=1:numel(checkmlxfiles)
 [errmsg, alreadyChecked, alreadyCheckedAnchor] = ...
   checkHyperlinksInternal( ...
    checkmlxfiles{i}, {}, alreadyChecked, alreadyCheckedAnchor, options ...
 );
 errors = addError(errors, errmsg);
end

end % checkHyperlinksInternal

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

%-------------------------------------------------------------------------

function errors = checkAnchorsIDs(mlxfile, IDs, options)
text = readDocumentXML(mlxfile);
errors = []; n = numel(IDs);
bookmarks = extractBetween(text, '<w:bookmarkStart', '/>');
for i=1:n
    bookmark = sprintf('w:id="%s"', IDs{i});
    if ~any(contains(bookmarks, bookmark))
        if options.showInfo
            fprintf("      Error: ID '%s' not found.\n", IDs{i});
        end
        errmsg = sprintf("%s: ID '%s' not found.", mlxfile, IDs{i});
        errors = addError(errors, errmsg);
        errors = [errors, errmsg]; %#ok
    end
end
end

