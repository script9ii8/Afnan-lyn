--// AFNAN HUB LOADER (AUTO UPDATE)

if getgenv().AFNAN_LOADER then return end
getgenv().AFNAN_LOADER = true

local CORE_URL = "https://raw.githubusercontent.com/agussuntikfoll-ui/Afnan-lyn/main/src/afnan_hub.lua"

local ok, err = pcall(function()
    loadstring(game:HttpGet(CORE_URL))()
end)

if not ok then
    warn("AFNAN HUB: Gagal load core", err)
end

