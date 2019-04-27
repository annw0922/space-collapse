function r= softmax(p)
p = exp(p);
r = p./sum(p);
end