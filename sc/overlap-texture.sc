/* SC3 variants of OverlapTexture &etc. - rd */

Texture {

    *add_env {
        arg newEventFunc, i;
        ^{
            var sustainTime = \sustainTime.kr(4);
            var transitionTime = \transitionTime.kr(1);
            var env = Env([0,1,1,0],[transitionTime,sustainTime,transitionTime],\sin);
            Out.ar(0,newEventFunc.(i) * EnvGen.kr(env,doneAction: 2));
        };
    }

    *spawn {
        arg newEventFunc, numChannels = 2, nextTime, maxRepeats = inf, postProcess = nil, bus = 0;
        Task({
            maxRepeats.do({
                arg i;
                {Out.ar(0,newEventFunc.(i))}.play;
                nextTime.value.wait;
            });
        }).play;
        if(postProcess.notNil,{Texture.post_process(postProcess,bus,numChannels)});
    }

    *xfade {
        arg newEventFunc, sustainTime = 4.0, transitionTime = 4.0, numChannels = 2, maxRepeats = inf, postProcess = nil, bus = 0;
        var period = sustainTime + transitionTime;
        Task({
            maxRepeats.do({
                arg i;
                Texture.add_env(newEventFunc,i).play(args:[
                    \sustainTime:sustainTime,
                    \transitionTime:transitionTime]);
                period.wait;
            });
        }).play;
        if(postProcess.notNil,{Texture.post_process(postProcess,bus,numChannels)});
    }

    *overlap {
        arg newEventFunc, sustainTime = 4.0, transitionTime = 4.0, overlap = 2, numChannels = 2, maxRepeats = inf, postProcess = nil, bus = 0;
        var period = (sustainTime + (transitionTime * 2)) / overlap;
        Task({
            maxRepeats.do({
                arg i;
                Texture.add_env(newEventFunc,i).play(args:[
                    \sustainTime:sustainTime,
                    \transitionTime:transitionTime]);
                period.wait;
            });
        }).play;
        if(postProcess.notNil,{Texture.post_process(postProcess,bus,numChannels)});
    }

    *post_process {
        arg treatment, bus = 0, numChannels = 2;
        {
            var z = In.ar(bus,numChannels);
            z = treatment.(z);
            ReplaceOut.ar(bus,z);
        }.play(addAction: \addToTail);
    }

    *overlapGraph { // ugen graph variant
        arg graphFunc, sustainTime = 4.0, transitionTime = 4.0, overlap = 2;
        ^Mix.fill(overlap,{
            arg i;
            var trg = Impulse.kr(1 / (sustainTime + (transitionTime * 2)),i / overlap);
            var snd = graphFunc.(trg);
            var env = Env([0,1,1,0],[transitionTime,sustainTime,transitionTime],\sin);
            snd * EnvGen.kr(env,trg);
        });
    }

    *xfadeGraph { // ugen graph variant
        arg graphFunc, sustainTime = 4.0, transitionTime = 4.0;
        var mk = {
            arg ph;
            var trg = Impulse.kr(1 / (sustainTime + (transitionTime * 2)),ph);
            var snd = graphFunc.(trg);
            var env = Env([0,1,1,0],[transitionTime,sustainTime,transitionTime],\sin);
            snd * EnvGen.kr(env,trg);
        };
        ^(mk.(0) + mk.((sustainTime + transitionTime) / (sustainTime + (transitionTime * 2))));
    }

}
