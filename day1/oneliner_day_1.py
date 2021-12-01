print(*(lambda *l:map(sum,zip(*[(j>i,k>i)for i,j,k in zip(l,l[1:],l[3:])])))(*(open('1')),'0','0'))
