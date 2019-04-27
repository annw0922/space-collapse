function H = cross_entrophy(p,q)
H = -sum(p.*log(q));
end