% focusing on the F function of the decomposed TI of the PRESENT sbox
function [f10, f20, f30, f11, f21, f31, f12, f22, f32, f13, f23, f33] = masked_sbox_faulty(x0,x1,x2,x3, fault_position)

f10 = NaN;
f20 = NaN; 
f30 = NaN;
f11 = NaN;
f21 = NaN;
f31 = NaN;
f12 = NaN;
f22 = NaN;
f32 = NaN;
f13 = NaN;
f23 = NaN;
f33 = NaN;


% generate random numbers and mask the inputs x0, x1, x2, x3
for i=1:3 % 3-share TI
   x01 = randi(2,1)-1; 
   x02 = randi(2,1)-1;
end
x03 = bitxor(x02,bitxor(x01,x0));

for i=1:3 % 3-share TI
   x11 = randi(2,1)-1; 
   x12 = randi(2,1)-1;
end
x13 = bitxor(x12,bitxor(x11,x1));


for i=1:3 % 3-share TI
   x21 = randi(2,1)-1; 
   x22 = randi(2,1)-1;
end
x23 = bitxor(x22,bitxor(x21,x2));

for i=1:3 % 3-share TI
   x31 = randi(2,1)-1; 
   x32 = randi(2,1)-1;
end
x33 = bitxor(x32,bitxor(x31,x3));

if fault_position == 1
    
    x02 = 1;
    f10 = mod(x12 + x22*x02 + x22*x03 + x23*x02, 2);
    f20 = mod(x13 + x23*x03 + x21*x03 + x23*x01, 2);
    f30 = mod(x11 + x21*x01 + x21*x02 + x22*x01, 2);
 
end

if fault_position == 2
    x02 = 1;
    f11 = mod(x22 + x12 + x32*x02 + x32*x03 + x33*x02, 2);
    f21 = mod(x23 + x13 + x33*x03 + x31*x03 + x33*x01, 2);
    f31 = mod(x21 + x11 + x31*x01 + x31*x02 + x32*x01, 2);
    
end

if fault_position == 3
    x02 = 1;
    f12 = mod(x32 + x12*x02 + x12*x03 + x13*x02, 2);
    f22 = mod(x33 + x13*x03 + x11*x03 + x13*x01, 2);
    f32 = mod(x31 + x11*x01 + x11*x02 + x12*x01, 2);
end

if fault_position == 4
    x02 = 1;
    f13 = mod(x22 + x12 + x02 + x32*x02 + x32*x03 + x33*x02, 2);
    f23 = mod(x23 + x13 + x03 + x33*x03 + x31*x03 + x33*x01, 2);
    f33 = mod(x21 + x11 + x01 + x31*x01 + x31*x02 + x32*x01, 2);
    
end



end