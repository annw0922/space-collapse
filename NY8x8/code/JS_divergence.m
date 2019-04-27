function d = JS_divergence(p,q)
p =softmax(p);
q = softmax(q);
m = (p+q)/2;
d = KL_divergence(p,m)/2+KL_divergence(q,m)/2;
end