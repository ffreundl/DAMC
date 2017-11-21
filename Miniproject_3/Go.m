load Data.mat

%%Parition et PCA
%on prends tous les features des premiers 70% samples (donc 70% des donn�es
%depuis le d�but de l'exp�rience)
training_set = Data(1:9003,:);

%pour le test set on prends les 30 derniers % de l'exp�rience.
test_set = Data(9004:12862,:);

normalization = 1;

%on fait une PCA sur le training set dont on applique les coefficients sur
%le test-set. testScore retourne le test set projet� sur l'espace des PCs.
[coeff,trScore,testScore,var,mu,sigma]=pca2(training_set,test_set,normalization);


%% Regrssion lin�aire

%on choisit les features sur lesquels on veut travailler pour �tablir notre
%mod�le. On choisit ici tout les features.
FeatureMatrix=training_set;

%y soit la variable qu'on veut trouver par r�gression y = ax+b corresponds
%� la position X pour les premiers 70% des samples
y = PosX(1:9003);

%
FM = FeatureMatrix(1:9003,:);

I = ones(size(y(1:9003),1),1);

%x corresponds a nos features auquels on rajoute une colonne de 1 devant
X= [I FM];

b = regress(y,X);

disp(immse(y,X*b));

y=PosX(9004:12862);

I=ones(size(y(1:3859),1),1);

FeatureMatrix=test_set;

FM = FeatureMatrix(1:3859,:);

X = [I FM];


disp(immse(y,X*b));