clear all
close all
clc

for i = 1:4
    fileID = ['result_ConstRec_omega_vu_1_', num2str(i)];
    fontSize = 15;
    lineWidth = 3;
    dim = [200,200,1.2 * 500,500];
    rgPoses = 1.5;

    showAxis = false;
    showTitle = false;

    logResults(fileID, showTitle, showAxis, rgPoses,lineWidth,fontSize,dim)
end