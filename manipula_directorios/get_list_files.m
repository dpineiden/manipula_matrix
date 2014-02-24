%Function to get a list of specific files in a specified directory.
%INPUT: path= Path to the files
% type=type of files being looked, example *.doc % Always write “*.” and then the type of %file
%OUT: OUT=list of name of files in the order given by the OS [nx1] %

function out=get_list_files(path,type)
ff=fullfile(path,type);
list_dir=dir(fullfile(path,type));
list_dir={list_dir.name};
out=list_dir;
