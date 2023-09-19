exist INPUTT;
if ans ==0
     INPUTT=zeros([1,4]);
end
I       = 04; % Quant. Neur�nios de Entrada.
H       = 10; % Quant. Nuer�nios Escondidos na 1� Camada.
O       = 01; % Quant. Neur�nios de Sa�da.
SIZE    = (H*(I+O)); % Tamanho do vetor pesos.
R       = 0.05;

M1=reshape(WA(1:I*H),[H,I]);
M2=reshape(WA(I*H+1:SIZE),[O,H]);
INPUTT(1:01,1:4)=[dist(24) dist(23) dist(22) dist(21)];

for i=1:601
AUX1=(M1*(INPUTT(1,1:I)'*R)); % Par�metro para evitar satura��o da fun��o de ativa��o (Normaliza��o).
AUX2=tanh(AUX1);
AUX3=(M2*AUX2);  % Par�metro paraevitar satura��o da fun��o de ativa��o (Normaliza��o).
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