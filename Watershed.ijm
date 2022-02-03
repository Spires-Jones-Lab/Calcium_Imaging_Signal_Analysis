
input = getDirectory("Choose stack folder");
parent_path = File.getParent(input)+ "/";
output = parent_path+"5_Watershed"+File.separator;
File.makeDirectory(output);

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)
        action(input, list[i]);

function action(input, filename) {
        open(input + filename);
name=getInfo("image.filename");

run("Adjustable Watershed", "tolerance=1.5"); // Change the tolerance if needed

saveAs("Tiff", output + ""+name+"");
        
close();

}
