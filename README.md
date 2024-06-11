# Direction of Arrival Estimation and Beamforming

This MATLAB-based university project aims to simulate the behavior of an adaptive antenna to achieve two primary objectives: to identify the directions of arrival of an unknown number of signals and to optimize the reception of a desired signal while minimizing interference from other signals.

The **MUSIC** (MUltiple SIgnal Classification) algorithm was implemented to estimate the number of signals and their directions of arrival. The information obtained enabled the application of two methods to optimize the weights of the individual elements of the adaptive antenna, followed by a comparative analysis of the results. The first method is based on the **Particle Swarm Optimization** (PSO) algorithm, while the second utilizes **Singular Value Decomposition** (SVD).

## Features

- Utilization of an adaptive receiving antenna
- Generation of signals at a specified frequency [Hz]
- Detection of the number of signals and their directions of arrival relative to the antenna
- PSO and SVD for optimizing the antenna weights
- Maximization of the reception of a specified signal
- Minimization of interference from undesired signals

## How it works 

The first step involves generating signals for the simulations, specifying their frequency in Hz. The code generates the signals randomly, specifying their number and directions of arrival (angles in degrees between -90° and +90°).

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

The generated signals are processed by the MUSIC algorithm, which performs the following tasks:

- It produces a graph of the signal eigenvectors, allowing the identification of the number of signals by observing the prominent eigenvalues.
- It generates a graph with peaks corresponding to the directions of arrival of the signals.

<div align="center">
    <img src="https://github.com/fgrims/optimization_antenna/assets/102296489/75941591-f2f2-4cf0-ad27-8ecf64d238db" alt="autovalori_MUSIC">
</div>
<div align="center">
    <img src="https://github.com/fgrims/optimization_antenna/assets/102296489/0a65436a-9e2e-4aa9-9a0e-e6547676bf99" alt="PMU">
</div>



The antenna weights were optimized by solving the following least squares optimization problem:
 
$$w^{\ast }=\min _{w}\left\| b-Aw\right\| _{2}$$

Where: 

- **w*** are the optimized weights.
- **b** is an arbitrary sparse vector with a single non-zero value at the position corresponding to the desired signal.
- **A** is the matrix of steering vectors.

Two optimization approaches were employed: PSO and SVD. 

The PSO algorithm was implemented using the complete set of signals and their respective angles, with only one signal being the desired one (*xs*). The parameters used for the PSO algorithm were:

- **n_birds** (number of particles) = 200
- **number of iterations** = 10000
- **individuality weight** = 1
- **sociality weight** = 1
- **inertia weight** = 0.9, decreasing by 0.01% with each iteration

The SVD approach involves solving the optimization problem by performing Singular Value Decomposition on the matrix A and calculating the Moore-Penrose pseudoinverse.

Both approaches yield optimized weights and produce graphs illustrating the radiation pattern of the antenna for these weights.


## Results

The simulation results demonstrate the radiation patterns obtained from both approaches. The SVD method provides significantly better results compared to the PSO method, as evidenced by the superior radiation patterns.

<div align="center">
    <img src="https://github.com/fgrims/optimization_antenna/assets/102296489/8d030a1c-70b8-4f1e-baaa-122940a0dfe0" alt="res">
</div>

In conclusion, the project successfully implements and compares two optimization techniques for adaptive antenna beamforming, highlighting the effectiveness of the SVD approach over PSO in this context.

# Authors and acknowledgment

This project was developed by Aniello Di Donato and Francesco Grimaldi as part of the university courses: "Optimization Methods" and "Electromagnetic Technologies for Transmission Systems". Special thanks to Professor Adriana Brancaccio for her support throughout the project. 

# Contact Information

## Francesco Grimaldi

- Email: fr.grimaldi@outlook.com
- LinkedIn: http://linkedin.com/in/francesco-grimaldi-637a5428a
- GitHub: https://github.com/fgrims

## Aniello Di Donato
- Email: aniellodidonato4@outlook.it
- GitHub: https://github.com/AnielloDD
