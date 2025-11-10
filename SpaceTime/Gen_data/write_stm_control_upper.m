function write_stm_control_upper(M, filename)
% WRITE_STM_CONTROL  Generate a 1‐bit control “.mem” file from a 3D state matrix
%
%   write_stm_control(M) 
%     writes to 'stm_control.mem' in the current folder.
%
%   write_stm_control(M, filename)
%     writes to the given filename (e.g. 'control_signal.mem').
%
%   M must be a nonnegative integer array of size [ROWS×COLS×TIME_STEPS]
%     with values in {0,1,2,3} corresponding to binary states 00,01,10,11.
%   The output is 1 whenever M is 00 or 01, and 0 whenever M is 10 or 11.
%
% Example:
%   % Suppose your state matrix stm is ROWS×COLS×T
%   write_stm_control(stm);                   % → 'stm_control.mem'
%   write_stm_control(stm,'ctrl.mem');        % → 'ctrl.mem'

  if nargin<2
    filename = 'stm_control.mem';
  end

  % Map: 00(0) or 01(1) → 1;  10(2) or 11(3) → 0
  CTRL = uint8(M < 2);  

  [ROWS, COLS, TIME_STEPS] = size(CTRL);
  fid = fopen(filename,'w');
  if fid<0
    error('Cannot open "%s" for writing.', filename);
  end

  for t = 1:TIME_STEPS
    fprintf(fid, '// Time step %d\n', t-1);
    for r = 1:ROWS
      for c = 1:COLS
        % write a single-bit binary string ('0' or '1')
        fprintf(fid, '%1d\n', CTRL(r,c,t));
      end
    end
    fprintf(fid, '\n');
  end

  fclose(fid);
  fprintf('Wrote %d control bits to %s\n', ROWS*COLS*TIME_STEPS, filename);
end
