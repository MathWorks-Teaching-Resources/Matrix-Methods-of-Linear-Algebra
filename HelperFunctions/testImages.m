% Test images for alt-text
function numImToFix = testImages(xml,name)

numImToFix = 0;
if(~isfield(xml.w_body.w_p,"w_customXml"))
    % Return if there are no images
    disp("No images found in : " + name)
    return
else
    disp("Checking customXml tags...")
end
C1 = {xml.w_body.w_p.w_customXml};
vals = cellfun('isclass',C1,'struct');
allCustomXML = C1(vals);
for k = 1:length(allCustomXML)
    [~,n] = size(allCustomXML{k});
    if isequal(allCustomXML{k}.w_elementAttribute,"image")
        for j = 1:n
            mainStruct = allCustomXML{k};
            curStruct = mainStruct(j).w_customXmlPr.w_attr;
            attrNames = [curStruct.w_nameAttribute];
            vals = [curStruct.w_valAttribute];
            alttextIdx = attrNames == "altText";
            alttxt = vals(alttextIdx);
            disp("The alt-text for this image :"+alttxt)
            if contains(alttxt,".png")
                warning("This image appears to have auto-generated alt-text. Please edit it.")
                numImToFix = numImToFix + 1;
            end
        end
    else
        opts = [allCustomXML{k}.w_elementAttribute];
        disp("This is not an image, it has attribute : " + opts(1))
        switch opts(1)
            case "equation"
                disp("Equations do not require alt-text.")
            otherwise
                disp("Please check if this requires alt-text.")
        end
    end
end
if numImToFix > 0
    disp("There are " + numImToFix + " images that need alt-text in " + name)
    disp("Check the Confluence page for best practices")
    web("https://confluence.mathworks.com/display/TRAINCON/Best+Practices+for+Writing+Alt-Text")
end
end