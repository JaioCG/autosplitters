// Playback Loop Autosplitter v1.0
// Game Engine: Unity
// Created by Jaio

state("Playback Loop") {}

startup {
    // Using just-ero's asl-help library
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Playback Loop";

    // Alert users that Game Time is used
    vars.Helper.AlertGameTime();

    // Custom settings
    settings.Add("ilTimer", false, "Use individual level timing");
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono => {
        vars.Helper["timeInScene"] = mono.Make<float>("AutoSplitterData", "timeInScene");
        vars.Helper["timeInSession"] = mono.Make<float>("AutoSplitterData", "timeInSession");
        vars.Helper["levelNumber"] = mono.Make<int>("AutoSplitterData", "levelNumber");
        vars.Helper["totalLevels"] = mono.Make<int>("AutoSplitterData", "totalLevels");
        vars.Helper["gameState"] = mono.Make<int>("AutoSplitterData", "gameState");
        // GameState: Idle, Playback, RecordingPlayback, Blocked, Transitioning

        return true;
    });
}

update {
    print("Session time: " + current.timeInSession);
}

start {
    if (!settings["ilTimer"]) {
        return (current.gameState == 0) && (current.levelNumber == 1);
    } else {
        return (current.gameState == 0) && (current.levelNumber != 0);
    };
}

split {
    if (!settings["ilTimer"]) {
        // Only updates when clicking any key when starting a level
        // Best case scenario, it splits on level finish, but I don't think there's a good way of
        // doing that without using gameState, which repeatedly calls.
        return old.levelNumber < current.levelNumber;
    } else {
        // Split immediately on level finish, can't use for fullgame cause it keeps calling afterwards
        return current.gameState == 4;
    };
}

reset {
    return current.levelNumber == 0; // Main menu
}

gameTime {
    if (!settings["ilTimer"]) {
        return TimeSpan.FromSeconds(current.timeInSession);
    } else {
        return TimeSpan.FromSeconds(current.timeInScene);
    };
}

isLoading {
    return true;
}