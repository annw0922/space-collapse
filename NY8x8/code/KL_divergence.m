function d = KL_divergence(p,q,i_soft)
%i_soft判断是否使用softmax： 1使用，0不使用. default：不使用

if nargin == 3 
    if i_soft == 1
        p = softmax(p);
        q = softmax(q);
    end
end
d = cross_entrophy(p,q) - cross_entrophy(p,p);
end