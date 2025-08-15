function write_stm_mem_binary(M, filename)
% WRITE_STM_MEM_BINARY  Dump a 3D matrix as binary words, one per line
%
%   write_stm_mem_binary(M) 
%     writes to 'stm_matrix.mem'.
%   write_stm_mem_binary(M, filename)
%     writes to the given filename.
%
% M must be a nonnegative integer array [ROWS×COLS×TIME_STEPS].
% All values must fit within ceil(log2(max(M(:))+1)) bits.

  if nargin<2
    filename = 'stm_matrix.mem';
  end

  % figure out how many bits each entry needs
  maxVal   = max(M(:));
  widthBits= max(1, ceil(log2(double(maxVal)+1)));

  [ROWS,COLS,TIME_STEPS] = size(M);
  fid = fopen(filename,'w');
  if fid<0
    error('Cannot open "%s" for writing.', filename);
  end

  for t = 1:TIME_STEPS
    fprintf(fid, "// Time step %d\n", t-1);
    for r = 1:ROWS
      for c = 1:COLS
        val = M(r,c,t);
        if val<0 || val>=(2^widthBits)
          fclose(fid);
          error('Value %d at (%d,%d,%d) out of %d bits.', ...
                val,r,c,t,widthBits);
        end
        bstr = dec2bin(val, widthBits);  % pads with leading zeros
        fprintf(fid, '%s\n', bstr);
      end
    end
    fprintf(fid, '\n');
  end

  fclose(fid);
  fprintf('Wrote %d binary words to %s  (%d-bit wide)\n', ...
          ROWS*COLS*TIME_STEPS, filename, widthBits);
end
