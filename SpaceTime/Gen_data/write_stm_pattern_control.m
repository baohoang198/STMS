function write_stm_pattern_control(M, filename)
% WRITE_STM_PATTERN_CONTROL  Generate an 8-bit control “.mem” file from a 3D state matrix
%
%   write_stm_pattern_control(M) 
%     writes to 'stm_pattern_control.mem' in the current folder.
%
%   write_stm_pattern_control(M, filename)
%     writes to the given filename (e.g. 'pattern_control.mem').
%
%   M must be a nonnegative integer array of size [ROWS×COLS×TIME_STEPS]
%     with values in {0,1,2,3} corresponding to binary states 00,01,10,11.
%   The output is an 8-bit binary word per line:
%     00 → 00000001
%     01 → 00010001
%     10 → 00011101
%     11 → 01111101

  if nargin<2
    filename = 'stm_pattern_control.mem';
  end

  % Define the 8-bit patterns for each state 0,1,2,3:
  %   00 -> 8'b00000001 = 1
  %   01 -> 8'b00010001 = 17
  %   10 -> 8'b00011101 = 29
  %   11 -> 8'b01111101 =125
  patternVals = uint8([  1,   17,    29,   125 ]);

  [ROWS, COLS, TIME_STEPS] = size(M);

  fid = fopen(filename,'w');
  if fid<0
    error('Cannot open "%s" for writing.', filename);
  end

  for t = 1:TIME_STEPS
    fprintf(fid, '// Time step %d\n', t-1);
    for r = 1:ROWS
      for c = 1:COLS
        state = M(r,c,t);
        if state < 0 || state > 3
          fclose(fid);
          error('Invalid state %d at (%d,%d,%d); must be 0–3.', state, r, c, t);
        end
        val = patternVals(state+1);
        bstr = dec2bin(val, 8);           % 8-bit binary string
        fprintf(fid, '%s\n', bstr);
      end
    end
    fprintf(fid, '\n');  % blank line between time steps (optional)
  end

  fclose(fid);
  fprintf('Wrote %d pattern words to %s\n', ROWS*COLS*TIME_STEPS, filename);
end
