function Startup
% Open the overview file
locDir = pwd;
if contains(locDir,filesep+"MATLAB Drive")
    open("NavigationMatrixMethods.mlx")
else
    open("OverviewMatrixMethods.html")
end

end