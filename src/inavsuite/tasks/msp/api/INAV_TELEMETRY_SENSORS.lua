--[[
  Copyright (C) 2025 Rotorflight Project
  GPLv3 — https://www.gnu.org/licenses/gpl-3.0.en.html
]] --

local inavsuite = require("inavsuite")
local core = assert(loadfile("SCRIPTS:/" .. inavsuite.config.baseDir .. "/tasks/msp/api_core.lua"))()

local API_NAME = "INAV_TELEMETRY_SENSORS"
local MSP_API_CMD_READ = 0x222A
local MSP_API_CMD_WRITE = 0x222B
local MSP_REBUILD_ON_WRITE = false

-- LuaFormatter off
-- LuaFormatter off
local MSP_API_STRUCTURE_READ_DATA = {
    {field = "telem_sensor_slot_count", type = "U16", simResponse = {30, 0}},

    {field = "telem_sensor_slot_1", type = "U16", simResponse = {3, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_1)@"},
    {field = "telem_sensor_slot_2", type = "U16", simResponse = {4, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_2)@"},
    {field = "telem_sensor_slot_3", type = "U16", simResponse = {5, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_3)@"},
    {field = "telem_sensor_slot_4", type = "U16", simResponse = {6, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_4)@"},
    {field = "telem_sensor_slot_5", type = "U16", simResponse = {8, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_5)@"},
    {field = "telem_sensor_slot_6", type = "U16", simResponse = {8, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_6)@"},
    {field = "telem_sensor_slot_7", type = "U16", simResponse = {89, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_7)@"},
    {field = "telem_sensor_slot_8", type = "U16", simResponse = {90, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_8)@"},
    {field = "telem_sensor_slot_9", type = "U16", simResponse = {91, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_9)@"},
    {field = "telem_sensor_slot_10", type = "U16", simResponse = {99, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_10)@"},
    {field = "telem_sensor_slot_11", type = "U16", simResponse = {95, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_11)@"},
    {field = "telem_sensor_slot_12", type = "U16", simResponse = {96, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_12)@"},
    {field = "telem_sensor_slot_13", type = "U16", simResponse = {60, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_13)@"},
    {field = "telem_sensor_slot_14", type = "U16", simResponse = {15, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_14)@"},
    {field = "telem_sensor_slot_15", type = "U16", simResponse = {42, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_15)@"},
    {field = "telem_sensor_slot_16", type = "U16", simResponse = {93, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_16)@"},
    {field = "telem_sensor_slot_17", type = "U16", simResponse = {50, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_17)@"},
    {field = "telem_sensor_slot_18", type = "U16", simResponse = {51, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_18)@"},
    {field = "telem_sensor_slot_19", type = "U16", simResponse = {52, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_19)@"},
    {field = "telem_sensor_slot_20", type = "U16", simResponse = {17, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_20)@"},

    {field = "telem_sensor_slot_21", type = "U16", simResponse = {18, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_21)@"},
    {field = "telem_sensor_slot_22", type = "U16", simResponse = {19, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_22)@"},
    {field = "telem_sensor_slot_23", type = "U16", simResponse = {23, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_23)@"},
    {field = "telem_sensor_slot_24", type = "U16", simResponse = {22, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_24)@"},
    {field = "telem_sensor_slot_25", type = "U16", simResponse = {36, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_25)@"},

    {field = "telem_sensor_slot_26", type = "U16", simResponse = {0, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_26)@"},
    {field = "telem_sensor_slot_27", type = "U16", simResponse = {0, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_27)@"},
    {field = "telem_sensor_slot_28", type = "U16", simResponse = {0, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_28)@"},
    {field = "telem_sensor_slot_29", type = "U16", simResponse = {0, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_29)@"},
    {field = "telem_sensor_slot_30", type = "U16", simResponse = {0, 0}, help = "@i18n(api.TELEMETRY_CONFIG.telem_sensor_slot_30)@"},
}

-- LuaFormatter on

local MSP_API_STRUCTURE_READ, MSP_MIN_BYTES, MSP_API_SIMULATOR_RESPONSE = core.prepareStructureData(MSP_API_STRUCTURE_READ_DATA)

local MSP_API_STRUCTURE_WRITE = MSP_API_STRUCTURE_READ

local mspData = nil
local mspWriteComplete = false
local payloadData = {}
local defaultData = {}

local handlers = core.createHandlers()

local MSP_API_UUID
local MSP_API_MSG_TIMEOUT

local lastWriteUUID = nil

local writeDoneRegistry = setmetatable({}, {__mode = "kv"})

local function processReplyStaticRead(self, buf)
    core.parseMSPData(API_NAME, buf, self.structure, nil, nil, function(result)
        mspData = result
        if #buf >= (self.minBytes or 0) then
            local getComplete = self.getCompleteHandler
            if getComplete then
                local complete = getComplete()
                if complete then complete(self, buf) end
            end
        end
    end)
end

local function processReplyStaticWrite(self, buf)
    mspWriteComplete = true

    if self.uuid then writeDoneRegistry[self.uuid] = true end

    local getComplete = self.getCompleteHandler
    if getComplete then
        local complete = getComplete()
        if complete then complete(self, buf) end
    end
end

local function errorHandlerStatic(self, buf)
    local getError = self.getErrorHandler
    if getError then
        local err = getError()
        if err then err(self, buf) end
    end
end

local function read()
    if MSP_API_CMD_READ == nil then
        inavsuite.utils.log("No value set for MSP_API_CMD_READ", "debug")
        return
    end

    local message = {command = MSP_API_CMD_READ, structure = MSP_API_STRUCTURE_READ, minBytes = MSP_MIN_BYTES, processReply = processReplyStaticRead, errorHandler = errorHandlerStatic, simulatorResponse = MSP_API_SIMULATOR_RESPONSE, uuid = MSP_API_UUID, timeout = MSP_API_MSG_TIMEOUT, getCompleteHandler = handlers.getCompleteHandler, getErrorHandler = handlers.getErrorHandler, mspData = nil}
    inavsuite.tasks.msp.mspQueue:add(message)
end

local function write(suppliedPayload)
    if MSP_API_CMD_WRITE == nil then
        inavsuite.utils.log("No value set for MSP_API_CMD_WRITE", "debug")
        return
    end

    local payload = suppliedPayload or core.buildWritePayload(API_NAME, payloadData, MSP_API_STRUCTURE_WRITE, MSP_REBUILD_ON_WRITE)

    local uuid = MSP_API_UUID or inavsuite.utils and inavsuite.utils.uuid and inavsuite.utils.uuid() or tostring(os.clock())
    lastWriteUUID = uuid

    local message = {command = MSP_API_CMD_WRITE, payload = payload, processReply = processReplyStaticWrite, errorHandler = errorHandlerStatic, simulatorResponse = {}, uuid = uuid, timeout = MSP_API_MSG_TIMEOUT, getCompleteHandler = handlers.getCompleteHandler, getErrorHandler = handlers.getErrorHandler}

    inavsuite.tasks.msp.mspQueue:add(message)
end

local function readValue(fieldName)
    if mspData and mspData['parsed'][fieldName] ~= nil then return mspData['parsed'][fieldName] end
    return nil
end

local function setValue(fieldName, value) payloadData[fieldName] = value end

local function readComplete() return mspData ~= nil and #mspData['buffer'] >= MSP_MIN_BYTES end

local function writeComplete() return mspWriteComplete end

local function resetWriteStatus() mspWriteComplete = false end

local function data() return mspData end

local function setUUID(uuid) MSP_API_UUID = uuid end

local function setTimeout(timeout) MSP_API_MSG_TIMEOUT = timeout end

return {read = read, write = write, readComplete = readComplete, writeComplete = writeComplete, readValue = readValue, setValue = setValue, resetWriteStatus = resetWriteStatus, setCompleteHandler = handlers.setCompleteHandler, setErrorHandler = handlers.setErrorHandler, data = data, setUUID = setUUID, setTimeout = setTimeout}
