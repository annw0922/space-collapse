function d = KL_divergence(p,q,i_soft)
%i_soft�ж��Ƿ�ʹ��softmax�� 1ʹ�ã�0��ʹ��. default����ʹ��

if nargin == 3 
    if i_soft == 1
        p = softmax(p);
        q = softmax(q);
    end
end
d = cross_entrophy(p,q) - cross_entrophy(p,p);
end