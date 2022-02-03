//Get all the stacks in the same folder.
//Only stacks in the folder.
//Stack names without tabulations.

input = getDirectory("Choose stack folder");
parent_path = File.getParent(input)+ "/";
output = parent_path+"3_Aligned"+File.separator;
File.makeDirectory(output);

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)
        action(input, list[i]);
setBatchMode(false);


function action(input, filename) {
        open(input + filename);
name=getInfo("image.filename");

	run("MultiStackReg", "stack_1=["+name+"] action_1=Align file_1=[] stack_2=None action_2=Ignore file_2=[] transformation=[Rigid Body]");

	saveAs("Tiff", output + ""+name+"");
        
close();



}




