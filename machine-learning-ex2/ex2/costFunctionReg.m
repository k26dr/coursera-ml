function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta

h = sigmoid(X*theta)
pos_cost = (1/m) * -y'*log(h)
neg_cost = (1/m) * (y-1)'*log(1-h)
reg_ones = ones(size(theta), 1)
reg_ones(1,1) = 0
reg_cost = (lambda/(2*m)) * reg_ones' * (theta .^ 2)
J = pos_cost + neg_cost + reg_cost

reg_grad_ones = eye(size(theta,1))
reg_grad_ones(1,1) = 0 
grad = (1/m)*X'*(h-y) + (lambda/m)*reg_grad_ones*theta




% =============================================================

end
