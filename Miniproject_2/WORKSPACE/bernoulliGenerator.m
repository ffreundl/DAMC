function [x]=bernoulliGenerator(probability, size)
%This function returns a set of value following a Bernoulli
%distribution, using a uniform continuous generator and the its cdf
%properties.
%x is the set


assert(probability>=0.0&&probability<=1.0,'probability of event must be between 0.0 and 1.0');
assert(size>=1,'the size must be superior or equal to 1');
assert(size==round(size),'the size must be an integer value');


x=rand(size,1);
for i=1:size
    if(x(i)<probability)
        x(i)=1;
    else
        x(i)=0;
    end
end


end