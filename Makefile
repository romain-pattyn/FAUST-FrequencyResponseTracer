
N?=44100

all : data_creation data_plotting data_deletion tracer_saving

data_creation : frequency_response_tracer
	./frequency_response_tracer -n $(N) > data
data_plotting : NumpyDataPlot.py data
	python3 NumpyDataPlot.py -f data
data_deletion :
	rm data
tracer_saving :
	mv frequency_response_tracer frequency_response_tracer_prev
