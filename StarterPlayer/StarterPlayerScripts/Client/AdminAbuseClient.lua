-- Ruta Original: StarterPlayer.StarterPlayerScripts.Client.AdminAbuseClient
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local AdminAbuseGui = require(script.Parent:WaitForChild("AdminAbuseGui"));
local AdminAbuseRegistry = require(script.Parent:WaitForChild("AdminAbuseRegistry"));
local AdminAbuseTransition = require(script.Parent:WaitForChild("AdminAbuseTransition"));
local F8 = Enum.KeyCode.F8;
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;

local function getModulesFolder() -- Line: 17
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("Modules");
end;

local function getRemotes() -- Line: 21
    -- upvalues: ReplicatedStorage (copy)
    local Remotes = ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("Remotes");

    return Remotes:WaitForChild("AdminAbuseRequest"), Remotes:WaitForChild("AdminAbuseSync");
end;

local function invalidateRegistry() -- Line: 26
    -- upvalues: u4 (ref)
    u4 = nil;
end;

local function getRegistry() -- Line: 30
    -- upvalues: u1 (ref), u4 (ref), AdminAbuseRegistry (copy)
    local v5 = u1;
    assert(v5, "AdminAbuseClient.init() d\'abord");

    if not u4 then
        u4 = AdminAbuseRegistry.loadRegistry(v5);
    end;

    return u4;
end;

return {
    init = function() -- Line: 41, Name: init
        -- upvalues: u1 (ref), ReplicatedStorage (copy), u2 (ref), u3 (ref), invalidateRegistry (copy), Players (copy), AdminAbuseRegistry (copy), AdminAbuseGui (copy), UserInputService (copy), F8 (copy), u4 (ref), AdminAbuseTransition (copy)
        u1 = ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("Modules");
        local Remotes = ReplicatedStorage:WaitForChild("AdminAbuse"):WaitForChild("Remotes");
        local AdminAbuseRequest = Remotes:WaitForChild("AdminAbuseRequest");
        local AdminAbuseSync = Remotes:WaitForChild("AdminAbuseSync");
        u2 = AdminAbuseRequest;
        u3 = AdminAbuseSync;
        local u6 = u1;
        u6.ChildAdded:Connect(invalidateRegistry);
        u6.ChildRemoved:Connect(invalidateRegistry);
        local LocalPlayer = Players.LocalPlayer;
        assert(LocalPlayer, "LocalPlayer manquant");
        local u7 = u2;
        local u8 = nil;
        local u9 = nil;
        local u10 = nil;
        local u11 = nil;
        local u12 = nil;
        local u13 = false;

        local function isTrusted() -- Line: 62
            -- upvalues: LocalPlayer (copy)
            return LocalPlayer:GetAttribute("AdminAbuseTrusted") == true;
        end;

        local function updateMuteAttr() -- Line: 66
            -- upvalues: LocalPlayer (copy), u8 (ref), u10 (ref)
            LocalPlayer:SetAttribute("AdminAbuseEventActive", u8 ~= nil and true or u10 ~= nil);
        end;

        local function buildProps() -- Line: 70
            -- upvalues: AdminAbuseRegistry (ref), u6 (copy), u7 (copy), LocalPlayer (copy), u13 (ref), u8 (ref), u10 (ref)
            return {
                moduleMetas = AdminAbuseRegistry.listModuleMetas(u6),

                onPickModule = function(p14, p15) -- Line: 73, Name: onPickModule
                    -- upvalues: u7 (ref)
                    if p15 then
                        u7:FireServer("Start", p14, p15);

                        return;
                    end;

                    u7:FireServer("Start", p14);
                end,

                onStop = function() -- Line: 80, Name: onStop
                    -- upvalues: u7 (ref)
                    u7:FireServer("Stop");
                end,

                onStopEvent = function() -- Line: 83, Name: onStopEvent
                    -- upvalues: u7 (ref)
                    u7:FireServer("StopEvent");
                end,

                onBossDelta = function(p16) -- Line: 86, Name: onBossDelta
                    -- upvalues: LocalPlayer (ref), u7 (ref)
                    if LocalPlayer:GetAttribute("AdminAbuseTrusted") == true then
                        u7:FireServer("BossDelta", p16);
                    end;
                end,

                onClose = function() -- Line: 91, Name: onClose
                    -- upvalues: u13 (ref)
                    u13 = false;
                end,

                showStop = LocalPlayer:GetAttribute("AdminAbuseTrusted") == true,
                activeAdminAbuse = u8,
                activeEvent = u10
            };
        end;

        local function ensureGui() -- Line: 100
            -- upvalues: u12 (ref), AdminAbuseGui (ref), buildProps (copy)
            if u12 then
                return u12;
            end;

            u12 = AdminAbuseGui.mountLocalPlayer((buildProps()));

            return u12;
        end;

        local function togglePanel() -- Line: 108
            -- upvalues: LocalPlayer (copy), u12 (ref), AdminAbuseGui (ref), buildProps (copy), u13 (ref)
            if LocalPlayer:GetAttribute("AdminAbuseTrusted") ~= true then
                return;
            end;

            local v17;

            if u12 then
                v17 = u12;
            else
                u12 = AdminAbuseGui.mountLocalPlayer((buildProps()));
                v17 = u12;
            end;

            u13 = not u13;
            v17.SetProps((buildProps()));
            v17.SetVisible(u13);
        end;

        UserInputService.InputBegan:Connect(function(p18, p19) -- Line: 118
            -- upvalues: F8 (ref), LocalPlayer (copy), u12 (ref), AdminAbuseGui (ref), buildProps (copy), u13 (ref)
            if p19 then
                return;
            end;

            if p18.KeyCode == F8 then
                if LocalPlayer:GetAttribute("AdminAbuseTrusted") ~= true then
                    return;
                end;

                local v20;

                if u12 then
                    v20 = u12;
                else
                    u12 = AdminAbuseGui.mountLocalPlayer((buildProps()));
                    v20 = u12;
                end;

                u13 = not u13;
                v20.SetProps((buildProps()));
                v20.SetVisible(u13);
            end;
        end);
        LocalPlayer:GetAttributeChangedSignal("AdminAbuseTrusted"):Connect(function() -- Line: 127
            -- upvalues: LocalPlayer (copy), u12 (ref), u13 (ref)
            if LocalPlayer:GetAttribute("AdminAbuseTrusted") ~= true and u12 then
                u13 = false;
                u12.SetVisible(false);
            end;
        end);

        local function runModuleFire(p21, p22) -- Line: 134
            -- upvalues: u1 (ref), u4 (ref), AdminAbuseRegistry (ref)
            local v23 = u1;
            assert(v23, "AdminAbuseClient.init() d\'abord");

            if not u4 then
                u4 = AdminAbuseRegistry.loadRegistry(v23);
            end;

            local v24 = u4[p21];

            if v24 and type(v24.Fire) == "function" then
                if p22 then
                    v24:Fire(p22);

                    return;
                end;

                v24:Fire();
            end;
        end;

        local function runModuleStop(p25) -- Line: 146
            -- upvalues: u1 (ref), u4 (ref), AdminAbuseRegistry (ref)
            local v26 = u1;
            assert(v26, "AdminAbuseClient.init() d\'abord");

            if not u4 then
                u4 = AdminAbuseRegistry.loadRegistry(v26);
            end;

            local v27 = u4[p25];

            if v27 and type(v27.Stop) == "function" then
                v27:Stop();
            end;
        end;

        local function applyPriorityLockToEvent() -- Line: 157
            -- upvalues: u10 (ref), u1 (ref), u4 (ref), AdminAbuseRegistry (ref), u8 (ref)
            if not u10 then
                return;
            end;

            local v28 = u1;
            assert(v28, "AdminAbuseClient.init() d\'abord");

            if not u4 then
                u4 = AdminAbuseRegistry.loadRegistry(v28);
            end;

            local v29 = u4;
            local v30 = v29[u10];

            if not v30 or type(v30.SetPriorityLocked) ~= "function" then
                return;
            end;

            local v31;

            if u8 then
                local v32 = v29[u8];

                if v32 == nil then
                    v31 = false;
                else
                    v31 = v32.HasPrioritySoundtrack == true;
                end;
            else
                v31 = false;
            end;

            v30:SetPriorityLocked(v31);
        end;

        local u33 = 0;
        local u34 = false;
        local u35 = false;
        local u36 = 0;
        u3.OnClientEvent:Connect(function(p37, u38, p39, p40, p41, p42, p43) -- Line: 178
            -- upvalues: u36 (ref), u10 (ref), u11 (ref), LocalPlayer (copy), u8 (ref), u1 (ref), u4 (ref), AdminAbuseRegistry (ref), u12 (ref), buildProps (copy), u33 (ref), u34 (ref), u35 (ref), u9 (ref), AdminAbuseTransition (ref)
            local v44 = type(p41) ~= "number" and 0 or p41;

            if p43 == "Event" then
                if p37 == "Start" and (type(u38) == "string" and u38 ~= "") then
                    local v45 = nil;

                    if type(p39) == "number" then
                        if p39 < 0 then
                            p39 = v45;
                        end;
                    else
                        p39 = v45;
                    end;

                    if v44 > 0 then
                        if v44 <= u36 then
                            return;
                        end;

                        u36 = v44;
                    elseif u10 == u38 and u11 == p39 then
                        return;
                    end;

                    local v46 = u10;
                    u10 = u38;
                    u11 = p39;
                    LocalPlayer:SetAttribute("AdminAbuseEventActive", u8 ~= nil and true or u10 ~= nil);

                    if v46 and v46 ~= u38 then
                        local v47 = u1;
                        assert(v47, "AdminAbuseClient.init() d\'abord");

                        if not u4 then
                            u4 = AdminAbuseRegistry.loadRegistry(v47);
                        end;

                        local v48 = u4[v46];

                        if v48 and type(v48.Stop) == "function" then
                            v48:Stop();
                        end;
                    end;

                    if u10 then
                        local v49 = u1;
                        assert(v49, "AdminAbuseClient.init() d\'abord");

                        if not u4 then
                            u4 = AdminAbuseRegistry.loadRegistry(v49);
                        end;

                        local v50 = u4;
                        local v51 = v50[u10];

                        if v51 and type(v51.SetPriorityLocked) == "function" then
                            local v52;

                            if u8 then
                                local v53 = v50[u8];

                                if v53 == nil then
                                    v52 = false;
                                else
                                    v52 = v53.HasPrioritySoundtrack == true;
                                end;
                            else
                                v52 = false;
                            end;

                            v51:SetPriorityLocked(v52);
                        end;
                    end;

                    local v54 = u1;
                    assert(v54, "AdminAbuseClient.init() d\'abord");

                    if not u4 then
                        u4 = AdminAbuseRegistry.loadRegistry(v54);
                    end;

                    local v55 = u4[u38];

                    if v55 and type(v55.Fire) == "function" then
                        if p39 then
                            v55:Fire(p39);
                        else
                            v55:Fire();
                        end;
                    end;

                    if u12 then
                        u12.SetProps((buildProps()));

                        return;
                    end;
                elseif p37 == "Stop" then
                    if v44 > 0 then
                        if v44 <= u36 then
                            return;
                        end;

                        u36 = v44;
                    end;

                    if u10 then
                        local v56 = u1;
                        assert(v56, "AdminAbuseClient.init() d\'abord");

                        if not u4 then
                            u4 = AdminAbuseRegistry.loadRegistry(v56);
                        end;

                        local v57 = u4[u10];

                        if v57 and type(v57.Stop) == "function" then
                            v57:Stop();
                        end;
                    end;

                    u10 = nil;
                    u11 = nil;
                    LocalPlayer:SetAttribute("AdminAbuseEventActive", u8 ~= nil and true or u10 ~= nil);

                    if u12 then
                        u12.SetProps((buildProps()));
                    end;
                end;

                return;
            end;

            if p37 ~= "Start" or (type(u38) ~= "string" or u38 == "") then
                if p37 == "Stop" then
                    if v44 > 0 then
                        if v44 <= u33 then
                            return;
                        end;

                        u33 = v44;
                    end;

                    u34 = false;
                    u35 = false;
                    AdminAbuseTransition.cancel();

                    if u8 then
                        local v58 = u1;
                        assert(v58, "AdminAbuseClient.init() d\'abord");

                        if not u4 then
                            u4 = AdminAbuseRegistry.loadRegistry(v58);
                        end;

                        local v59 = u4[u8];

                        if v59 and type(v59.Stop) == "function" then
                            v59:Stop();
                        end;
                    end;

                    u8 = nil;
                    u9 = nil;
                    LocalPlayer:SetAttribute("AdminAbuseEventActive", u8 ~= nil and true or u10 ~= nil);

                    if u10 then
                        local v60 = u1;
                        assert(v60, "AdminAbuseClient.init() d\'abord");

                        if not u4 then
                            u4 = AdminAbuseRegistry.loadRegistry(v60);
                        end;

                        local v61 = u4;
                        local v62 = v61[u10];

                        if v62 and type(v62.SetPriorityLocked) == "function" then
                            local v63;

                            if u8 then
                                local v64 = v61[u8];

                                if v64 == nil then
                                    v63 = false;
                                else
                                    v63 = v64.HasPrioritySoundtrack == true;
                                end;
                            else
                                v63 = false;
                            end;

                            v62:SetPriorityLocked(v63);
                        end;
                    end;

                    if u12 then
                        u12.SetProps((buildProps()));
                    end;
                end;

                return;
            end;

            local v65 = nil;

            if type(p39) == "number" then
                if p39 < 0 then
                    p39 = v65;
                end;
            else
                p39 = v65;
            end;

            local v66 = p40 == true;

            if v44 > 0 then
                if v44 < u33 then
                    return;
                end;

                if u33 < v44 then
                    u33 = v44;
                    u34 = false;
                    u35 = false;
                end;

                if v66 then
                    if u34 or u35 then
                        return;
                    end;

                    u35 = true;
                else
                    if u34 then
                        return;
                    end;

                    u34 = true;
                end;
            elseif u8 == u38 and u9 == p39 then
                return;
            end;

            local v67 = u8;
            u8 = u38;
            u9 = p39;
            LocalPlayer:SetAttribute("AdminAbuseEventActive", u8 ~= nil and true or u10 ~= nil);

            if u10 then
                local v68 = u1;
                assert(v68, "AdminAbuseClient.init() d\'abord");

                if not u4 then
                    u4 = AdminAbuseRegistry.loadRegistry(v68);
                end;

                local v69 = u4;
                local v70 = v69[u10];

                if v70 and type(v70.SetPriorityLocked) == "function" then
                    local v71;

                    if u8 then
                        local v72 = v69[u8];

                        if v72 == nil then
                            v71 = false;
                        else
                            v71 = v72.HasPrioritySoundtrack == true;
                        end;
                    else
                        v71 = false;
                    end;

                    v70:SetPriorityLocked(v71);
                end;
            end;

            if u12 then
                u12.SetProps((buildProps()));
            end;

            if v67 and v67 ~= u38 then
                local v73 = u1;
                assert(v73, "AdminAbuseClient.init() d\'abord");

                if not u4 then
                    u4 = AdminAbuseRegistry.loadRegistry(v73);
                end;

                local v74 = u4[v67];

                if v74 and type(v74.Stop) == "function" then
                    v74:Stop();
                end;
            end;

            local u75 = u9;
            AdminAbuseTransition.play(function() -- Line: 284
                -- upvalues: u8 (ref), u38 (copy), u75 (copy), u1 (ref), u4 (ref), AdminAbuseRegistry (ref)
                if u8 == u38 then
                    local v76 = u75;
                    local v77 = u1;
                    assert(v77, "AdminAbuseClient.init() d\'abord");

                    if not u4 then
                        u4 = AdminAbuseRegistry.loadRegistry(v77);
                    end;

                    local v78 = u4[u38];

                    if v78 and type(v78.Fire) == "function" then
                        if v76 then
                            v78:Fire(v76);

                            return;
                        end;

                        v78:Fire();
                    end;
                end;
            end, {
                skip = v66,
                skipDoor = p42 == true
            });
        end);
        local Character = LocalPlayer.Character;
        LocalPlayer.CharacterAdded:Connect(function(p79) -- Line: 311
            -- upvalues: u1 (ref), u4 (ref), AdminAbuseRegistry (ref), u8 (ref), Character (ref), u9 (ref), u10 (ref), u11 (ref)
            local v80 = u1;
            assert(v80, "AdminAbuseClient.init() d\'abord");

            if not u4 then
                u4 = AdminAbuseRegistry.loadRegistry(v80);
            end;

            local v81 = u4;

            if u8 then
                local v82 = v81[u8];

                if v82 and (v82.RequiresRespawnRefire == true and Character ~= nil) then
                    task.defer(function() -- Line: 319
                        -- upvalues: u8 (ref), u9 (ref), u1 (ref), u4 (ref), AdminAbuseRegistry (ref)
                        local v83 = u9;
                        local v84 = u1;
                        assert(v84, "AdminAbuseClient.init() d\'abord");

                        if not u4 then
                            u4 = AdminAbuseRegistry.loadRegistry(v84);
                        end;

                        local v85 = u4[u8];

                        if v85 and type(v85.Fire) == "function" then
                            if v83 then
                                v85:Fire(v83);

                                return;
                            end;

                            v85:Fire();
                        end;
                    end);
                end;
            end;

            if u10 then
                local v86 = v81[u10];

                if v86 and (v86.RequiresRespawnRefire == true and Character ~= nil) then
                    task.defer(function() -- Line: 331
                        -- upvalues: u10 (ref), u11 (ref), u1 (ref), u4 (ref), AdminAbuseRegistry (ref)
                        local v87 = u11;
                        local v88 = u1;
                        assert(v88, "AdminAbuseClient.init() d\'abord");

                        if not u4 then
                            u4 = AdminAbuseRegistry.loadRegistry(v88);
                        end;

                        local v89 = u4[u10];

                        if v89 and type(v89.Fire) == "function" then
                            if v87 then
                                v89:Fire(v87);

                                return;
                            end;

                            v89:Fire();
                        end;
                    end);
                end;
            end;

            Character = p79;
        end);
        u7:FireServer("GetState");
    end,

    getAdminAbuseTable = function() -- Line: 344, Name: getAdminAbuseTable
        -- upvalues: u1 (ref), AdminAbuseRegistry (copy)
        local v90 = u1;
        assert(v90, "AdminAbuseClient.init() d\'abord");

        return AdminAbuseRegistry.buildAdminAbuseTable(v90);
    end
};