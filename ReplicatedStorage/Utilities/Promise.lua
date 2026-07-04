-- Ruta Original: ReplicatedStorage.Utilities.Promise
-- Tipo: ModuleScript

-- Decompiled with Potassium's decompiler.

local u1 = {
    __mode = "k"
};

local function isCallable(p2) -- Line: 10
    if type(p2) == "function" then
        return true;
    end;

    local v3 = type(p2) == "table" and getmetatable(p2);

    if v3 then
        local v4 = rawget(v3, "__call");

        if type(v4) == "function" then
            return true;
        end;
    end;

    return false;
end;

local function makeEnum(u5, p6) -- Line: 25
    local v7 = {};

    for _, v in ipairs(p6) do
        v7[v] = v;
    end;

    return setmetatable(v7, {
        __index = function(p8, p9) -- Line: 33, Name: __index
            -- upvalues: u5 (copy)
            error(string.format("%s is not in %s!", p9, u5), 2);
        end,

        __newindex = function() -- Line: 36, Name: __newindex
            -- upvalues: u5 (copy)
            error(string.format("Creating new members in %s is not allowed!", u5), 2);
        end
    });
end;

local u10 = {
    Kind = makeEnum("Promise.Error.Kind", { "ExecutionError", "AlreadyCancelled", "NotResolvedInTime", "TimedOut" })
};
u10.__index = u10;

function u10.new(p11, p12) -- Line: 54
    -- upvalues: u10 (ref)
    local v13 = p11 or {};
    local v14 = {
        error = tostring(v13.error) or "[This error has no error text.]",
        trace = v13.trace,
        context = v13.context,
        kind = v13.kind,
        parent = p12,
        createdTick = os.clock(),
        createdTrace = debug.traceback()
    };

    return setmetatable(v14, u10);
end;

function u10.is(p15) -- Line: 67
    if type(p15) == "table" then
        local v16 = getmetatable(p15);

        if type(v16) == "table" then
            local v17;

            if rawget(p15, "error") == nil then
                v17 = false;
            else
                local v18 = rawget(v16, "extend");
                v17 = type(v18) == "function";
            end;

            return v17;
        end;
    end;

    return false;
end;

function u10.isKind(p19, p20) -- Line: 79
    -- upvalues: u10 (ref)
    assert(p20 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil");
    local v21 = u10.is(p19) and p19.kind == p20;

    return v21;
end;

function u10.extend(p22, p23) -- Line: 85
    -- upvalues: u10 (ref)
    local v24 = p23 or {};
    v24.kind = v24.kind or p22.kind;

    return u10.new(v24, p22);
end;

function u10.getErrorChain(p25) -- Line: 93
    local v26 = { p25 };

    while v26[#v26].parent do
        table.insert(v26, v26[#v26].parent);
    end;

    return v26;
end;

function u10.__tostring(p27) -- Line: 103
    local v28 = { string.format("-- Promise.Error(%s) --", p27.kind or "?") };

    for _, v in ipairs(p27:getErrorChain()) do
        table.insert(v28, table.concat({ v.trace or v.error, v.context }, "\n"));
    end;

    return table.concat(v28, "\n");
end;

local function pack(...) -- Line: 122
    return select("#", ...), { ... };
end;

local function packResult(p29, ...) -- Line: 126
    return p29, select("#", ...), { ... };
end;

local function makeErrorHandler(u30) -- Line: 130
    -- upvalues: u10 (ref)
    assert(u30 ~= nil, "traceback is nil");

    return function(p31) -- Line: 133
        -- upvalues: u10 (ref), u30 (copy)
        if type(p31) == "table" then
            return p31;
        end;

        return u10.new({
            error = p31,
            kind = u10.Kind.ExecutionError,
            trace = debug.traceback(tostring(p31), 2),
            context = "Promise created at:\n\n" .. u30
        });
    end;
end;

local function runExecutor(u32, p33, ...) -- Line: 147
    -- upvalues: packResult (copy), u10 (ref)
    local v34 = xpcall;
    assert(u32 ~= nil, "traceback is nil");

    return packResult(v34(p33, function(p35) -- Line: 133
        -- upvalues: u10 (ref), u32 (copy)
        if type(p35) == "table" then
            return p35;
        end;

        return u10.new({
            error = p35,
            kind = u10.Kind.ExecutionError,
            trace = debug.traceback(tostring(p35), 2),
            context = "Promise created at:\n\n" .. u32
        });
    end, ...));
end;

local function createAdvancer(u36, u37, u38, u39) -- Line: 151
    -- upvalues: runExecutor (copy)
    return function(...) -- Line: 152
        -- upvalues: runExecutor (ref), u36 (copy), u37 (copy), u38 (copy), u39 (copy)
        local v40, v41, v42 = runExecutor(u36, u37, ...);

        if v40 then
            u38(unpack(v42, 1, v41));

            return;
        end;

        u39(v42[1]);
    end;
end;

local function isEmpty(p43) -- Line: 163
    return next(p43) == nil;
end;

local u44 = {
    Error = u10,
    Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
    _getTime = os.clock,
    _timeEvent = game:GetService("RunService").Heartbeat,
    _unhandledRejectionCallbacks = {},
    prototype = {}
};
u44.__index = u44.prototype;

function u44._new(p45, u46, p47) -- Line: 177
    -- upvalues: u44 (copy), u1 (copy), runExecutor (copy)
    if p47 ~= nil and not u44.is(p47) then
        error("Argument #2 to Promise.new must be a promise or nil", 2);
    end;

    local u48 = {
        _thread = nil,
        _values = nil,
        _valuesLength = -1,
        _unhandledRejection = true,
        _cancellationHook = nil,
        _source = p45,
        _status = u44.Status.Started,
        _queuedResolve = {},
        _queuedReject = {},
        _queuedFinally = {},
        _parent = p47,
        _consumers = setmetatable({}, u1)
    };

    if p47 and p47._status == u44.Status.Started then
        p47._consumers[u48] = true;
    end;

    setmetatable(u48, u44);

    local function resolve(...) -- Line: 203
        -- upvalues: u48 (copy)
        u48:_resolve(...);
    end;

    local function reject(...) -- Line: 207
        -- upvalues: u48 (copy)
        u48:_reject(...);
    end;

    local function onCancel(p49) -- Line: 211
        -- upvalues: u48 (copy), u44 (ref)
        if p49 then
            if u48._status == u44.Status.Cancelled then
                p49();
            else
                u48._cancellationHook = p49;
            end;
        end;

        return u48._status == u44.Status.Cancelled;
    end;

    u48._thread = coroutine.create(function() -- Line: 223
        -- upvalues: runExecutor (ref), u48 (copy), u46 (copy), resolve (copy), reject (copy), onCancel (copy)
        local v50, _, v51 = runExecutor(u48._source, u46, resolve, reject, onCancel);

        if not v50 then
            reject(v51[1]);
        end;
    end);
    task.spawn(u48._thread);

    return u48;
end;

function u44.new(p52) -- Line: 236
    -- upvalues: u44 (copy)
    return u44._new(debug.traceback(nil, 2), p52);
end;

function u44.__tostring(p53) -- Line: 240
    return string.format("Promise(%s)", p53._status);
end;

function u44.defer(u54) -- Line: 244
    -- upvalues: u44 (copy), runExecutor (copy)
    local u55 = debug.traceback(nil, 2);

    return u44._new(u55, function(u56, u57, u58) -- Line: 247
        -- upvalues: u44 (ref), runExecutor (ref), u55 (copy), u54 (copy)
        local u59 = nil;
        u59 = u44._timeEvent:Connect(function() -- Line: 249
            -- upvalues: u59 (ref), runExecutor (ref), u55 (ref), u54 (ref), u56 (copy), u57 (copy), u58 (copy)
            u59:Disconnect();
            local v60, _, v61 = runExecutor(u55, u54, u56, u57, u58);

            if not v60 then
                u57(v61[1]);
            end;
        end);
    end);
end;

u44.async = u44.defer;

function u44.resolve(...) -- Line: 264
    -- upvalues: pack (copy), u44 (copy)
    local u62, u63 = pack(...);

    return u44._new(debug.traceback(nil, 2), function(p64) -- Line: 266
        -- upvalues: u63 (copy), u62 (copy)
        p64(unpack(u63, 1, u62));
    end);
end;

function u44.reject(...) -- Line: 271
    -- upvalues: pack (copy), u44 (copy)
    local u65, u66 = pack(...);

    return u44._new(debug.traceback(nil, 2), function(p67, p68) -- Line: 273
        -- upvalues: u66 (copy), u65 (copy)
        p68(unpack(u66, 1, u65));
    end);
end;

function u44._try(p69, u70, ...) -- Line: 278
    -- upvalues: pack (copy), u44 (copy)
    local u71, u72 = pack(...);

    return u44._new(p69, function(p73) -- Line: 281
        -- upvalues: u70 (copy), u72 (copy), u71 (copy)
        p73(u70(unpack(u72, 1, u71)));
    end);
end;

function u44.try(p74, ...) -- Line: 286
    -- upvalues: u44 (copy)
    return u44._try(debug.traceback(nil, 2), p74, ...);
end;

function u44._all(p75, u76, u77) -- Line: 290
    -- upvalues: u44 (copy)
    if type(u76) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3);
    end;

    for i, v in pairs(u76) do
        if not u44.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(i))), 3);
        end;
    end;

    if #u76 == 0 or u77 == 0 then
        return u44.resolve({});
    end;

    return u44._new(p75, function(u78, u79, p80) -- Line: 305
        -- upvalues: u77 (copy), u76 (copy)
        local u81 = {};
        local u82 = {};
        local u83 = 0;
        local u84 = 0;
        local u85 = false;

        local function resolveOne(p86, ...) -- Line: 319
            -- upvalues: u85 (ref), u83 (ref), u77 (ref), u81 (copy), u76 (ref), u78 (copy), u82 (copy)
            if u85 then
                return;
            end;

            u83 = u83 + 1;

            if u77 == nil then
                u81[p86] = ...;
            else
                u81[u83] = ...;
            end;

            if u83 >= (u77 or #u76) then
                u85 = true;
                u78(u81);

                for _, v in ipairs(u82) do
                    v:cancel();
                end;
            end;
        end;

        p80(function() -- Line: 313, Name: cancel
            -- upvalues: u82 (copy)
            for _, v in ipairs(u82) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u76) do
            u82[i] = v:andThen(function(...) -- Line: 342
                -- upvalues: resolveOne (copy), i (copy)
                resolveOne(i, ...);
            end, function(...) -- Line: 344
                -- upvalues: u84 (ref), u77 (ref), u76 (ref), u82 (copy), u85 (ref), u79 (copy)
                u84 = u84 + 1;

                if u77 == nil or #u76 - u84 < u77 then
                    for _, v2 in ipairs(u82) do
                        v2:cancel();
                    end;

                    u85 = true;
                    u79(...);
                end;
            end);
        end;

        if u85 then
            for _, v in ipairs(u82) do
                v:cancel();
            end;
        end;
    end);
end;

function u44.all(p87) -- Line: 362
    -- upvalues: u44 (copy)
    return u44._all(debug.traceback(nil, 2), p87);
end;

function u44.fold(p88, u89, p90) -- Line: 366
    -- upvalues: u44 (copy)
    local v91 = type(p88) == "table";
    assert(v91, "Bad argument #1 to Promise.fold: must be a table");
    local v92;

    if type(u89) == "function" then
        v92 = true;
    elseif type(u89) == "table" then
        local v93 = getmetatable(u89);

        if v93 then
            local v94 = rawget(v93, "__call");
            v92 = type(v94) == "function";
        else
            v92 = false;
        end;
    else
        v92 = false;
    end;

    assert(v92, "Bad argument #2 to Promise.fold: must be a function");
    local u95 = u44.resolve(p90);

    return u44.each(p88, function(u96, u97) -- Line: 371
        -- upvalues: u95 (ref), u89 (copy)
        u95 = u95:andThen(function(p98) -- Line: 372
            -- upvalues: u89 (ref), u96 (copy), u97 (copy)
            return u89(p98, u96, u97);
        end);
    end):andThen(function() -- Line: 375
        -- upvalues: u95 (ref)
        return u95;
    end);
end;

function u44.some(p99, p100) -- Line: 380
    -- upvalues: u44 (copy)
    local v101 = type(p100) == "number";
    assert(v101, "Bad argument #2 to Promise.some: must be a number");

    return u44._all(debug.traceback(nil, 2), p99, p100);
end;

function u44.any(p102) -- Line: 386
    -- upvalues: u44 (copy)
    return u44._all(debug.traceback(nil, 2), p102, 1):andThen(function(p103) -- Line: 387
        return p103[1];
    end);
end;

function u44.allSettled(u104) -- Line: 392
    -- upvalues: u44 (copy)
    if type(u104) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2);
    end;

    for i, v in pairs(u104) do
        if not u44.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(i))), 2);
        end;
    end;

    if #u104 == 0 then
        return u44.resolve({});
    end;

    return u44._new(debug.traceback(nil, 2), function(u105, p106, p107) -- Line: 407
        -- upvalues: u104 (copy)
        local u108 = {};
        local u109 = {};
        local u110 = 0;

        local function u112(p111, ...) -- Line: 413
            -- upvalues: u110 (ref), u108 (copy), u104 (ref), u105 (copy)
            u110 = u110 + 1;
            u108[p111] = ...;

            if u110 >= #u104 then
                u105(u108);
            end;
        end;

        p107(function() -- Line: 423
            -- upvalues: u109 (copy)
            for _, v in ipairs(u109) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u104) do
            u109[i] = v:finally(function(...) -- Line: 430
                -- upvalues: u112 (copy), i (copy)
                u112(i, ...);
            end);
        end;
    end);
end;

function u44.race(u113) -- Line: 437
    -- upvalues: u44 (copy)
    local v114 = type(u113) == "table";
    assert(v114, string.format("Please pass a list of promises to %s", "Promise.race"));

    for i, v in pairs(u113) do
        local v115 = u44.is(v);
        local format = string.format;
        local v116 = tostring(i);
        assert(v115, format("Non-promise value passed into %s at index %s", "Promise.race", v116));
    end;

    return u44._new(debug.traceback(nil, 2), function(u117, u118, p119) -- Line: 444
        -- upvalues: u113 (copy)
        local u120 = {};
        local u121 = false;

        local function cancel() -- Line: 448
            -- upvalues: u120 (copy)
            for _, v in ipairs(u120) do
                v:cancel();
            end;
        end;

        local function finalize(u122) -- Line: 454
            -- upvalues: u120 (copy), u121 (ref)
            return function(...) -- Line: 455
                -- upvalues: u120 (ref), u121 (ref), u122 (copy)
                for _, v in ipairs(u120) do
                    v:cancel();
                end;

                u121 = true;

                return u122(...);
            end;
        end;

        if p119(function(...) -- Line: 455
            -- upvalues: u120 (copy), u121 (ref), u118 (copy)
            for _, v in ipairs(u120) do
                v:cancel();
            end;

            u121 = true;

            return u118(...);
        end) then
            return;
        end;

        for i, v in ipairs(u113) do
            u120[i] = v:andThen(function(...) -- Line: 455
                -- upvalues: u120 (copy), u121 (ref), u117 (copy)
                for _, v2 in ipairs(u120) do
                    v2:cancel();
                end;

                u121 = true;

                return u117(...);
            end, function(...) -- Line: 455
                -- upvalues: u120 (copy), u121 (ref), u118 (copy)
                for _, v2 in ipairs(u120) do
                    v2:cancel();
                end;

                u121 = true;

                return u118(...);
            end);
        end;

        if u121 then
            for _, v in ipairs(u120) do
                v:cancel();
            end;
        end;
    end);
end;

function u44.each(u123, u124) -- Line: 476
    -- upvalues: u44 (copy), u10 (ref)
    local v125 = type(u123) == "table";
    assert(v125, string.format("Please pass a list of promises to %s", "Promise.each"));
    local v126;

    if type(u124) == "function" then
        v126 = true;
    elseif type(u124) == "table" then
        local v127 = getmetatable(u124);

        if v127 then
            local v128 = rawget(v127, "__call");
            v126 = type(v128) == "function";
        else
            v126 = false;
        end;
    else
        v126 = false;
    end;

    assert(v126, string.format("Please pass a handler function to %s!", "Promise.each"));

    return u44._new(debug.traceback(nil, 2), function(p129, p130, p131) -- Line: 480
        -- upvalues: u123 (copy), u44 (ref), u10 (ref), u124 (copy)
        local v132 = {};
        local u133 = {};
        local u134 = false;

        local function _() -- Line: 486
            -- upvalues: u133 (copy)
            for _, v in ipairs(u133) do
                v:cancel();
            end;
        end;

        p131(function() -- Line: 492
            -- upvalues: u134 (ref), u133 (copy)
            u134 = true;

            for _, v in ipairs(u133) do
                v:cancel();
            end;
        end);
        local v135 = {};

        for i, v in ipairs(u123) do
            if u44.is(v) then
                if v:getStatus() == u44.Status.Cancelled then
                    for _, v2 in ipairs(u133) do
                        v2:cancel();
                    end;

                    return p130(u10.new({
                        error = "Promise is cancelled",
                        kind = u10.Kind.AlreadyCancelled,
                        context = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", i, v._source)
                    }));
                end;

                if v:getStatus() == u44.Status.Rejected then
                    for _, v2 in ipairs(u133) do
                        v2:cancel();
                    end;

                    return p130(select(2, v:await()));
                end;

                local v136 = v:andThen(function(...) -- Line: 518
                    return ...;
                end);
                table.insert(u133, v136);
                v135[i] = v136;
            else
                v135[i] = v;
            end;
        end;

        for i, v in ipairs(v135) do
            if u44.is(v) then
                local v137, v = v:await();

                if not v137 then
                    for _, v2 in ipairs(u133) do
                        v2:cancel();
                    end;

                    return p130(v);
                end;
            end;

            if u134 then
                return;
            end;

            local v138 = u44.resolve(u124(v, i));
            table.insert(u133, v138);
            local v139, v140 = v138:await();

            if not v139 then
                for _, v2 in ipairs(u133) do
                    v2:cancel();
                end;

                return p130(v140);
            end;

            v132[i] = v140;
        end;

        p129(v132);
    end);
end;

function u44.is(p141) -- Line: 562
    -- upvalues: u44 (copy)
    if type(p141) ~= "table" then
        return false;
    end;

    local v142 = getmetatable(p141);

    if v142 == u44 then
        return true;
    end;

    if v142 ~= nil then
        if type(v142) == "table" then
            local v143 = rawget(v142, "__index");

            if type(v143) == "table" then
                local v144 = rawget(v142, "__index");
                local v145 = rawget(v144, "andThen");
                local v146;

                if type(v145) == "function" then
                    v146 = true;
                else
                    local v147 = type(v145) == "table" and getmetatable(v145);

                    if v147 then
                        local v148 = rawget(v147, "__call");
                        v146 = type(v148) == "function";
                    else
                        v146 = false;
                    end;
                end;

                if v146 then
                    return true;
                end;
            end;
        end;

        return false;
    end;

    local andThen = p141.andThen;

    if type(andThen) == "function" then
        return true;
    end;

    local v149 = type(andThen) == "table" and getmetatable(andThen);

    if v149 then
        local v150 = rawget(v149, "__call");

        if type(v150) == "function" then
            return true;
        end;
    end;

    return false;
end;

function u44.promisify(u151) -- Line: 584
    -- upvalues: u44 (copy)
    return function(...) -- Line: 585
        -- upvalues: u44 (ref), u151 (copy)
        return u44._try(debug.traceback(nil, 2), u151, ...);
    end;
end;

local u152 = nil;
local u153 = nil;

function u44.delay(p154) -- Line: 594
    -- upvalues: u44 (copy), u153 (ref), u152 (ref)
    local v155 = type(p154) == "number";
    assert(v155, "Bad argument #1 to Promise.delay, must be a number.");
    local u156 = (p154 < 0.016666666666666666 or p154 == (1 / 0)) and 0.016666666666666666 or p154;

    return u44._new(debug.traceback(nil, 2), function(p157, p158, p159) -- Line: 600
        -- upvalues: u44 (ref), u156 (ref), u153 (ref), u152 (ref)
        local v160 = u44._getTime();
        local v161 = v160 + u156;
        local u162 = {
            resolve = p157,
            startTime = v160,
            endTime = v161
        };

        if u153 == nil then
            u152 = u162;
            u153 = u44._timeEvent:Connect(function() -- Line: 612
                -- upvalues: u44 (ref), u152 (ref), u153 (ref)
                local v163 = u44._getTime();

                while u152 ~= nil and u152.endTime < v163 do
                    local v164 = u152;
                    u152 = v164.next;

                    if u152 == nil then
                        u153:Disconnect();
                        u153 = nil;
                    else
                        u152.previous = nil;
                    end;

                    v164.resolve(u44._getTime() - v164.startTime);
                end;
            end);
        elseif u152.endTime < v161 then
            local v165 = u152;
            local next2 = v165.next;

            while next2 ~= nil and next2.endTime < v161 do
                v165 = next2;
                next2 = next2.next;
            end;

            v165.next = u162;
            u162.previous = v165;

            if next2 ~= nil then
                u162.next = next2;
                next2.previous = u162;
            end;
        else
            u162.next = u152;
            u152.previous = u162;
            u152 = u162;
        end;

        p159(function() -- Line: 653
            -- upvalues: u162 (copy), u152 (ref), u153 (ref)
            local next2 = u162.next;

            if u152 == u162 then
                if next2 == nil then
                    u153:Disconnect();
                    u153 = nil;
                else
                    next2.previous = nil;
                end;

                u152 = next2;

                return;
            end;

            local previous = u162.previous;
            previous.next = next2;

            if next2 ~= nil then
                next2.previous = previous;
            end;
        end);
    end);
end;

function u44.prototype.timeout(p166, u167, u168) -- Line: 677
    -- upvalues: u44 (copy), u10 (ref)
    local u169 = debug.traceback(nil, 2);

    return u44.race({ u44.delay(u167):andThen(function() -- Line: 681
            -- upvalues: u44 (ref), u168 (copy), u10 (ref), u167 (copy), u169 (copy)
            return u44.reject(u168 == nil and u10.new({
                error = "Timed out",
                kind = u10.Kind.TimedOut,
                context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", u167, u169)
            }) or u168);
        end), p166 });
end;

function u44.prototype.getStatus(p170) -- Line: 696
    return p170._status;
end;

function u44.prototype._andThen(u171, u172, u173, u174) -- Line: 700
    -- upvalues: u44 (copy), runExecutor (copy)
    u171._unhandledRejection = false;

    if u171._status ~= u44.Status.Cancelled then
        return u44._new(u172, function(u175, u176, p177) -- Line: 710
            -- upvalues: u173 (copy), u172 (copy), runExecutor (ref), u174 (copy), u171 (copy), u44 (ref)
            local u178;

            if u173 then
                local u179 = u172;
                local u180 = u173;

                u178 = function(...) -- Line: 152
                    -- upvalues: runExecutor (ref), u179 (copy), u180 (copy), u175 (copy), u176 (copy)
                    local v181, v182, v183 = runExecutor(u179, u180, ...);

                    if v181 then
                        u175(unpack(v183, 1, v182));

                        return;
                    end;

                    u176(v183[1]);
                end;
            else
                u178 = u175;
            end;

            if u174 then
                local u184 = u172;
                local u185 = u174;

                u176 = function(...) -- Line: 152
                    -- upvalues: runExecutor (ref), u184 (copy), u185 (copy), u175 (copy), u176 (copy)
                    local v186, v187, v188 = runExecutor(u184, u185, ...);

                    if v186 then
                        u175(unpack(v188, 1, v187));

                        return;
                    end;

                    u176(v188[1]);
                end;
            end;

            if u171._status == u44.Status.Started then
                table.insert(u171._queuedResolve, u178);
                table.insert(u171._queuedReject, u176);
                p177(function() -- Line: 725
                    -- upvalues: u171 (ref), u44 (ref), u178 (ref), u176 (ref)
                    if u171._status == u44.Status.Started then
                        table.remove(u171._queuedResolve, table.find(u171._queuedResolve, u178));
                        table.remove(u171._queuedReject, table.find(u171._queuedReject, u176));
                    end;
                end);
            elseif u171._status == u44.Status.Resolved then
                u178(unpack(u171._values, 1, u171._valuesLength));
            elseif u171._status == u44.Status.Rejected then
                u176(unpack(u171._values, 1, u171._valuesLength));
            end;
        end, u171);
    end;

    local v189 = u44.new(function() -- Line: 704
    end);
    v189:cancel();

    return v189;
end;

function u44.prototype.andThen(p190, p191, p192) -- Line: 739
    local v193;

    if p191 == nil or type(p191) == "function" then
        v193 = true;
    elseif type(p191) == "table" then
        local v194 = getmetatable(p191);

        if v194 then
            local v195 = rawget(v194, "__call");
            v193 = type(v195) == "function";
        else
            v193 = false;
        end;
    else
        v193 = false;
    end;

    assert(v193, string.format("Please pass a handler function to %s!", "Promise:andThen"));
    local v196;

    if p192 == nil or type(p192) == "function" then
        v196 = true;
    elseif type(p192) == "table" then
        local v197 = getmetatable(p192);

        if v197 then
            local v198 = rawget(v197, "__call");
            v196 = type(v198) == "function";
        else
            v196 = false;
        end;
    else
        v196 = false;
    end;

    assert(v196, string.format("Please pass a handler function to %s!", "Promise:andThen"));

    return p190:_andThen(debug.traceback(nil, 2), p191, p192);
end;

function u44.prototype.catch(p199, p200) -- Line: 746
    local v201;

    if p200 == nil or type(p200) == "function" then
        v201 = true;
    elseif type(p200) == "table" then
        local v202 = getmetatable(p200);

        if v202 then
            local v203 = rawget(v202, "__call");
            v201 = type(v203) == "function";
        else
            v201 = false;
        end;
    else
        v201 = false;
    end;

    assert(v201, string.format("Please pass a handler function to %s!", "Promise:catch"));

    return p199:_andThen(debug.traceback(nil, 2), nil, p200);
end;

function u44.prototype.tap(p204, u205) -- Line: 751
    -- upvalues: u44 (copy), pack (copy)
    local v206;

    if type(u205) == "function" then
        v206 = true;
    elseif type(u205) == "table" then
        local v207 = getmetatable(u205);

        if v207 then
            local v208 = rawget(v207, "__call");
            v206 = type(v208) == "function";
        else
            v206 = false;
        end;
    else
        v206 = false;
    end;

    assert(v206, string.format("Please pass a handler function to %s!", "Promise:tap"));

    return p204:_andThen(debug.traceback(nil, 2), function(...) -- Line: 753
        -- upvalues: u205 (copy), u44 (ref), pack (ref)
        local v209 = u205(...);

        if not u44.is(v209) then
            return ...;
        end;

        local u210, u211 = pack(...);

        return v209:andThen(function() -- Line: 758
            -- upvalues: u211 (copy), u210 (copy)
            return unpack(u211, 1, u210);
        end);
    end);
end;

function u44.prototype.andThenCall(p212, u213, ...) -- Line: 767
    -- upvalues: pack (copy)
    local v214;

    if type(u213) == "function" then
        v214 = true;
    elseif type(u213) == "table" then
        local v215 = getmetatable(u213);

        if v215 then
            local v216 = rawget(v215, "__call");
            v214 = type(v216) == "function";
        else
            v214 = false;
        end;
    else
        v214 = false;
    end;

    assert(v214, string.format("Please pass a handler function to %s!", "Promise:andThenCall"));
    local u217, u218 = pack(...);

    return p212:_andThen(debug.traceback(nil, 2), function() -- Line: 770
        -- upvalues: u213 (copy), u218 (copy), u217 (copy)
        return u213(unpack(u218, 1, u217));
    end);
end;

function u44.prototype.andThenReturn(p219, ...) -- Line: 775
    -- upvalues: pack (copy)
    local u220, u221 = pack(...);

    return p219:_andThen(debug.traceback(nil, 2), function() -- Line: 777
        -- upvalues: u221 (copy), u220 (copy)
        return unpack(u221, 1, u220);
    end);
end;

function u44.prototype.cancel(p222) -- Line: 782
    -- upvalues: u44 (copy)
    if p222._status ~= u44.Status.Started then
        return;
    end;

    p222._status = u44.Status.Cancelled;

    if p222._cancellationHook then
        p222._cancellationHook();
    end;

    coroutine.close(p222._thread);

    if p222._parent then
        p222._parent:_consumerCancelled(p222);
    end;

    for i in pairs(p222._consumers) do
        i:cancel();
    end;

    p222:_finalize();
end;

function u44.prototype._consumerCancelled(p223, p224) -- Line: 806
    -- upvalues: u44 (copy)
    if p223._status ~= u44.Status.Started then
        return;
    end;

    p223._consumers[p224] = nil;

    if next(p223._consumers) == nil then
        p223:cancel();
    end;
end;

function u44.prototype._finally(u225, p226, u227) -- Line: 818
    -- upvalues: u44 (copy)
    u225._unhandledRejection = false;

    return u44._new(p226, function(u228, u229, p230) -- Line: 821
        -- upvalues: u225 (copy), u227 (copy), u44 (ref)
        local u231 = nil;
        p230(function() -- Line: 824
            -- upvalues: u225 (ref), u231 (ref)
            u225:_consumerCancelled(u225);

            if u231 then
                u231:cancel();
            end;
        end);
        local v234 = u227 and function(...) -- Line: 834
            -- upvalues: u227 (ref), u44 (ref), u231 (ref), u228 (copy), u225 (ref), u229 (copy)
            local v232 = u227(...);

            if not u44.is(v232) then
                u228(u225);

                return;
            end;

            u231 = v232;
            v232:finally(function(p233) -- Line: 841
                -- upvalues: u44 (ref), u228 (ref), u225 (ref)
                if p233 ~= u44.Status.Rejected then
                    u228(u225);
                end;
            end):catch(function(...) -- Line: 846
                -- upvalues: u229 (ref)
                u229(...);
            end);
        end or u228;

        if u225._status == u44.Status.Started then
            table.insert(u225._queuedFinally, v234);
        else
            v234(u225._status);
        end;
    end);
end;

function u44.prototype.finally(p235, p236) -- Line: 865
    local v237;

    if p236 == nil or type(p236) == "function" then
        v237 = true;
    elseif type(p236) == "table" then
        local v238 = getmetatable(p236);

        if v238 then
            local v239 = rawget(v238, "__call");
            v237 = type(v239) == "function";
        else
            v237 = false;
        end;
    else
        v237 = false;
    end;

    assert(v237, string.format("Please pass a handler function to %s!", "Promise:finally"));

    return p235:_finally(debug.traceback(nil, 2), p236);
end;

function u44.prototype.finallyCall(p240, u241, ...) -- Line: 870
    -- upvalues: pack (copy)
    local v242;

    if type(u241) == "function" then
        v242 = true;
    elseif type(u241) == "table" then
        local v243 = getmetatable(u241);

        if v243 then
            local v244 = rawget(v243, "__call");
            v242 = type(v244) == "function";
        else
            v242 = false;
        end;
    else
        v242 = false;
    end;

    assert(v242, string.format("Please pass a handler function to %s!", "Promise:finallyCall"));
    local u245, u246 = pack(...);

    return p240:_finally(debug.traceback(nil, 2), function() -- Line: 873
        -- upvalues: u241 (copy), u246 (copy), u245 (copy)
        return u241(unpack(u246, 1, u245));
    end);
end;

function u44.prototype.finallyReturn(p247, ...) -- Line: 878
    -- upvalues: pack (copy)
    local u248, u249 = pack(...);

    return p247:_finally(debug.traceback(nil, 2), function() -- Line: 880
        -- upvalues: u249 (copy), u248 (copy)
        return unpack(u249, 1, u248);
    end);
end;

function u44.prototype.awaitStatus(p250) -- Line: 885
    -- upvalues: u44 (copy)
    p250._unhandledRejection = false;

    if p250._status == u44.Status.Started then
        local u251 = coroutine.running();
        p250:finally(function() -- Line: 892
            -- upvalues: u251 (copy)
            task.spawn(u251);
        end):catch(function() -- Line: 895
        end);
        coroutine.yield();
    end;

    if p250._status == u44.Status.Resolved then
        return p250._status, unpack(p250._values, 1, p250._valuesLength);
    end;

    if p250._status == u44.Status.Rejected then
        return p250._status, unpack(p250._values, 1, p250._valuesLength);
    end;

    return p250._status;
end;

local function awaitHelper(p252, ...) -- Line: 909
    -- upvalues: u44 (copy)
    return p252 == u44.Status.Resolved, ...;
end;

function u44.prototype.await(p253) -- Line: 913
    -- upvalues: awaitHelper (copy)
    return awaitHelper(p253:awaitStatus());
end;

local function expectHelper(p254, ...) -- Line: 917
    -- upvalues: u44 (copy)
    if p254 ~= u44.Status.Resolved then
        error(... == nil and "Expected Promise rejected with no value." or ..., 3);
    end;

    return ...;
end;

function u44.prototype.expect(p255) -- Line: 925
    -- upvalues: expectHelper (copy)
    return expectHelper(p255:awaitStatus());
end;

u44.prototype.awaitValue = u44.prototype.expect;

function u44.prototype._resolve(u256, ...) -- Line: 932
    -- upvalues: u44 (copy), u10 (ref), pack (copy)
    if u256._status ~= u44.Status.Started then
        if u44.is((...)) then
            (...):_consumerCancelled(u256);
        end;

        return;
    end;

    if u44.is((...)) then
        if select("#", ...) > 1 then
            local v257 = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", u256._source);
            warn(v257);
        end;

        local u258 = ...;
        local v260 = u258:andThen(function(...) -- Line: 952
            -- upvalues: u256 (copy)
            u256:_resolve(...);
        end, function(...) -- Line: 955
            -- upvalues: u258 (copy), u10 (ref), u256 (copy)
            local v259 = u258._values[1];

            if u10.isKind(v259, u10.Kind.ExecutionError) then
                return u256:_reject(v259:extend({
                    error = "This Promise was chained to a Promise that errored.",
                    trace = "",
                    context = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", u256._source)
                }));
            end;

            u256:_reject(...);
        end);

        if v260._status == u44.Status.Cancelled then
            u256:cancel();

            return;
        end;

        if v260._status == u44.Status.Started then
            u256._parent = v260;
            v260._consumers[u256] = true;
        end;

        return;
    end;

    u256._status = u44.Status.Resolved;
    local v261, v262 = pack(...);
    u256._valuesLength = v261;
    u256._values = v262;

    for _, v in ipairs(u256._queuedResolve) do
        task.spawn(v, ...);
    end;

    u256:_finalize();
end;

function u44.prototype._reject(u263, ...) -- Line: 993
    -- upvalues: u44 (copy), pack (copy)
    if u263._status ~= u44.Status.Started then
        return;
    end;

    u263._status = u44.Status.Rejected;
    local v264, v265 = pack(...);
    u263._valuesLength = v264;
    u263._values = v265;

    if next(u263._queuedReject) == nil then
        local u266 = tostring((...));
        local u267, u268 = pack(...);
        task.spawn(function() -- Line: 1009
            -- upvalues: u44 (ref), u263 (copy), u268 (copy), u267 (copy), u266 (copy)
            u44._timeEvent:Wait();

            if not u263._unhandledRejection then
                return;
            end;

            if next(u44._unhandledRejectionCallbacks) ~= nil then
                for _, v in ipairs(u44._unhandledRejectionCallbacks) do
                    v(u263, unpack(u268, 1, u267));
                end;

                return;
            end;

            local v269 = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", u266, u263._source);
            warn(v269);
        end);
    else
        for _, v in ipairs(u263._queuedReject) do
            task.spawn(v, ...);
        end;
    end;

    u263:_finalize();
end;

function u44.prototype._finalize(p270) -- Line: 1034
    for _, v in ipairs(p270._queuedFinally) do
        task.spawn(v, p270._status);
    end;

    p270._queuedFinally = nil;
    p270._queuedReject = nil;
    p270._queuedResolve = nil;
    p270._parent = nil;
    p270._consumers = nil;
end;

function u44.prototype.now(p271, p272) -- Line: 1047
    -- upvalues: u44 (copy), u10 (ref)
    local v273 = debug.traceback(nil, 2);

    if p271:getStatus() == u44.Status.Resolved then
        return p271:_andThen(v273, function(...) -- Line: 1050
            return ...;
        end);
    end;

    local reject = u44.reject;

    if p272 == nil then
        p272 = u10.new({
            error = "This Promise was not resolved in time for :now()",
            kind = u10.Kind.NotResolvedInTime,
            context = ":now() was called at:\n\n" .. v273
        }) or p272;
    end;

    return reject(p272);
end;

function u44.retry(u274, u275, ...) -- Line: 1062
    -- upvalues: u44 (copy)
    local v276;

    if type(u274) == "function" then
        v276 = true;
    elseif type(u274) == "table" then
        local v277 = getmetatable(u274);

        if v277 then
            local v278 = rawget(v277, "__call");
            v276 = type(v278) == "function";
        else
            v276 = false;
        end;
    else
        v276 = false;
    end;

    assert(v276, "Parameter #1 to Promise.retry must be a function");
    local v279 = type(u275) == "number";
    assert(v279, "Parameter #2 to Promise.retry must be a number");
    local u280 = { ... };
    local u281 = select("#", ...);

    return u44.resolve(u274(...)):catch(function(...) -- Line: 1068
        -- upvalues: u275 (copy), u44 (ref), u274 (copy), u280 (copy), u281 (copy)
        if u275 > 0 then
            return u44.retry(u274, u275 - 1, unpack(u280, 1, u281));
        end;

        return u44.reject(...);
    end);
end;

function u44.retryWithDelay(u282, u283, u284, ...) -- Line: 1077
    -- upvalues: u44 (copy)
    local v285;

    if type(u282) == "function" then
        v285 = true;
    elseif type(u282) == "table" then
        local v286 = getmetatable(u282);

        if v286 then
            local v287 = rawget(v286, "__call");
            v285 = type(v287) == "function";
        else
            v285 = false;
        end;
    else
        v285 = false;
    end;

    assert(v285, "Parameter #1 to Promise.retryWithDelay must be a function");
    local v288 = type(u283) == "number";
    assert(v288, "Parameter #2 to Promise.retryWithDelay must be a number");
    local v289 = type(u284) == "number";
    assert(v289, "Parameter #3 to Promise.retryWithDelay must be a number");
    local u290 = { ... };
    local u291 = select("#", ...);

    return u44.resolve(u282(...)):catch(function(...) -- Line: 1084
        -- upvalues: u283 (copy), u44 (ref), u284 (copy), u282 (copy), u290 (copy), u291 (copy)
        if u283 > 0 then
            return u44.delay(u284):andThen(function() -- Line: 1086
                -- upvalues: u44 (ref), u282 (ref), u283 (ref), u284 (ref), u290 (ref), u291 (ref)
                return u44.retryWithDelay(u282, u283 - 1, u284, unpack(u290, 1, u291));
            end);
        end;

        return u44.reject(...);
    end);
end;

function u44.fromEvent(u292, p293) -- Line: 1095
    -- upvalues: u44 (copy)
    local u294 = p293 or function() -- Line: 1096
        return true;
    end;

    return u44._new(debug.traceback(nil, 2), function(u295, p296, p297) -- Line: 1100
        -- upvalues: u292 (copy), u294 (ref)
        local u298 = nil;
        local u299 = false;

        local function disconnect() -- Line: 1104
            -- upvalues: u298 (ref)
            u298:Disconnect();
            u298 = nil;
        end;

        u298 = u292:Connect(function(...) -- Line: 1109
            -- upvalues: u294 (ref), u295 (copy), u298 (ref), u299 (ref)
            local v300 = u294(...);

            if v300 ~= true then
                if type(v300) ~= "boolean" then
                    error("Promise.fromEvent predicate should always return a boolean");
                end;

                return;
            end;

            u295(...);

            if not u298 then
                u299 = true;

                return;
            end;

            u298:Disconnect();
            u298 = nil;
        end);

        if u299 and u298 then
            return disconnect();
        end;

        p297(function() -- Line: 1129
            -- upvalues: u298 (ref)
            u298:Disconnect();
            u298 = nil;
        end);
    end);
end;

function u44.onUnhandledRejection(u301) -- Line: 1135
    -- upvalues: u44 (copy)
    local v302;

    if type(u301) == "function" then
        v302 = true;
    elseif type(u301) == "table" then
        local v303 = getmetatable(u301);

        if v303 then
            local v304 = rawget(v303, "__call");
            v302 = type(v304) == "function";
        else
            v302 = false;
        end;
    else
        v302 = false;
    end;

    assert(v302, "Parameter #1 to Promise.onUnhandledRejection must be a function");
    table.insert(u44._unhandledRejectionCallbacks, u301);

    return function() -- Line: 1140
        -- upvalues: u44 (ref), u301 (copy)
        local v305 = table.find(u44._unhandledRejectionCallbacks, u301);

        if v305 then
            table.remove(u44._unhandledRejectionCallbacks, v305);
        end;
    end;
end;

return u44;