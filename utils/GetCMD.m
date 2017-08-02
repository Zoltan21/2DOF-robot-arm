function res = GetCMD( value )

M = mod(value,256);
res(1) = uint8(M);
L = floor(value/256);
res(2)= uint8(L);

end

