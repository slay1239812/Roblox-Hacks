local gearID = 121946387  -- Replace with the gear ID you want to use
local feGearID = 121946387  -- Replace with the FE gear ID (ID for server use)

-- Create RemoteEvent to handle gear interaction (both server and client)
local function createRemoteEvent()
    local remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = "GiveGear"
    remoteEvent.Parent = game.ReplicatedStorage
    return remoteEvent
end

-- Function to create Server Script
local function createServerScript(gearID)
    local serverScript = Instance.new("Script")
    serverScript.Name = "ServerScript"
    serverScript.Source = [[
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        
        -- Fire when a player clicks a button in their LocalScript
        game.ReplicatedStorage.GiveGear.OnServerEvent:Connect(function(player)
            local character = player.Character
            if character then
                -- Create gear (Tool) and equip it to the character
                local newGear = Instance.new("Tool")
                newGear.Name = "Gear"
                newGear.TextureId = "rbxassetid://" .. tostring(gearID)
                newGear.RequiresHandle = true  -- Gear must have a handle part
                
                -- Create the handle for the gear
                local handle = Instance.new("Part")
                handle.Name = "Handle"
                handle.Size = Vector3.new(1, 5, 1)  -- Set size for the gear's handle
                handle.Anchored = false
                handle.CanCollide = false
                handle.Parent = newGear
                
                -- Equip the gear to the character
                newGear.Parent = character
                newGear.Handle = handle  -- Assign the handle

                -- Add functionality for damage (example: when the gear hits something)
                newGear.Touched:Connect(function(hit)
                    local humanoid = hit.Parent:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Parent ~= player.Character then
                        humanoid:TakeDamage(20)  -- Deal 20 damage to others
                    end
                end)
            end
        end)
    ]]
    return serverScript
end

-- Function to create Local Script
local function createLocalScript(gearID, feGearID)
    local localScript = Instance.new("LocalScript")
    localScript.Name = "LocalScript"
    localScript.Source = [[
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local player = game.Players.LocalPlayer
        
        -- Fire the event to the server to give the gear
        local function giveGear()
            ReplicatedStorage.GiveGear:FireServer()
        end
        
        -- Triggering the function (could be a button or other event)
        giveGear()
    ]]
    return localScript
end

-- Main function to set up the system
local function setupGearSystem()
    -- Create the RemoteEvent
    createRemoteEvent()

    -- Create and parent the Server Script
    local serverScript = createServerScript(feGearID)
    serverScript.Parent = game.ServerScriptService
    
    -- Create and parent the Local Script
    local localScript = createLocalScript(feGearID, gearID)
    localScript.Parent = game.Players.LocalPlayer:WaitForChild("PlayerScripts")  -- Parent to PlayerScripts

    print("Gear system has been set up successfully!")
end

-- Call the setup function to initialize everything
setupGearSystem()
