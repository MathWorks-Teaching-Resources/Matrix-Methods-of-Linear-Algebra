       function cmFile = idFile(fIdx,files)
            if fIdx <= length(files)
            disp("Identify the " + fIdx + " file...")
            filename = string(files(fIdx).folder) + filesep + string(files(fIdx).name);

            % Identify the current file
            [~,cmFile] = fileparts(filename);
            disp(" ")
            disp("Checking file: " + cmFile)
            end
        end