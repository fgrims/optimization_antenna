# Direction of Arrival Estimation and Beamforming

Questo è un progetto universitario in MATLAB ha come obiettivo la simulazione del comportamento di un'antenna adattiva per raggiungere due scopi: identificare le direzioni di arrivo di un incognito numero di segnali e successivamente ottimizzare la ricezione del segnale desiderato, minimizzando l'interferenza dovuta ai restanti. 

Per stimare il numero dei segnali e le loro direzioni di arrivo è stato implementato l'algoritmo MUSIC (MUltiple SIgnal Classification). Dalle informazioni ottenute è stato possibile applicare due approcci per l'ottimizzazione dei pesi dei singoli elementi dell'antenna adattiva ed effettuato un confronto finale dei risultati. Il primo metodo è basato sull'algoritmo di ottimizzazione collettiva PSO e il secondo sull'uso della decomposizione ai valori singolari.  

## Features

- Utilizzo di un'antenna adattiva in ricezione
- Generazione di segnali ad una data frequenza [Hz] 
- Detection del numero di segnali e delle loro direzioni di arrivo rispetto l'antenna
- PSO e SVD per ottimizzazione dei pesi dell'antenna 
- Massimizzazione della ricezione di un dato segnale
- Minimizzazione dell'interferenza dei segnali indesiderati

## How it works 

Il primo passo è la generazione dei segnali con cui effettuare le simulazioni, specificandone la frequenza in Hz. Nel codice viene specificato il numero di segnali da generare e le direazioni di arrivo (angolo in gradi tra -90° e +90°) in maniera casuale. 

```matlab
function x = GenSignal(M, fc)
lambda = physconst('LightSpeed')/fc;
array = phased.ULA('NumElements',M,'ElementSpacing',lambda/2);
array.Element.FrequencyRange = [8e8 1.2e9]; 

N = 200; % number of samples
r = 8; % number of signals (it can be random)    
sig = zeros(N, r); 
angle_of_arrival = zeros(2,r); 
for ii=1:r 
    sig(:, ii) = (rand(1,N)-0.5 +1i*rand(1,N))';
    % generate random angle for the ii-th signal
    angle_of_arrival(1, ii) = randi([-90, 90], 1, 1); 
end
disp("angles of arrival: ");
disp(angle_of_arrival);
x = collectPlaneWave(array,sig,angle_of_arrival,fc)';
end 
```
---

I segnali così generati vengono elaborati dall'algoritmo MUSIC. Esso calcola:

- Un grafico degli autovettori dei segnali, tramite il quale è possibile identificarne il numero osservando quelli maggiori. 
- Un grafico che presenta dei picchi in corrispondenza delle direzioni di arrivo dei segnali.

![autovalori_MUSIC](https://github.com/fgrims/optimization_antenna/assets/102296489/75941591-f2f2-4cf0-ad27-8ecf64d238db)

![PMU](https://github.com/fgrims/optimization_antenna/assets/102296489/0a65436a-9e2e-4aa9-9a0e-e6547676bf99)

---


I pesi dell'antenna sono stati progettati risolvendo il seguente problema di ottimizzazione ai minimi quadrati:
 
$$w^{\ast }=\min _{w}\left\| b-Aw\right\| _{2}$$

Dove: 

- **w*** sono i pesi ottimizzati.
- **b** vettore sparso arbitrario con un unico valore diverso da 0 nella posizione corrispondente al segnale desiderato.
- **A** matrice degli steering vector.

Gli approcci usati sono: PSO e SVD. 

L'algoritmo PSO è stato implementato fornendo la totalità dei segnali con i relativi angoli, di cui soltanto uno rappresenta quello desiderato (xs). I parametri dell'algoritmo utilizzati:   

- **n_birds** = numero di uccelli = 200. 
- **numero di iterazioni** = 10000. 
- **peso individualità** = 1. 
- **peso socialità** = 1. 
- **peso dell'inerzia** = 0.9, con diminuzione dello 0.01% ad ogni iterazione. 

Il secondo approccio risolve il problema di ottimizzazione definendo la decomposizione ai valori singolari della matrice **A** e calcolando la pseudo-inversa di Moore. 

Entrambi gli approcci forniscono come risultato i pesi ottimizzati e grafici che raffigurano il radiation pattern dell'antenna per tali pesi. 

---

## Results

I risultati delle simulazioni mostrano i radiation pattern ottenuti dai due approcci. Si nota da essi che l'SVD fornisce risultati notevolmente migliori rispetto al PSO.  



![res](https://github.com/fgrims/optimization_antenna/assets/102296489/8d030a1c-70b8-4f1e-baaa-122940a0dfe0)
