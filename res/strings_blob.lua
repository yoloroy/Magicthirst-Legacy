--- @class Strings
--- @field deathScreenHeader string
--- @field continueTryingButton string
--- @field testLevel1 string
--- @field testLevel2 string
--- @field testLevel3 string
--- @field gameName string
--- @field exit string

--- @type table<string, Strings>
local s = {
    EN = {
        deathScreenHeader = "You died",
        continueTryingButton = "Continue trying",
        testLevel1 = "Test level 1 (running)",
        testLevel2 = "Test level 2 (arena)",
        testLevel3 = "Test level 3 (more complex)",
        gameName = "Magicthirst Legacy\n(demo) 0.0.-1",
        exit = "Exit"
    }
}

return s
