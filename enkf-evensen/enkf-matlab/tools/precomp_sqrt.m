function [sqrt_of_C] = precomp_sqrt(C)
  
	m=size(C,1);
	n=size(C,2);

	if(m==1)

		disp('Covariance matrix is diagonal.')
		sqrt_of_C=sqrt(C);

	else 

		fprintf('Compute SQRT of a %i-by-%i matrix using SVD!',m,n)

		% Factorize in SVD form
		[U,S,VT]=svd(C)

		% Take sqrt of singular values if allowed
		for i=1:m
			if(S(i,i)>=0)
				S(i,i)=sqrt(S(i,i));
			else
				disp('Matrix is not positive definite!')
			end
		end

		% Assemble SQRT
		sqrt_of_C=U*S;

		% Verify SQRT*SQRT^T=C
		sqrt_of_C2=sqrt_of_C*sqrt_of_C';
		relative_error_norm = norm(sqrt_of_C2-C)/norm(C);
		fprintf('Rel. Error Norm ||C^.5*C.^5-C||/||C||=%f',relative_error_norm)

	end

end
