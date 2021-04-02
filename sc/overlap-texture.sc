/* SC3 variants of OverlapTexture &etc. - rd */

RTexture {

    *add_env {
        arg newEventFunc, i;
        ^{
            var sustainTime = NamedControl.kr(name: 'sustainTime', values: 4);
            var transitionTime = NamedControl.kr(name: 'transitionTime', values: 1);
            var env = Env.new(levels: [0,1,1,0], times: [transitionTime,sustainTime,transitionTime], curve: \sin);
            var amp = EnvGen.kr(envelope: env, gate: 1, levelScale: 1, levelBias: 0, timeScale: 1, doneAction: 2);
            Out.ar(bus: 0, channelsArray: newEventFunc.value(i) * amp);
        };
    }

    *spawn {
        arg newEventFunc, numChannels = 2, nextTime, maxRepeats = inf, postProcess = nil, bus = 0;
        Task.new(func: {
            maxRepeats.do({
                arg i;
                {Out.ar(bus: 0, channelsArray: newEventFunc.(i))}.play;
                nextTime.value.wait;
            });
        }).play;
        if(postProcess.notNil,{RTexture.post_process(treatment: postProcess, bus: bus, numChannels: numChannels)});
    }

    *xfade {
        arg newEventFunc, sustainTime = 4.0, transitionTime = 4.0, numChannels = 2, maxRepeats = inf, postProcess = nil, bus = 0;
        var period = sustainTime + transitionTime;
        Task.new(func: {
            maxRepeats.do({
                arg i;
                RTexture.add_env(newEventFunc: newEventFunc,i: i).play(args:[
                    \sustainTime: sustainTime,
                    \transitionTime: transitionTime]);
                period.wait;
            });
        }).play;
        if(postProcess.notNil,{RTexture.post_process(treatment: postProcess, bus: bus, numChannels: numChannels)});
    }

    *overlap {
        arg newEventFunc, sustainTime = 4.0, transitionTime = 4.0, overlap = 2, numChannels = 2, maxRepeats = inf, postProcess = nil, bus = 0;
        var period = (sustainTime + (transitionTime * 2)) / overlap;
        Task.new(func: {
            maxRepeats.do({
                arg i;
                RTexture.add_env(newEventFunc: newEventFunc, i: i).play(args:[
                    \sustainTime: sustainTime,
                    \transitionTime: transitionTime]);
                period.wait;
            });
        }).play;
        if(postProcess.notNil,{RTexture.post_process(treatment: postProcess, bus: bus, numChannels: numChannels)});
    }

    *post_process {
        arg treatment, bus = 0, numChannels = 2;
        {
            var z = In.ar(bus: bus, numChannels: numChannels);
            z = treatment.value(z);
            ReplaceOut.ar(bus: bus, channelsArray: z);
        }.play(addAction: \addToTail);
    }

    *overlapGraph { // ugen graph variant
        arg graphFunc, sustainTime = 4.0, transitionTime = 4.0, overlap = 2;
        ^Mix.fill(n: overlap, function: {
            arg i;
            var trg = Impulse.kr(freq: 1 / (sustainTime + (transitionTime * 2)), phase: i / overlap);
            var snd = graphFunc.value(trg);
            var env = Env.new(levels: [0,1,1,0], times: [transitionTime,sustainTime,transitionTime], curve: \sin);
            snd * EnvGen.kr(envelope: env, gate: trg, levelScale: 1, levelBias: 0, timeScale: 1, doneAction: 0);
        });
    }

    *xfadeGraph { // ugen graph variant
        arg graphFunc, sustainTime = 4.0, transitionTime = 4.0;
        var mk = {
            arg ph;
            var trg = Impulse.kr(freq: 1 / (sustainTime + (transitionTime * 2)), phase: ph);
            var snd = graphFunc.value(trg);
            var env = Env.new(levels: [0,1,1,0], times: [transitionTime,sustainTime,transitionTime], curve: \sin);
            snd * EnvGen.kr(envelope: env, gate: trg, levelScale: 1, levelBias: 0, timeScale: 1, doneAction: 0);
        };
        ^(mk.value(0) + mk.value((sustainTime + transitionTime) / (sustainTime + (transitionTime * 2))));
    }

}
