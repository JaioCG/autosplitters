// ARTIFICIAL Autosplitter v1.1
// Game Engine: Unity
// Created by Jaio

state("ARTIFICIAL") {}

startup {
    // Using just-ero's asl-help library
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "ARTIFICIAL";

    vars.Helper.AlertGameTime();
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["inGameTime"] = mono.Make<double>("AutoSplitterData", "inGameTime");
        vars.Helper["levelID"] = mono.Make<int>("AutoSplitterData", "levelID");
        vars.Helper["isRunning"] = mono.Make<bool>("AutoSplitterData", "isRunning");

        return true;
    });
}

start {
    return !old.isRunning && current.isRunning;
}

split {
    return (old.levelID < current.levelID) && current.isRunning;
}

reset {
    return old.isRunning && !current.isRunning;
}

gameTime {
    return TimeSpan.FromSeconds(current.inGameTime);
}

isLoading { 
    return true;
}
