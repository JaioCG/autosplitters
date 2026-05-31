// SECTOR ZERO Autosplitter v1.0
// Game Engine: Unity
// Created by Jaio

state("SECTOR ZERO") {}

startup {
    // Using just-ero's asl-help library
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "SECTOR ZERO";

    // Alert users that Game Time is used
    vars.Helper.AlertGameTime();
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["inGameTime"] = mono.Make<double>("AutoSplitterData", "inGameTime");
        vars.Helper["levelID"] = mono.Make<int>("AutoSplitterData", "levelID");
        vars.Helper["isRunning"] = mono.Make<int>("AutoSplitterData", "isRunning");

        return true;
    });
}

start {
    return old.isRunning == 0 && current.isRunning == 1;
}

split {
    return ((old.levelID < current.levelID) && current.isRunning == 1) || ((old.levelID == current.levelID) && current.isRunning == 2);
}

reset {
    return old.isRunning == 1 && current.isRunning == 0;
}

gameTime {
    return TimeSpan.FromSeconds(current.inGameTime);
}

isLoading { 
    return true;
}