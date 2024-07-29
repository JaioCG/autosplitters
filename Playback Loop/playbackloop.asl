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
        // GameState: Idle, Playback, RecordingPlayback, Blocked, Transitioning, MainMenu, CutScene

        return true;
    });
}

update {
    print("State: " + current.gameState + " Level: " + current.levelNumber + " Scene Time: " + current.timeInScene + " Session Time: " + current.timeInSession);
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
        // Currently splits when starting next level, which isn't ideal.
        // Could use "current.gameState == 4 && old.gameState != 4" to split on level finish, however
        // that leaves the split one tick off of in-game timer. Presumably, the gameState changes
        // one tick before the speedrun timer actually stops.
        return old.levelNumber < current.levelNumber;
    } else {
        return current.gameState == 4 && old.gameState != 4;
    };
}

reset {
    // Use gameState instead of level number to dissern between going manually to menu and being in
    // the cutscene after Tailwind.
    return current.gameState == 5;
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