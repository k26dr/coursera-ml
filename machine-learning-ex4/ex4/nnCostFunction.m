function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

X = [ones(m,1) X];
a1 = sigmoid(X*Theta1');
a1 = [ones(m,1) a1];
h = sigmoid(a1*Theta2');
c = 1:num_labels;
one_hot = (y == c);

Theta1_reg = Theta1(:, 2:input_layer_size+1);
Theta2_reg = Theta2(:, 2:hidden_layer_size+1);
J_err = mean(sum(one_hot .* -log(h) + (one_hot-1) .* log(1-h), 2));
J_reg = lambda/(2*m) * (sum(sum(Theta1_reg .^ 2)) + sum(sum(Theta2_reg .^ 2)));
J = J_err + J_reg;

% Backprop

delta1 = zeros(hidden_layer_size+1, input_layer_size+1);
delta2 = zeros(num_labels, hidden_layer_size+1);
for t=1:m
    a0 = X(t,:); % 1x401
    z1 = a0 * Theta1'; % 1x25
    a1 = [1 sigmoid(z1)]; % 1x26
    z2 = a1 * Theta2'; % 1x10
    a2 = sigmoid(z2); % 1x10
    error2 = a2 - one_hot(t,:); % 1x10
    error1 = error2 * Theta2 .* [1 sigmoidGradient(z1)]; % 1x26
    delta2 = delta2 + error2' * a1; % 10x26
    delta1 = delta1 + error1' * a0; % 26x401
end

delta1 = delta1(2:end,:); % 25x401

Theta1_grad = delta1 / m; % 25x401
Theta2_grad = delta2 / m; % 10x26

% Regularization
Theta1_reg = lambda/m * [zeros(hidden_layer_size,1) Theta1(:,2:end)];
Theta2_reg = lambda/m * [zeros(num_labels,1) Theta2(:,2:end)];
Theta1_grad = Theta1_grad + Theta1_reg;
Theta2_grad = Theta2_grad + Theta2_reg;



% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];

end
