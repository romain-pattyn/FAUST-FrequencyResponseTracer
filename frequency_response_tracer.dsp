declare filename  "frequency_response_tracer.dsp";
declare name      "frequency_response_tracer";
declare author    "Romain Pattyn";
declare version   "1.00";
declare license   "BSD";

import("stdfaust.lib");

//--------------------`frequencyResponse`----------------
// Produces data representing the frequency response of a filter.
//
// #### Usage
//
// ```
// _ : frequencyResponse(filter) : _
// ```
// Where:
//
// * `filter`: A function having one input signal and one output signal  ( _ : filter : _ )
//
// How it works :
//
// It is a direct application of the what the frequency response represents.
// Signals of increasing frequencies are passed through the filter.
// The RMS of the filtered signal is divided by the RMS of the initial signal so as to obtain the gain ratio for each frequency.
// Because the data is average by evaluating the result over a sliding window, there will be a delay of 200 samples in the output.
// This is why in the python script, the graph starts at the 200th sample.
//-------------------------------------------------------------------------

frequencyResponse(filter) = ratio : ba.slidingMeanp(200, 256)
with{
    fmin = 0;
    fmax = ma.SR;
    time = 1;

    // li := Function generating increasing numbers between fmin and fmax in time*SR samples.
    // Ther function is used in its general form with the two cases : f1>f2 and f1<f2.
    // Eventough in our case it could be simplified since we know that f1<f2.

    li(f1, f2, time) = (line<:_,_*(-1):select2(f1>f2)+f1),f1:select2(f1==f2)
    with{
        step = abs(f2-f1)/(time*ma.SR);
        line = _~+(step):%(abs(f2-f1));
    };

    ratio = os.osc(li(fmin, fmax, time)) <: (filter : ba.slidingRMSp(20, 32)), ba.slidingRMSp(20, 32) : /;
};



//--------------------`Example of Use`----------------
//
// The frequency response tracer is applied to various filters available in the FAUST library.
//
//-------------------------------------------------------------------------------------------

// High shelf with bit of resonance in the low frequencies
highShelf(f) = fi.highshelf(5, -6, f);

// Simple peakEQ
peakEQ(f) = fi.peak_eq(2, f, 500);


// Also in highpass an bandpass: resonhp and resonbp (Remark : the bandpass version is like a peakEQ with the gain at zero for ther frequencies that the one wanted. So it's not possible to actually produce a band between two frequencies. See fi.bandpass)
resonanceLowPass(f) = fi.resonlp(f, 1, 1);

lowPassSimple(f) = fi.lowpass(5, f); // A little bit more vertical than lowpass3e but the frequency parameter isn't at the top of the curve, it is at -3dB.
lowPassAdvanced(f) = fi.lowpass6e(f); // Also highpass : highpass6e (Both available in 3th order which make the cut less vertical)

// Also available in bandstop
butterworthBandpass(nH, fl, fu) = fi.bandpass(nH, fl, fu); // Increasing nH makes the cut more vertical.
ellipticBandPass(fl, fu) = fi.bandpass12e(fl, fu);

process =   frequencyResponse(highShelf(1000)),
            frequencyResponse(peakEQ(2000)),
            frequencyResponse(resonanceLowPass(3000)),
            frequencyResponse(lowPassSimple(6000)),
            frequencyResponse(lowPassAdvanced(7500)),
            frequencyResponse(butterworthBandpass(2, 10000, 13000)),
            frequencyResponse(butterworthBandpass(6, 10000, 13000)),
            frequencyResponse(ellipticBandPass(10000, 13000));
