function [data segs_samp] = contsegdata(c, segs)
% CONTSEGDATA get raw data points from segments, no time info
%
%  [data segs_samp] = contsegdata(c, segs)
%
% Inputs:
%  c - cont struct
%  segs - m x 2 array of seg start/end times
% 
% Outputs:
%  data - data selected from c.data, 1 column per channel
%  segs_samp - m x 2 array of indexes into c.data for each seg
  
% Tom Davidson <tjd@stanford.edu> 2003-2010
  
  % select segs in range
  goodsegs = segs(inseg([c.tstart c.tend], segs),:);
  if numel(goodsegs) ~= numel(segs)
    warning('ignoring segs outside of cont range');
    segs = goodsegs;
  end
  
  % get indexes into c.data
  segs_samp = round((segs - c.tstart) * c.samplerate)+1;

  dat_use = false(size(c.data,1),1);
  
  for k = 1:size(segs,1),
    
    samps_i = segs_samp(k,1):segs_samp(k,2);
    dat_use(samps_i) = true;

    % don't include timepoints with NaNs in any channel
    dat_use(samps_i(any(isnan(c.data(samps_i,:)),2))) ...
        = false;

  end

  data = c.data(dat_use,:);