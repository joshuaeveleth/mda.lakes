function writeGLMnmlParamFile( varargin )
            
            


nmlDir = '/Users/jread/Desktop/Science Projects/WiLMA/GLM/';
simDir = '/Volumes/projects/WiLMA/GLM/GLM run/sim/Sparkling/';
% writes the glm.nml param file according to lake parameters

hypsoH = 475:520;
hypsoA = [linspace(2,340,length(475:501)), ones(length(hypsoH)-length(475:501),1)'*340];
initZ = [1,16,20];
initT = [1,4,4];
initS = [0,0,0];

defaults = struct(...
    'sim_name_STR','Simulation name',...    % string with quotes
    'max_layers_INT', 1000,...
    'min_layer_vol_FLT', 0.5,...
    'min_layer_thick_FLT',0.5,...
    'max_layer_thick_FLT',1,...
    'Kw_FLT',0.4,...
    'coef_inf_entrain_FLT',0,...
    'coef_mix_kinetic_FLT',0.125,...
    'coef_mix_eta_FLT',1.23,...
    'coef_mix_ct_FLT',0.51,...
    'coef_mix_cs_FLT',0.20,...
    'coef_mix_kh_FLT',0.20,...
    'lake_name_STR','Sparkling',...
    'latitude_FLT',46,...
    'longitude_FLT',-89,...
    'base_elev_FLT',min(hypsoH),...
    'crest_elev_FLT',max(hypsoH),...
    'bsn_len_FLT',21110,...
    'bsn_wid_FLT',13000,...
    'bsn_vals_INT',length(hypsoH),...                   % number of elements in H
    'H_csvVEC',hypsoH,...
    'A_csvVEC',hypsoA,...
    'start_STR','1980-01-01 00:00:00',...
    'stop_STR','2012-06-30 00:00:00',...
    'dt_FLT',86400.0,...
    'num_depths_INT',length(initZ),...                  % number of elements in initZ
    'the_depths_csvVEC',initZ,...
    'the_temps_csvVEC',initT,...
    'the_sals_csvVEC',initS,...
    'wind_factor_FLT',0.57,...
    'ce_FLT',-2.8,...                                   % default -3.9
    'ch_FLT',-4.6,...                                 % default -2.536
    'rain_sw_BL','.true.',...
    'snow_sw_BL','.true.',...
    'outl_elvs_FLT',min(hypsoH),...
    'outflow_fl_STR','Sparkling_outflow.csv',...
    'num_outlet_BL','0',...
    'bsn_len_outl_FLT',5,...
    'bsn_wid_outl_FLT',5);                                  


%% replace KVPs with inputs
% provide key value pairs to change POSTinputs structure

numArgs = length(varargin);

if ne(rem(numArgs,2),0)
    error('arguments must be made in pairs')
end

for i = 1:2:numArgs
    defaults.(varargin{i}) = varargin{i+1};
end

%% read in file, replace strings with values
text = fileread([nmlDir 'glmDEFAULT.nml']);

% now loop through all params and regexprep
pNms = fieldnames(defaults);
for p = 1:length(pNms)
    nme = pNms{p};
    if strcmp(nme(end-2:end),'STR')
        text = regexprep(text,nme,[char('''') defaults.(pNms{p}) char('''')]);
    elseif strcmp(nme(end-2:end),'INT')
        text = regexprep(text,nme,sprintf('%1.0u',defaults.(pNms{p})));
    elseif strcmp(nme(end-2:end),'FLT')
        text = regexprep(text,nme,sprintf('%1.5g',defaults.(pNms{p})));
    elseif strcmp(nme(end-5:end),'csvVEC')
        text = regexprep(text,nme,sprintf('%1.5f,',defaults.(pNms{p})));
    elseif strcmp(nme(end-1:end),'BL')
        text = regexprep(text,nme,[defaults.(pNms{p})]);
    end
end

% write file back to new file

fID = fopen([simDir 'glm.nml'],'w');
fprintf(fID,'%s',text);
fclose all;     



end

