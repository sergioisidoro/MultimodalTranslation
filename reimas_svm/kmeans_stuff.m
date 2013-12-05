
addpath  gmm/GMM-GMR-v2.0/

obsdata=[]
obsdata2d=[]
obsoccvect=[]
classdata=[]
classdata=[]
class=0

gmms={};
gmms2d={};


% Dimensions to use for GMM
dim=5;

% Required data points for a word to be included
countthr=5;

% For random projection:
k=9

rprojector=rand(k,602);
%sum(rprojector,1);
%repmat(sum(rprojector,1),k,1);

size(rprojector)
size(motion_features')
%rprojector=rprojector./repmat(sum(rprojector,1),k,1);

rprojector=rprojector./repmat(sum(rprojector,2),1,602);

motion_features_proj=(rprojector*motion_features);

for v=1:length(verb_index)
 verb=verb_index{v};
 verbdata=[];
 verboccvect=zeros(124,1);
 for i=1:length(verb_list)
  if strcmp(verb_list{i,1},verb)
    if length(verbdata>0)
        verbdata=[verbdata; motion_features(:,verb_list{i,3})'];
        verbdata2d=[verbdata2d; coeff(verb_list{i,3},1:dim)];
        verboccvect(verb_list{i,3})=verboccvect(verb_list{i,3})+1;
    else
      verbdata =motion_features(:,verb_list{i,3})';
      verbdata2d = coeff(verb_list{i,3},1:dim);
      verboccvect(verb_list{i,3})=verboccvect(verb_list{i,3})+1;
    end
  end
 end
 if (size(verbdata,1) > countthr)
   class=class+1;
   if length(classdata>0)   
      obsdata=[obsdata; verbdata];
      obsdata2d=[obsdata2d; verbdata2d];
      classdata=[classdata; class*ones(size(verbdata,1),1)];
   else
      obsdata=verbdata;
      obsdata2d=verbdata2d;
      classdata=class*ones(size(verbdata,1),1);
   end
      

   nbStates= min(min ( ceil(size(verbdata,1)/100),5 ) ,length(unique(verbdata(:,1))-1))

   %size(verbdata2d)
   %size(verbdata)
%   [Priors, Mu, Sigma] = EM_init_kmeans(verbdata', nbStates);
%   [Priors, Mu, Sigma] = EM(verbdata', Priors, Mu, Sigma);

   disp(['verbdata: ',num2str(size(verbdata))]);
   options = statset('Display','final');
   obj = gmdistribution.fit(verbdata2d,nbStates,'Options',options, ...
                            'Regularize',1E-4,'Replicates',20)%,'CovType','diagonal');


%   obj=gmdistribution(Mu',Sigma,Priors);

   %[muhat, sigmahat]=normfit(eng_verbdata);
   %singleg={muhat,sigmahat}
   singleg={mean(verbdata2d), cov(verbdata2d)};


   gmms2d{class}={obj, singleg, verbdata2d, verboccvect./sum(verboccvect(:)),verboccvect(1:24)./sum(verboccvect(1:24)),verb}

%   [Priors, Mu, Sigma] = EM_init_kmeans(verbdata', nbStates);
%   [Priors, Mu, Sigma] = EM(verbdata', Priors, Mu, Sigma);
%   gmms{class}={Priors, Mu, Sigma, verb}

 end
end



eng_obsdata=[]
eng_obsdata2d=[]
eng_obsoccvect=[]
eng_classdata=[]
eng_classdata=[]
eng_class=0

eng_gmms={}
eng_gmms2d={}

for v=1:length(eng_verb_index)
 eng_verb=eng_verb_index{v}
 eng_verbdata=[];
 eng_verboccvect=zeros(124,1);
 for i=1:length(eng_verb_list)
  if strcmp(eng_verb_list{i,1},eng_verb)
    if length(eng_verbdata)>0
        eng_verbdata=[eng_verbdata; motion_features,(:,verb_list{i,3})'];
        eng_verbdata2d=[eng_verbdata2d; coeff(verb_list{i,3},1:dim)];
        eng_verboccvect(eng_verb_list{i,3}) =eng_verboccvect(verb_list{i,3})+1;
    else
      eng_verbdata =motion_features(:,eng_verb_list{i,3}');
      eng_verbdata2d = coeff(eng_verb_list{i,3},1:dim);
      eng_verboccvect(eng_verb_list{i,3})=eng_verboccvect(verb_list{i,3})+1;
    end
  end
 end
 size(eng_verbdata)
 if (size(eng_verbdata,1) > countthr)
   eng_class=eng_class+1;
   if length(eng_classdata>0)   
      eng_obsdata=[eng_obsdata; eng_verbdata];
      eng_obsdata2d=[eng_obsdata2d; eng_verbdata2d];
      eng_classdata=[eng_classdata; class*ones(size(eng_verbdata,1),1)];
   else
      eng_obsdata=eng_verbdata;
      eng_obsdata2d=eng_verbdata2d;
      eng_classdata=class*ones(size(eng_verbdata,1),1);
   end


   %[muhat, sigmahat]=normfit(eng_verbdata2d);
   %singleg={muhat,sigmahat}
   singleg={mean(eng_verbdata2d), cov(eng_verbdata2d)};
   
   nbStates= min(min ( ceil(size(eng_verbdata,1)/100),5 ) ,length(unique(eng_verbdata(:,1))-1))
   size(eng_verbdata2d)
   size(eng_verbdata)

   options = statset('Display','final');
   obj = gmdistribution.fit(eng_verbdata2d,nbStates,'Options',options,'Regularize',1E-4,'Replicates',20)%,'CovType','diagonal');

%   [Priors, Mu, Sigma] = EM_init_kmeans(eng_verbdata', nbStates);
%   [Priors, Mu, Sigma] = EM(eng_verbdata', Priors, Mu, Sigma);
%   obj=gmdistribution(Mu',Sigma,Priors);

   eng_gmms2d{eng_class}={obj, singleg, eng_verbdata2d, eng_verboccvect./ ...
                       sum(eng_verboccvect(:)),  eng_verboccvect(1:24)./ ...
                       sum(eng_verboccvect(1:24)),eng_verb}

%   [Priors, Mu, Sigma] = EM_init_kmeans(verbdata', nbStates);
%   [Priors, Mu, Sigma] = EM(verbdata', Priors, Mu, Sigma);
%   gmms{class}={Priors, Mu, Sigma, verb}
 else
   disp (['prob with ',eng_verb,': ',num2str(size(eng_verbdata,1))]);
 end
end


verbcosdists=zeros(length(eng_gmms2d),length(gmms2d));
verbcosdists24class=zeros(length(eng_gmms2d),length(gmms2d));

for i=1:length(eng_gmms2d)
 for j=1:length(gmms2d)
  verbcosdists24class(i,j)=pdist([eng_gmms2d{i}{5}';gmms2d{j}{5}'],'cosine');
  verbcosdists(i,j)=pdist([eng_gmms2d{i}{4}';gmms2d{j}{4}'],'cosine');
 end
end

disp('cosine dist translations')
for i=1:length(eng_gmms2d)
  besttranslation=find( verbcosdists(i,:) == ...
                        min(verbcosdists(i,:)));

   disp([num2str(i),': ',eng_gmms2d{i}{6},': ', ...
         gmms2d{besttranslation(1)}{6}])
   if length(besttranslation)>1
     disp('wait, there is more')
   end   
end

if 0 == 9
verbanalyticalkldists=zeros(length(eng_gmms2d),length(gmms2d));

for i=1:length(eng_gmms2d)
 for j=1:length(gmms2d)
     mu0=eng_gmms2d{i}{2}{1}';
     mu1=gmms2d{j}{2}{1}';

     sigma0=eng_gmms2d{i}{2}{2};
     sigma1=    gmms2d{j}{2}{2};

     dkl1=0.5*(trace(inv(sigma1)*sigma0)+(mu1-mu0)'*inv(sigma1)*(mu1- ...
                                                       mu0)-602-log(det(sigma0)/det(sigma1)));
     dkl2=0.5*(trace(inv(sigma0)*sigma1)+(mu0-mu1)'*inv(sigma0)*(mu0- ...
                                                       mu1)-602-log(det(sigma1)/det(sigma0)));
     verbanalyticalkldists(i,j)=dkl1+dkl2/2;

  end
end


disp('analytical kl')
for i=1:length(eng_gmms2d)
  besttranslation=find( verbanalyticalkldists(i,:) == ...
                        min(verbanalyticalkldists(i,:)));

   disp([num2str(i),': ',eng_gmms2d{i}{6},': ', ...
         gmms2d{besttranslation(1)}{6}])
   if length(besttranslation)>1
     disp('wait, there is more')
   end
end

end

%X = mvnrnd(mu,SIGMA,10); 
%p = mvnpdf(X,mu,SIGMA); 

verbkldists=zeros(length(eng_gmms2d),length(gmms2d))
%verbkldists24class=zeros(length(eng_gmms2d),length(gmms2d))


montecount=100000;
for i=1:length(eng_gmms2d)
  for j=1:length(gmms2d)
      gmm1=eng_gmms2d{i}{1};
      gmm2=    gmms2d{j}{1};

      samples=random(gmm1,montecount);

      kl1=mean(log(pdf(gmm1,samples)))/2;
      kl2=mean(log(pdf(gmm2,samples)))/2;

      samples=random(gmm2,montecount);      
      
      kl3=mean(log(pdf(gmm1,samples)))/2;
      kl4=mean(log(pdf(gmm2,samples)))/2;
      
      verbkldists(i,j)=abs(kl1-kl2+kl3-kl4)
      verbkldists(isinf(verbkldists))=NaN
   end

    %   verbkldists24class(i,j)=pdist([eng_gmms2d{i}{5}'; ...
    %                  gmms2d{j}{5}'],'cosine');

end

for i=1:length(eng_gmms2d)
  besttranslation=find( verbkldists(i,:) == ...
                       min(verbkldists(i,:)));

   disp([num2str(i),': ',eng_gmms2d{i}{6},': ', ...
         num2str(besttranslation(1)), ': ', ...
         gmms2d{besttranslation(1)}{6}])
   if length(besttranslation)>1
     disp('wait, there is more')
   end
end


if 0 == 1


i=1
dims=[3,4]

subplot(1,2,1)
%x1 = -0.1:0.005:0.1; x2 = -0.1:0.005:0.1;
x1 = -0.5:0.01:0.5; x2 = -0.5:0.01:0.5;
F=zeros(length(x1),length(x2));

for c=1:length(gmms2d{i}{1}.PComponents)
w1=gmms2d{i}{1}.PComponents(c)
mu1=gmms2d{i}{1}.mu(c,dims)
Sigma1=gmms2d{i}{1}.Sigma(dims,dims,c)
%Sigma1=diag(gmms2d{i}{1}.Sigma(:,1:2,c))

[X1,X2] = meshgrid(x1,x2);
F1 = mvnpdf([X1(:) X2(:)],mu1,Sigma1);
F1 = reshape(F1,length(x2),length(x1));

F=F+w1*F1

end


surf(x1,x2,F);
%contour(x1,x2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
%axis([-0.1 0.1 -0.1 0.1 0 100])
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');

subplot(1,2,2)
%x1 = -0.1:0.005:0.1; x2 = -0.1:0.005:0.1;
F=zeros(length(x1),length(x2));

for c=1:length(eng_gmms2d{i}{1}.PComponents)
w1=eng_gmms2d{i}{1}.PComponents(c)
mu1=eng_gmms2d{i}{1}.mu(c,dims)
Sigma1=eng_gmms2d{i}{1}.Sigma(dims,dims,c)
%Sigma1=diag(eng_gmms2d{i}{1}.Sigma(:,1:2,c))


[X1,X2] = meshgrid(x1,x2);
F1 = mvnpdf([X1(:) X2(:)],mu1,Sigma1);
F1 = reshape(F1,length(x2),length(x1));

F=F+w1*F1

end

surf(x1,x2,F);
%contour(x1,x2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
%axis([-0.1 0.1 -0.1 0.1 0 100])
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');


end

