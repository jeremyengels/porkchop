# Porkchop Plot Generator

A porkchop plot is a tool used by mission designers to calculate the best time to launch an interplanetary spacecraft. These plots are a simple concept — for a range of departure dates (e.g. from Earth) and arrival dates (e.g. to Mars) simply plot the total Delta-V required for the departure and arrival burns at each pair of departure and arrival dates.

However despite the simplicity there is quite a lot of computation under the hood that is necessary to generate these plots. Namely, at each departure and arrival date pair, the ephemerides of both planets must be known, and then Lambert's problem must be solved to calculate a transfer trajectory. 

I was fascinated by these plots so I sought out to generate them myself.

#### Propogating Planetary Orbits 

#### Solving Lambert's Problem 



![porkchop plot](porkchop.pdf)