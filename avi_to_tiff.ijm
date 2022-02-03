

input = getDirectory("Choose stack folder");

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)
        action(input, list[i]);
setBatchMode(false);


function action(input, filename) {
        open(input + filename);
name=getInfo("image.filename");

output = input+"stacks"+File.separator;
File.makeDirectory(output);


	run("8-bit");

	saveAs("Tiff", output + ""+name+"");
        
close();



}




