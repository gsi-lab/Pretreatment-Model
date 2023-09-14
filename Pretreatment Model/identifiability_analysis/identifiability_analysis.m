%IDENTIFIABILITY ANALYSIS FOR DILUTE ACID PRETREATMENT MODEL OF WHEAT STRAW
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

addpath("../model_mechanistic")
addpath("../parameter_estimation_main")
addpath("../experimental_data")

[par,x0] = initcond_pretreatment();

load("dataPTM","Temperature","acid","time")


idy=[1,2,3,4,5,6,7,8,9,10,11,12]; % y = [Xyn,Xyl,Cel,Glu,Arn,Ara,Act,Fac,Aac,HMF,Fur,Deg]
idx=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]; %  theta= [A_1-8, E_1-8, n_1-8]
idym = [2,4,6,8,9,10,11];
m=length(idx);
fs=length(idy);

doe = length(time); %number of points in DoE

%%

psa = par; pert = 0.1 * ones(m,1);

dydpc_doe = zeros(doe,fs,m);
for i=1:doe
    t0 = 0;
    tf=time(i); 
    ts=t0:(tf/99):tf;
    stats = [Temperature(i),acid(i)];
    [t, y, dydpc,dydpf,dydpb] = sa(ts,x0,psa,idx,pert,stats) ; % perform local sensitivity analysis
    dydpc_end = dydpc(end,:,:);
    dydpc_doe(i,:,:) = dydpc_end;
end

n=length(t); [it,iy] = size(y) ;
lx = {'Xylan', 'Xylose', 'Cellulose','Glucose',...
    'Arabinan', 'Arabinose', 'Acetyls', 'Formic Acid', 'Acetic Acid', ...
    '5HMF', 'Furfural','Degradation products'};

ly = {'Xyn', 'Xyl', 'Cel', 'Glu', 'Arn', 'Ara', 'Act', 'Fac', 'Aac', 'HMF', 'Fur', 'Deg'};

lp = {'A_{XynXyl}', 'A_{CelGlu}', 'A_{ArnAra}','A_{ActAac}', ...
      'A_{GluHMF}', 'A_ {HMFFur}','A_{Fur}', 'A_{Deg}', ...
      'E_{XynXyl}', 'E_{CelGlu}', 'E_{ArnAra}','E_{ActAac}', ...
      'E_{GluHMF}', 'E_ {HMFFur}','E_{Fur}', 'E_{Deg}', ...
      'n_{XynXyl}', 'n_{CelGlu}', 'n_{ArnAra}','n_{ActAac}', ...
      'n_{GluHMF}', 'n_{HMFFur}','n_{Fur}', 'n_{Deg}'};
  
lf = {'A_{XynXyl}', 'A_{CelGlu}', 'A_{ArnAra}','A_{ActAac}', ...
      'A_{GluHMF}', 'A_ {HMFFur}','A_{Fur}', 'A_{Deg}', ...
      'E_{XynXyl}', 'E_{CelGlu}', 'E_{ArnAra}','E_{ActAac}', ...
      'E_{GluHMF}', 'E_ {HMFFur}','E_{Fur}', 'E_{Deg}', ...
      'n_{XynXyl}', 'n_{CelGlu}', 'n_{ArnAra}','n_{ActAac}', ...
      'n_{GluHMF}', 'n_{HMFFur}','n_{Fur}', 'n_{Deg}'};

zerotol = 1e-6;

%%
sa=dydpc_doe;
psa=par(idx); 
sc=ones(1,iy); 
snd=[];snorm=[]; dmsqr=[];temp2=[];
estparcomb = ones(m,iy);

% 
for i =1:m % for each parameter
    temp1=[]; temp2=[];
    for j =1:iy; %variable.
        %temp1 = dydpc_end(:,j,i); %absolute sa
        temp1 = dydpc_doe(:,j,i);
        temp2=temp1(:).*(psa(i)/sc(j)); %non-dimensional sa
        snd(:,j,i) = temp2; %non-dimensional sa
        dmsqr(i,j) = sqrt((temp2'*temp2)/length(temp2)); % delta mean squared value
        if norm(temp2) == 0
            snorm(:,j,i) = 0;
        else
            snorm(:,j,i) = temp2/norm(temp2);
        end
 %      snorm(:,j,i) = temp2/norm(temp2); % normalized sa
        %estimatbility of parameter i by variable j
        if abs(max(temp1)) < zerotol
            estparcomb(i,j) = 0;
        end
    end
end

figure % figure5.11
for i=1:fs
    yy=[1,2,3,4,5,6,7,8,9,10,11,12]; % select the outputs
    x = dmsqr(:,yy(i));
    [r1(:,i) i1(:,i)] = sort(x,'descend');
    rx(:,i) = x(i1(:,i));
    subplot(4,3,i)
    bar(sort(x,'descend'),'w')
    for j=1:m
        text(j,0.2 + r1(j,i),lp{i1(j,i)})
    end
    ylabel('\delta^{msqr}')
    if i==4
        xlabel('Importance rank')
    end
    title(lx{yy(i)})
    set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold')
    ylim([0 max(x)*1.1])
end

dmsqr_r = dmsqr(:,idym);
dmsqr_sum = sum(dmsqr_r,2);
ld=length(dmsqr_sum);

dmsqr_sum_indices = [dmsqr_sum idx.'];
dmsqr_sum_indices = sortrows(dmsqr_sum_indices,1,'descend');
dmsqr_sum_indices = dmsqr_sum_indices.';

figure;
bar(dmsqr_sum_indices(1,:),'w');
for j=1:ld   
    dmsqr_sum_indices(2,j);
    lp(idx(dmsqr_sum_indices(2,j)));
    text(j, 0.5 + dmsqr_sum_indices(1,j), lp(dmsqr_sum_indices(2,j)));
end
ylabel('\Sigma\delta^{msqr}');
%if i==4
%    xlabel('Importance rank')
%end
%title(lx{yy(i)})
set(gca,'LineWidth',2,'FontSize',12,'FontWeight','bold');
    

%%
snormy2(:,:)=snorm(:,2,:); % 
snormy4(:,:)=snorm(:,4,:); % 
snormy6(:,:)=snorm(:,6,:); %  
snormy8(:,:)=snorm(:,8,:); % 
snormy9(:,:)=snorm(:,9,:); % 
snormy10(:,:)=snorm(:,10,:); % 
snormy11(:,:)=snorm(:,11,:); %

snormy=[snormy2;snormy4;snormy6;snormy8;snormy9;snormy10;snormy11];

%total number of parameter combinations
for r=2:m
    cmb(r,1) = factorial(m) / (factorial(m-r)*factorial(r)) ;
end
count = sum(cmb) ;  pcomb=zeros(count,m); % we create empty (zeros) matrix for parameter combinations
colsum = [];set=idx;SubsetK=[];SubsetSize=[];SubsetCol=[];k = 0; % index counter
for i = 2:m
    combos = combnk(set,i); % all possible pairing of parameters with different sizes (2,3,4...)
    [n mm] = size(combos); subs = [];
    for j=1:n
        k=k+1;
        pix=combos(j,:)-idx(1)+1; % reset the index counter to 1.
        tempn   = snormy(:,pix) ; % select vector of normSA.
        nsm     = tempn'*tempn;  % normalized sensitivity matrix
        nanm = isnan(nsm);
        if any(nanm == 1)
            SubsetCol(k,1) = NaN;
        else
            SubsetCol(k,1)     = 1/sqrt(min(eig(nsm))); % collinearity index
        end
        pcomb(k,1:mm)=combos(j,:);
        spcomb{k,:}=lf(combos(j,:));
        SubsetK(k,1)=k;
        SubsetSize(k,1)=i;
    end
end


T = table(SubsetK,SubsetSize,spcomb,SubsetCol,'VariableNames',{'SubsetK','SubsetSize','SubsetCombnts','GammaK'});

save("IA_Pretreatment", 'pcomb', 'spcomb', 'T')

