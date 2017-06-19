clear all; close all; clc;

 x=[708 398 75 40 10 18 14 237];
%  explode=[1 1 0 0 0 0 0 1]
%  pie(x,explode,{'m=1','m=2','m=3','m=4','m=5','m=6','m=7','m=0'});
%  set(gcf,'color','white')
%  applyhatch(gcf,'|-+.\x,/');

% x=[171 226 234 384 225 258 140 64];
% explode=[1 1 0 0 0 0 0 0]
% pie(x,explode,{'m=1','m=2','m=3','m=4','m=5','m=6','m=7','m=8'});
% x=[0.14,0.24,0.05,0.47,0.1,0.7];
pie(x);
set(gcf,'color','white');
applyhatch(gcf,'|-+.\x,/');
