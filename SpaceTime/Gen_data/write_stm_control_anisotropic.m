function write_stm_control_anisotropic(M, filename)
% WRITE_STM_EVEN_CONTROL  Write a control “.mem” file where
%   state 00 (0) or 10 (2) → 1
%   state 01 (1) or 11 (3) → 0
%
% Usage:
%   write_stm_even_control(M)
%     writes to 'stm_even_control.mem'
%   write_stm_even_control(M, fname)
%     writes to the given filename
%
% M must be a 3D integer array [ROWS×COLS×TIME_STEPS] with values 0–3.

  if nargin<2
    filename = 'stm_even_control.mem';
  end

  % Map: even states (0,2) → 1; odd states (1,3) → 0
  CTRL = uint8(mod(M,2)==0);

  [ROWS, COLS, TIME_STEPS] = size(CTRL);

  fid = fopen(filename,'w');
  if fid < 0
    error('Cannot open "%s" for writing.', filename);
  end

  for t = 1:TIME_STEPS
    fprintf(fid, '// Time step %d\n', t-1);
    for r = 1:ROWS
      for c = 1:COLS
        fprintf(fid, '%d\n', CTRL(r,c,t));
      end
    end
    fprintf(fid, '\n');
  end

  fclose(fid);
  fprintf('Wrote %d control bits to %s (even states → 1, odd → 0)\n', ...
          ROWS*COLS*TIME_STEPS, filename);
end
