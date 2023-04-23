function Z = WGF(X, G, r, lambda)
% X:        input image, must be a gray-scale image
% G:        guidance image, must be a gray-scale image
% r:        window radius
% lambda:   regularization parameter
% gamma:    selective
% Z:        filter output

% if(exist('gamma_G', 'var') ~= 1)
%     gamma = EdgeAwareWeighting(G);
% end


%%
[H,W] = size(X);
% Modify the image shape to fit the function requirements
k = shrink(H,W,X,2);
% From 'https://www.mathworks.com/matlabcentral/fileexchange/36278-split-bregman-method-for-total-variation-denoising?s_tid=srchtitle'
% Modify function input port
PreFusion = Bregman(-k,15);
% Inverse transformation back to original shape
PreFusion = reshape(PreFusion,[max(H,W),max(H,W)]);
PreFusion = shrink(H,W,PreFusion,3);
PreFusion = mat2gray(PreFusion);
gamma=PreFusion;
% gamma= double(imread(PreFusionPath));

[hei, wid] = size(X);
N = boxfilter(ones(hei, wid), r);

GX = G .* X;
mean_GX = boxfilter(GX, r) ./ N;
mean_X = boxfilter(X, r) ./ N;
mean_G = boxfilter(G, r) ./ N;

mean_GG = boxfilter(G.*G, r) ./ N;
var_G = mean_GG - mean_G .* mean_G;

a = (mean_GX - mean_G.*mean_X) ./ (var_G + lambda./gamma);
b = mean_X - a .* mean_G;

mean_a = boxfilter(a, r) ./ N;
mean_b = boxfilter(b, r) ./ N;

Z = mean_a .* G + mean_b;       % Eqn(9) in the paper

end

