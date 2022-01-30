classdef Norm2d
    % NORM2D A class for a bivariate normal distribution

    % The main properties are mean and covariance
    properties 
        Mean(2,1) double{mustBeReal,mustBeFinite} = [0; 0];
        Covariance (2,2) double{mustBeReal, mustBeFinite, mustBeSymmetric(Covariance)} = [1 0.5; 0.5 1];
    end

    % Derived properties that are set internally
    properties (SetAccess = private)
      Precision double {mustBeReal}
      Correlation double {mustBeReal, mustBeFinite}
    end

    % Constant properties
    properties(Constant)
        % Gaussian scaling constant
        ScalingConstant = (2*pi) .^(-0.5);
        % Distribution name
        Name = 'Bivariate Normal';
    end

    % Define methods for this class
    methods

    %%% Constructor method builds the object %%%
    function obj = Norm2d(Mean, Covariance)
        if nargin > 0
            obj.Mean = Mean;
            if nargin >1 
                obj.Covariance = Covariance;
            end
        end
        obj = updateCovariance(obj);
    end

    %%% Display function %%% 
    % prints the distribution properties to the screen (by overloading!)
    function disp(obj)
          fprintf('  %s distribution with parameters:\n', obj.Name);
          fprintf('         %s\n\t %f \n\t %f \n' , 'Mean:', obj.Mean);
          fprintf('         %s\n\t %f   %f\n\t %f   %f\n' , 'Covariance:', obj.Covariance');
          fprintf('\n');
    end

    %%% Getters & setters %%%

    % Setter for Covariance
    function obj = set.Covariance(obj, val)
        obj.Covariance = val;
        obj = updateCovariance(obj);
    end

    % Update properties contingent on covariance
    function obj = updateCovariance(obj)
        obj.Precision = inv(obj.Covariance);
        obj.Correlation = obj.Covariance(1,2) / sqrt(obj.Covariance(1)*obj.Covariance(4));
    end

    
    %%% Computation functions %%%

   % Probability density function
   % output = pdf(obj, X)

   % Log probability density function

   % Cumulative distribution function

   % Log cumulative distribution function

   % Random number generation

   % Deviance

   % Standardizer


        function obj = setMeanAndCovariance(obj,Mean1,Covariance1)
             obj.Mean = Mean1;
             obj.Covariance=Covariance1;
             obj.Precision=inv(Covariance1)
             obj.c12=Covariance1(1,2)
             obj.sigma1=sqrt(Covariance1(1,1))
             obj.sigma2=sqrt(Covariance1(2,2))
             obj.Correlation=obj.c12/(obj.sigma1*obj.sigma2)
        end
        function out = pdf(obj,X)
             Ro=obj.c12/(obj.sigma1*obj.sigma2)
             a1=sqrt(1-Ro^2)
             a2=2*pi*obj.sigma1*obj.sigma2*a1
             k=1/a2
             n=size(X,2)
             x1=X(1,:)
             x2=X(2,:)
             m1=obj.Mean(1,1)
             m2=obj.Mean(2,1)
             mu1=m1*ones(1,n)
             mu2=m2*ones(1,n)
             z=((x1-mu1)/obj.sigma1).^2-2*Ro*(((x1-mu1)/obj.sigma1).*(x2-mu2)/obj.sigma2)+((x2-mu2)/obj.sigma2).^2
             out=k*exp((-1/2)*(z/(1-Ro.^2)))
        end
        function obj = set.Mean(obj,value)

                obj.Mean = value;

        end     

        function out =logpdf(obj,X)
             Ro=obj.c12/(obj.sigma1*obj.sigma2)
             a1=sqrt(1-Ro^2)
             a2=2*pi*obj.sigma1*obj.sigma2*a1
             k=1/a2
             n=size(X,2)
             x1=X(1,:)
             x2=X(2,:)
             m1=obj.Mean(1,1)
             m2=obj.Mean(2,1)
             mu1=m1*ones(1,n)
             mu2=m2*ones(1,n)
             z=((x1-mu1)/obj.sigma1).^2-2*Ro*(((x1-mu1)/obj.sigma1).*(x2-mu2)/obj.sigma2)+((x2-mu2)/obj.sigma2).^2
%              out=k*exp((-1/2)*(z/(1-Ro.^2)))
             var=(-1/2)*(z/(1-Ro.^2))
             out=log(k)+var
        end
        function out=cdf(obj,X,Mu,Sigma)
           out= mvncdf(X,Mu,Sigma);%Mu row vector
        end
        function out=logcdf(obj,X,Mu,Sigma)
           p= mvncdf(X,Mu,Sigma);%Mu row vector
           out=log(p)
        end
        function out=rng(obj,Mu,Sigma,size)
%             obj.setMeanAndCovariance(Mu,Sigma)
%             disp("mrj")
%             obj.Mean
%          Mu is a row vector
            sigma1=sqrt(Sigma(1,1));
            sigma2=sqrt(Sigma(2,2));
            c12=Sigma(1,2);
            Ro=c12/(sigma1*sigma2);
            mu1=Mu(1,1);
            mu2=Mu(1,2)
            x1=sigma1*randn(size,1)+mu1
            nmu2=mu2+sigma2*Ro*((x1-mu1)/sigma1)
            nsigma2=sigma2^2*sqrt(1-Ro^2)
            x2=nsigma2*randn(size,1)+nmu2

            out=[x1  x2]
        end

        function out=dev(obj,Data,Mu,Sigma)
            %Data is a 2*n matrix
            obj=obj.setMeanAndCovariance(Mu,Sigma)
%             n=size(Data,2)
            allLogs=obj.logpdf(Data)
            sum1=sum(allLogs)
            out=-2*sum1
        end

%         function obj = set.Mean(obj,Mean1)
%             obj.Mean=Mean1
%    
%         end
%         function value = get.Mean(obj)
%             value=obj.Mean
%    
%     end
    end
end

% custom validation function
% ensure covariance symmetry
function mustBeSymmetric(a)
    if ~issymmetric(a)
        eidType = 'mustBeSymmetric: not symmetric';
        msgType = 'Covariance matrix must be symmetric';
        throwAsCaller(MEception(eidType, msgType))
    end
end

 
