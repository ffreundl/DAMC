load Data.mat

%%Parition et PCA
%on prends tous les features des premiers 70% samples (donc 70% des données
%depuis le début de l'expérience)
training_set = Data(1:9003,:);

%pour le test set on prends les 30 derniers % de l'expérience.
test_set = Data(9004:12862,:);

normalization = 1;

%on fait une PCA sur le training set dont on applique les coefficients sur
%le test-set. testScore retourne le test set projeté sur l'espace des PCs.
[coeff,trScore,testScore,var,mu,sigma]=pca2(training_set,test_set,normalization);


%% Regrssion linéaire

%on choisit les features sur lesquels on veut travailler pour établir notre
%modèle. On choisit ici tout les features.
FeatureMatrix=training_set;

%y soit la variable qu'on veut trouver par régression y = ax+b corresponds
%à la position X pour les premiers 70% des samples
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