function OpenOverviewMatrixMethods
% Open the overview file
locDir = pwd;
if contains(locDir,filesep+"MATLAB Drive")
    open("NavigationMatrixMethods.mlx")
else
    open("OverviewMatrixMethods.html")
end

% % Close the current script
% open("OpenOverview.m")
close(matlab.desktop.editor.getActive)
end