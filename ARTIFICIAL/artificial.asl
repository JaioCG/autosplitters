// ARTIFICIAL Autosplitter v1.0
// Game Engine: Unity
// Created by Jaio

state("ARTIFICIAL") {}

startup {
    // Using just-ero's asl-help library
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "ARTIFICIAL";

    // Prompt user to use in-game time
    if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
        var mbox = MessageBox.Show(
        "ARTIFICIAL uses in-game time.\nWould you like to switch to it?",
        "LiveSplit | ARTIFICIAL",
        MessageBoxButtons.YesNo);
        if (mbox == DialogResult.Yes) timer.CurrentTimingMethod = TimingMethod.GameTime; 
    }
}

init {
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var asd = mono.GetClass("Assembly-CSharp", "AutoSplitterData");

        vars.Helper["inGameTime"] = mono.Make<double>(asd, "inGameTime");
        vars.Helper["levelID"] = mono.Make<int>(asd, "levelID");
        vars.Helper["isRunning"] = mono.Make<int>(asd, "isRunning");

        return true;
    });
}

start {
    return vars.Helper["isRunning"].Old == 0 && vars.Helper["isRunning"].Current == 1;
}
split {
    return vars.Helper["levelID"].Old < vars.Helper["levelID"].Current;
}
reset {
    return vars.Helper["isRunning"].Old == 1 && vars.Helper["isRunning"].Current == 0;
}
gameTime {
    return TimeSpan.FromSeconds(vars.Helper["inGameTime"].Current);
}
isLoading { 
    return true;
}