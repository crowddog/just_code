function r = load_context(settings,expt)
% loads dataset and creates r
r = dlmread([settings.ip_dir expt '.context.txt'],'\t',1,0);
end
