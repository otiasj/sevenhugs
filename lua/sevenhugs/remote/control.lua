local control = {}

-- Constructor for a Control class.
local function control_class_new(cls, params)
    local self = setmetatable({}, cls)
    self.params = params
    function self:close() end
    if cls.init then
        self:init()
    end
    return self
end

-- Return a new Control class.
function control.class()
    local cls = {}
    cls.__index = cls
    setmetatable(cls, { __call = control_class_new })
    return cls
end

return control
