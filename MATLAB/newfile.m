fred=[1 1];
theo=[1 -1];
outterproduct=fred'*theo;
innerproduct=fred*theo';
orhtogonality= (innerproduct==0.0);

%% print the result
orhtogonality
innerproduct
outterproduct
