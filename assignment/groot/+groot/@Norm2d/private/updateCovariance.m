% Update Precision, StandardDeviation and Correlation based on Covariance
function obj = updateCovariance(obj)
    % check for covariance matrix (should be symmetric)
    assert(isequal(obj.Covariance, transpose(obj.Covariance)),...
    'Error: Covariance is not symmetric');

    obj.Precision = inv(obj.Covariance);
    if any(isinf(obj.Precision))
        error('Obj precision inexpressible, Covariance matrix singular');
    end
    obj.StandardDev = sqrt(diag(obj.Covariance));
    obj.Correlation = obj.Covariance(1,2) / prod(obj.StandardDev);
   
    assert ((-1 <= obj.Correlation) && (1 >= obj.Correlation));
end