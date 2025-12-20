--[[
  Copyright (C) 2025 Rotorflight Project
  GPLv3 — https://www.gnu.org/licenses/gpl-3.0.en.html
]] --

local inavsuite = require("inavsuite")

local telemetryconfig = {}

local mspCallMade = false

function telemetryconfig.wakeup()

    if inavsuite.session.apiVersion == nil then return end

    if inavsuite.session.mspBusy then return end

    if (inavsuite.session.telemetryConfig == nil) and (mspCallMade == false) then
        mspCallMade = true
        local API = inavsuite.tasks.msp.api.load("INAV_TELEMETRY_SENSORS")
        API.setCompleteHandler(function(self, buf)
            local data = API.data().parsed

            local slots = {}
            for i = 1, 30 do
                local key = "telem_sensor_slot_" .. i
                slots[i] = tonumber(data[key]) or 0
            end

            inavsuite.session.telemetryConfig = slots

            local parts = {}
            for i, v in ipairs(slots) do if v ~= 0 then parts[#parts + 1] = tostring(v) end end
            local slotsStr = table.concat(parts, ",")

            if inavsuite.utils and inavsuite.utils.log then inavsuite.utils.log("Updated telemetry sensors: " .. slotsStr, "info") end
        end)
        API.setUUID("38163617-1496-4886-8b81-6a1dd6d7ed81")
        API.read()
    end

end

function telemetryconfig.reset()
    inavsuite.session.telemetryConfig = nil
    mspCallMade = false
end

function telemetryconfig.isComplete() if inavsuite.session.telemetryConfig ~= nil then return true end end

return telemetryconfig
