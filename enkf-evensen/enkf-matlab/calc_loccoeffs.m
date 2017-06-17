% function [coeffs] = calc_loccoeffs(radius, tag, dist)
%
% Calculates localisation coefficients
%
% @param radius - localisation radius
% @param tag - tag to choose a particular function
% @param dist - vector of distances
% @return coeffs - vector of localisation coefficients

% File:           get_loccoeffs.m
%
% Created:        14/08/2007
%
% Last modified:  11/09/2008
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Calculates localisation coefficients
%
% Description:    Note: Implications of using particular localisation matrix
%                 have not been fully investigated yet. At this moment, 'Gauss'
%                 and 'Gaspary_Cohn' seem to be the two safest options.
%
% Revisions:      22.08.2008 PS: Corrected spatial scales for each function so
%                 that calc_loccoeffs(1, function, 1) = exp(-0.5) with precision
%                 of 5 digits.
%                 11.09.2008 PS: added a check that the input distances are
%                   a row vector.
%                 21.11.2008 PS: removed the above check

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [coeffs] = calc_loccoeffs(radius, tag, dist)

    coeffs = zeros(size(dist));

    switch tag
    
      case 'Gauss'
    
        R = radius;
        coeffs = exp(-0.5 * (dist / R) .^ 2);

      case 'Expo'
    
        R = radius;
        coeffs = exp(-1.0 * (dist / R) );

    
      case 'Gaspari_Cohn'

        R = radius * 1.7386;
        ind1 = find(dist <= R);
        r2 = (dist(ind1) / R) .^ 2;
        r3 = (dist(ind1) / R) .^ 3;
        coeffs(ind1) = 1 + r2 .* (- r3 / 4 + r2 / 2) + r3 * (5 / 8) - r2 * (5 / 3);
        ind2 = find(dist > R & dist <= R * 2);
        r1 = (dist(ind2) / R);
        r2 = (dist(ind2) / R) .^ 2;
        r3 = (dist(ind2) / R) .^ 3;
        coeffs(ind2) = r2 .* (r3 / 12 - r2 / 2) + r3 * (5 / 8) + r2 * (5 / 3) - r1 * 5 + 4 - (2 / 3) ./ r1;
    
      case 'Cosine'
    
        R = radius * 2.3167;
        ind = find((dist <= R));
        r = dist(ind) / R;
        coeffs(ind) = (1 + cos(r * pi)) / 2;
  
      case 'Cosine_Squared'
    
        R = radius * 3.2080;
        ind = find((dist <= R));
        r = dist(ind) / R;
        coeffs(ind) = ((1 + cos(r * pi)) / 2) .^ 2;
    
      case 'Lewitt'
    
        R = radius * 4.5330;
        m = 10;
        alpha = 1;
        ind = find(dist <= R);
        for i = ind
            r = dist(i) / R;
            rr = 1 - r^2;
            coeffs(i) = rr^(m/2) * besseli(m, alpha * rr^0.5) / besseli(m, alpha);
        end
      
      case 'Exp3'

        R = radius;
        coeffs = exp(-0.5 * (dist / R) .^ 3);
      
      case 'Cubic'
        
        R = radius * 1.8676;
        ind = find(dist < R);
        coeffs(ind) = (1 - (dist(ind) / R) .^ 3) .^ 3;
        
      case 'Quadro'
        
        R = radius * 1.7080;
        ind = find(dist < R);
        coeffs(ind) = (1 - (dist(ind) / R) .^ 4) .^ 4;
        
      case 'Step'
      
        R = radius;
        ind = find(dist < R);
        coeffs(ind) = 1;
        
      case 'None'
        
        coeffs(:) = 1;
      
      otherwise
        error(sprintf('\n  EnKF: error: calc_loccoeffs(): unknown localisation tag "%s".\n  Possible tags:\n    "Gauss"\n    "Gaspari_Cohn"\n    "Cosine"\n    "Cosine_Squared"\n    "Lewitt"\n    "Exp3"\n    "Cubic"\n    "Quadro""\n    "Step""\n    "None"', char(tag)));
    end
    
    return
