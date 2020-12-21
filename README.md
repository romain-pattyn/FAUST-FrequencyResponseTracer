# FAUST-FrequencyResponseTracer

## What ?
This is a project that traces the frequency response of a filter implemented in Faust. By filter, what is really meant, is a function that has a 1D signal as input, and outputs a 1D signal too.

Several examples are shown in the Faust file using some of the basic filters available in Faust.


## For who ?
For mac users having python, numpy and matplolib installed.


## How to use ?

Warp the your filter with the function called "frequencyResponse" in the file : "frequency_response_tracer.dsp". Then export the result using the osx/plot option in the Faust compiler. This will produce a folder containing 2 files. A ".dsp" file that you don't really need, and an executable. Drag the executable (which should be called "frequency_response_tracer") in the main folder of this porject and type make in the command line. Then put the generated  file in the folder. And type "make" in the command line.

By default, all the frequencies will be traced. (i.e. from 0Hz to 44100Hz). But one can specify the range of frequencies wanted :

> make N=300

will trace the frequency response from 0Hz to 300Hz.

## How does it work ?

TODO
