# Playback Loop

-   Developer: MapPack
-   Store Link: https://store.steampowered.com/app/2862670/Playback_Loop/
-   Game Engine: Unity
-   Developer's Discord Server: https://discord.gg/6SrTz9q9j7
-   Speedrun Community Discord Server: N/A

## Features

-   [x] Full game timing (matches in-game Session Timer)
-   [x] Automatic full game resetting
-   [x] Individual level timing (matches in-game Scene Timer)

## Bugs/Issues

-   Restarting level on Sunrise doesn't actually reset the timer, only sets it back to 0, so it's technically not a "new attempt".
-   Splitting using gameState splits 1 tick (0.02s) before the timer pauses, so segment times are one tick off IGT.
