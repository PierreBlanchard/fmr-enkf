% This funcion should dispatch between all variants of square root computation
% FMR or not
% matrix built in matlab or C++ routine
% FMM or not

function [sqrt_of_R] = calc_sqrt_r(prm)

	% Take square root
	if prm.use_fmr

		% Set FMR specific parameters
		% - 

		switch prm.format
		case 'Matlab'
			% Compute R explicitely
			R = calc_r(prm);
			% FMR's SQRT of Dense matrix read from file
			sqrt_of_R=precomp_sqrt_with_fmr(prm);
		case 'FMR_Dense'
			% FMR's SQRT of Dense matrix computed from grid
			sqrt_of_R=precomp_sqrt_with_fmr(prm);
		case 'FMR_FMM'
			% FMR's SQRT of FMM matrix
			sqrt_of_R=precomp_sqrt_with_fmr(prm);
		end
	else

		% Compute R explicitely
		R = calc_r(prm);
		% Matlab's SQRT of Dense matrix 
		sqrt_of_R=precomp_sqrt(R);

	end

    return