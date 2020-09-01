
function [y1,y2,y3,y4] = sbox_linearfault(x1,x2,x3,x4, term_index)

% simulate at stuck-at-1 fault at x1 or x2 or x3 or x4 for linear terms
% specified by term_index
if (term_index == 1)
    y1 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(x1*x2*x4, x1*x3*x4), 1), x2*x3*x4), x2*x3), x3), x4), 1);
    y2 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(x1*x2*x4, x1*x3*x4), x1*x3), x1*x4), 1), x2), x3*x4), 1);
    y3 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(x1*x2*x4, x1*x2), x1*x3*x4), x1*x3), 1), x2*x3*x4), x3);
    y4 = bitxor(bitxor(bitxor(1, x2*x3), x2), x4);
end

if (term_index == 2)
    y1 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(x1*x2*x4, x1*x3*x4), x1), x2*x3*x4), x2*x3), x3), x4), 1);
    y2 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(x1*x2*x4, x1*x3*x4), x1*x3), x1*x4), x1), 1), x3*x4), 1);
    y3 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(x1*x2*x4, x1*x2), x1*x3*x4), x1*x3), x1), x2*x3*x4), x3);
    y4 = bitxor(bitxor(bitxor(x1, x2*x3), 1), x4);
end

if (term_index == 3)
    y1 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(x1*x2*x4, x1*x3*x4), x1), x2*x3*x4), x2*x3), 1), x4), 1);
    y2 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(x1*x2*x4, x1*x3*x4), x1*x3), x1*x4), x1), x2), x3*x4), 1);
    y3 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(x1*x2*x4, x1*x2), x1*x3*x4), x1*x3), x1), x2*x3*x4), 1);
    y4 = bitxor(bitxor(bitxor(x1, x2*x3), x2), x4);
end
        
if (term_index == 4)
    y1 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(x1*x2*x4, x1*x3*x4), x1), x2*x3*x4), x2*x3), x3), 1), 1);
    y2 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(x1*x2*x4, x1*x3*x4), x1*x3), x1*x4), x1), x2), x3*x4), 1);
    y3 = bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(x1*x2*x4, x1*x2), x1*x3*x4), x1*x3), x1), x2*x3*x4), x3);
    y4 = bitxor(bitxor(bitxor(x1, x2*x3), x2), 1);
end
    
end