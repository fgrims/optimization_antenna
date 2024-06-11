% questo codice si preoccupa della generazione di un segnale di ampiezza A,
% frequenza fc e che incide con un angolo teta sull'elemento di riferimento
% di un'antenna adattiva. Dopo di che effettua il calcolo dei segnali 
% ricevuti dagli M elementi dell'antenna.  

function x = GenSignal(M, fc)
lambda = physconst('LightSpeed')/fc;
array = phased.ULA('NumElements',M,'ElementSpacing',lambda/2);
array.Element.FrequencyRange = [8e8 1.2e9]; 

N = 200; % numero campioni 
r = 8; %randi([2,10]); % numero casuale di segnali in ricezione  
sig = zeros(N, r); 
angle_of_arrival = zeros(2,r);
for ii=1:r 
    sig(:, ii) = (rand(1,N)-0.5 +1i*rand(1,N))';
    %genera un angolo casuale per il segnale ii-esimo
    angle_of_arrival(1, ii) = randi([-90, 90], 1, 1); 
end
disp("angles of arrival: ");
disp(angle_of_arrival);
x = collectPlaneWave(array,sig,angle_of_arrival,fc)';
end 