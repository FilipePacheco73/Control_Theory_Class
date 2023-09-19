exist INPUTT;
if ans ==0
     INPUTT=zeros([1,4]);
end
I       = 04; % Quant. Neurônios de Entrada.
H       = 10; % Quant. Nuerônios Escondidos na 1ª Camada.
O       = 01; % Quant. Neurônios de Saída.
SIZE    = (H*(I+O)); % Tamanho do vetor pesos.
R       = 0.05;

M1=reshape(WA(1:I*H),[H,I]);
M2=reshape(WA(I*H+1:SIZE),[O,H]);
INPUTT(1:01,1:4)=[dist(24) dist(23) dist(22) dist(21)];

for i=1:601
AUX1=(M1*(INPUTT(1,1:I)'*R)); % Parâmetro para evitar saturação da função de ativação (Normalização).
AUX2=tanh(AUX1);
AUX3=(M2*AUX2);  % Parâmetro paraevitar saturação da função de ativação (Normalização).
AUX4=(1/R)*tanh(AUX3);
AUX444(i)=AUX4;
INPUTT=flip(INPUTT);
for i=1:3
    INPUTT(i)=INPUTT(i+1);
end
    INPUTT(4)=AUX4;
    INPUTT=flip(INPUTT);
end

plot(AUX444);