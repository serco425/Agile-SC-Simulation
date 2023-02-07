# Agile-SC-Simulation

This repository is for our study accepted in IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems. <br />
(*Agile Simulation of Stochastic Computing Image Processing with Contingency Tables*)

Contributors: PostDoc. Sercan AYGUN, Asst. Prof. M. Hassan NAJAFI, Asst. Prof. Mohsen IMANI, Prof. Ece Olcay GUNES <br />
for further info: sercan.aygun@louisiana.edu

<div align="justify"> Mainly, we aim to simulate stochastic computing (SC) circuits targeted for image processing applications. In this respect, we analyze the contingency table (CT) method for several circuit structures proposing a fast and efficient simulation without using actual bitstreams as conventional SC systems require (so do the traditional simulation approaches.) Since SC circuits work with long bitstreams (e.g., 1024-bit binary packages 1010010101...101), latency and memory issues inevitably occur in a software simulation. We show how CT construct can efficiently simulate SC and degrades the latency. <div align="justify">
<br />
There are four folders in this project:
  
1. Cascaded circuit simulation (Figure 5 (b) in the manuscript)

2. Image processing simulation <br />
  
3. NAND gate-based XOR model for the monitoring of reconvergent paths (*with* and *without* reconvergence) <br />
  
4. 2-bit ripple carry adder circuit structure for the monitoring of reconvergent paths (*with* and *without* reconvergence) <br />
   (arithmetic operation is not the main aim; the complexity of the circuit does matter.) <br />

<br />
  
To give a cite for this project:

@article{agile_SC, <br />
 author = {Aygun, Sercan and Najafi, M. Hassan, and Imani, Mohsen and Gunes, Ece Olcay}, <br />
 title = {Agile Simulation of Stochastic Computing Image Processing with Contingency Tables}, <br />
 journal = {IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems}, <br />
 volume = {XX}, <br />
 number = {XX}, <br />
 year = {20XX}, <br />
 pages = {XX--XX}, <br />
 doi = {10.1109/TCAD.2023.3243136} <br />
}
