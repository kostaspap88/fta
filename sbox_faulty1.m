
function [y1,y2,y3,y4] = sbox_faulty1(x1,x2,x3,x4)

% simulate at stuck-at-1 fault at x1, for AND gate x1*x2*x4
y1 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(1*x2*x4, x1*x3*x4), x1), x2*x3*x4), x2*x3), x3), x4), 1);
y2 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(1*x2*x4, x1*x3*x4), x1*x3), x1*x4), x1), x2), x3*x4), 1);
y3 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(1*x2*x4, x1*x2), x1*x3*x4), x1*x3), x1), x2*x3*x4), x3);
y4 = bitxor(bitxor(bitxor(x1, x2*x3), x2), x4);

end