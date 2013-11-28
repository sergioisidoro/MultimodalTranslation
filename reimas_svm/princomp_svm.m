
function [coeff,Unorm]=princomp(X,s)

% 1. z-normalize training data X

%X=load('usps_012_X.txt');
%y=load('usps_012_y.txt');

X=X';

N=size(X,1);
mu = mean(X); 
sigma = std(X);
x = (X - repmat(mu, N, 1)) ./ repmat(sigma, N, 1);


svalues=[ 0, 16, 32, 64, 128 ];
R=3;

clf

size(x)

% 2. calculate kernel matrix K

K=get_kernel_values(x',s);

% 3.  center kernel matrix K

Nmat=ones(size(K,1),size(K,1)).* 1/size(K,1);
Knorm=K-Nmat*K-K*Nmat+Nmat*K*Nmat;

% 4. solve eigenvalue problem using centered K

[U, lambda]= eigs(Knorm, R, 'lm');

% 5. normalize eigenvectors

Unorm=U/sqrt(lambda)
size(Unorm)
size(Knorm)

size(Unorm(1,:))
size(Knorm(1,:))
size(x)

for n=1:size(x,2)
	z=zeros(R,1);
	for i=1:N
		z=z+Unorm(i,:)' * Knorm(n,i)';
    end
    coeff(n,:)=z;
end


%	switch y(n)
%		case 0
%			plot(z(1),z(2),'bo')
%		case 1
%			plot(z(1),z(2),'g+')
%		case 2
%			plot(z(1),z(2),'rp')
%	end
%	
%end

%end %  end graph for loop

end % end main function





% Make a separate function for getting the kernel values:


function [K]=get_kernel_values(x, svalue);

        if (svalue==0)
	  K=x * x';
	else

	    K = exp( - (pdist2(x,x).^2) ./ (svalue^2));
	end

end

function [K]=get_test_kernel_values(refx, testx, svalue);

        if (svalue==0)
	  K= refx * testx';
	else

	  K = exp( - (pdist2(refx,testx).^2) ./ (svalue^2));

	end
end



function [K]=get_kernel_value(x1,x2, svalue);
	if (svalue==0)
	  K=dot(x1,x2);
	else
	  K = exp( - (pdist2(x1,x2).^2) ./ (svalue^2));
	end

end

