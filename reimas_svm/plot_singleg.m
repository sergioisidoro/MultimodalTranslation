if 1 == 1


i=1
dims=[1,2]

subplot(1,2,1)
x1 = -0.1:0.005:0.1; x2 = -0.1:0.005:0.1;
%x1 = -0.5:0.01:0.5; x2 = -0.5:0.01:0.5;
F=zeros(length(x1),length(x2));

for c=1:1
w1=1
mu1=gmms2d{i}{2}{1}(c,dims);
Sigma1=gmms2d{i}{2}{2}(dims,dims,c);
%Sigma1=diag(gmms2d{i}{1}.Sigma(:,1:2,c))

[X1,X2] = meshgrid(x1,x2);
F1 = mvnpdf([X1(:) X2(:)],mu1,Sigma1);
F1 = reshape(F1,length(x2),length(x1));

F=F+w1*F1;

end


surf(x1,x2,F);
%contour(x1,x2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
%axis([-0.1 0.1 -0.1 0.1 0 100])
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');

subplot(1,2,2)
%x1 = -0.1:0.005:0.1; x2 = -0.1:0.005:0.1;
F=zeros(length(x1),length(x2));

for c=1:1
w1=1
mu1=eng_gmms2d{i}{2}{1}(c,dims);
Sigma1=eng_gmms2d{i}{2}{2}(dims,dims,c);
%Sigma1=diag(eng_gmms2d{i}{1}.Sigma(:,1:2,c))


[X1,X2] = meshgrid(x1,x2);
F1 = mvnpdf([X1(:) X2(:)],mu1,Sigma1);
F1 = reshape(F1,length(x2),length(x1));
;
F=F+w1*F1

end

surf(x1,x2,F);
%contour(x1,x2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
%axis([-0.1 0.1 -0.1 0.1 0 100])
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');


end

