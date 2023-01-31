%% Internal EDU Live Script Curriculum Module tests
%
% 1. Run this script (add "Utilities" to your path if necessary)
% 2. Select the directory containing your curriculum module

% Setup for tests by saving the current directory,
% asking the user to identify the curriculum module directory,
% loading the project for the curriculum module,
% and generate the list of files to test, and
% create a temporary directory in which
% to unzip the .mlx files into .xml files
classdef testLinksImages < matlab.unittest.TestCase

    properties
        files
        tempPath
        cmDirectory
        startDir
    end % End properties

    methods(TestClassSetup)
        function setupCode(testCase)
            p = path;
            testCase.addTeardown(@path,p);

            testCase.cmDirectory = uigetdir;
            testCase.startDir = pwd;
            testCase.addTeardown(@cd,testCase.startDir);

            cd(testCase.cmDirectory)
        end
        function openProjectFile(testCase)
            prjFile = dir(string(testCase.cmDirectory) + filesep + "*.prj");
            try
                disp("Opening project: " + prjFile.name)
                open(prjFile.name)
%                 testCase.addTeardown(@close,prjFile.name)
            catch
                disp("There is no project in " + string(testCase.cmDirectory))
                try 
                    disp("Moving up a level...")
                    prjFile = dir(".."+filesep+"*.prj");
                    disp("Opening project: " + prjFile.name)
                    open(".."+ filesep + prjFile.name)
                catch
                    disp("There is no project in " + string(oneUp))
                end
            end
        end
        function locateLiveScripts(testCase)
            disp("Finding the .mlx files...")
            testCase.files = dir(string(testCase.cmDirectory) + filesep + "*.mlx");
            disp("Setting the tempPath value...")
            testCase.tempPath = fullfile(testCase.startDir,"TempCheckLinks");
        end
    end % End TestClassSetup Methods

    methods(Test)

        function checkLinks(testCase)
            for fId = 1:length(testCase.files)
                cmFile = idFile(fId,testCase.files);
                co = checkHyperlinks(cmFile);
                testCase.verifyTrue(isempty(co))
            end
        end

        function checkImages(testCase)
            % Run tests
            for fId = 1:length(testCase.files)
                cmFile = idFile(fId,testCase.files);
                co = checkImages(cmFile);
                testCase.verifyTrue(isempty(co))
            end
        end

    end % End Test Methods

    
    methods(TestClassTeardown)
        function teardownCode(testCase)
            % Close all open simulink models
            % bdclose all
            cd(testCase.startDir)
        end
    end % End TestMethodTeardown Methods

end % End classdef














