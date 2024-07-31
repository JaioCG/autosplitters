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
        // gameState: Idle, Playback, RecordingPlayback, Blocked, Transitioning, MainMenu, CutScene
        vars.Helper["timerRunning"] = mono.Make<bool>("AutoSplitterData", "timerRunning");

        return true;
    });
}

start {
    if (!settings["ilTimer"]) {
        return (current.gameState == 0) && (current.levelNumber == 1); // Require Sunrise
    } else {
        return (current.gameState == 0) && (current.levelNumber != 0); // Any level
    };
}

split {
    // Splits on finishing level (does not re-call)
    return !current.timerRunning && old.timerRunning;
}

reset {
    // Use gameState instead of level number to discern between going manually to menu and being in
    // the cutscene after Tailwind.
    return current.gameState == 5 || (current.timeInSession < old.timeInSession);
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
