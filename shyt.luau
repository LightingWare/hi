_G.CORE = {
    HTTP_GET = function(caller : string, return_type : string, callback)
        coroutine.wrap(function()
            local get = game:HttpGet(caller)
            local load = loadstring(get)
            
            if return_type == "load" then
                return load
            elseif return_type == "get" then
                return get
            elseif return_type == "loadcb" then
                return load()
            else
                return load
            end

            if callback and typeof(callback) == "function" then
                callback()
            end
        end)
    end;

    SERVICES = {
        RunService = game:GetService("RunService");
        UserInputService = game:GetService("UserInputService");
        TweenService = game:GetService("TweenService");
        Players = game:GetService("Players");
    };
    CONFIG = {
        INFINITE = false;
        LENGTH = math.huge;
        MAIN_LOOP_RENDER_KEY = "main_app.luau";
    };
    ASSETS = {

    };
    LIBRARIES = {
        Signal = self.HTTP_GET("https://raw.githubusercontent.com/stravant/goodsignal/refs/heads/master/src/init.lua");
        Spring = self.HTTP_GET("");
    };
	CONNECTIONS = {
	    
	};
}

_G.CORE.__index = _G.CORE

local CORE = _G.CORE
local self = setmetatable({}, {CORE})

local plr = self.SERVICES.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local root = root or Instance.new("Part", char.Head)

root.CanCollide = false
root.Transparency = 0.5
root.CastShadow = false
root.Size = Vector3.new(2, 2, 2)

local main

local exec_ = 0
local elapsed_time = 0
local length = self.CONFIG.LENGTH
local infinite = self.CONFIG.INFINITE

local function endMain()
    main = nil
    self.SERVICES.RunService:UnbindFromRenderStep(self.CONFIG.MAIN_LOOP_RENDER_KEY)
    elapsed_time = 0
    exec_ = 0
end

local function LoopFuncMain()
    root:PivotTo(char.Head.CFrame)
end

if main ~= nil then endMain() end

if not main then
    main = self.SERVICES.RunService:BindToRenderStep(render_key, Enum.RenderPriority.Camera.Value, function(dt)
        elapsed_time += dt
        exec_ += 1
        LoopFuncMain()

        if not infinite and elapsed_time >= length then
            endMain()
        end
    end)
end

char.Humanoid.died:Connect(endMain)
