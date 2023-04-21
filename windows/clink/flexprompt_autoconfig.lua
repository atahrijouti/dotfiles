-- WARNING:  This file gets overwritten by the 'flexprompt configure' wizard!
--
-- If you want to make changes, consider copying the file to
-- 'flexprompt_config.lua' and editing that file instead.

flexprompt = flexprompt or {}
flexprompt.settings = flexprompt.settings or {}
flexprompt.settings.lines = "two"
flexprompt.settings.use_8bit_color = true
flexprompt.settings.lean_separators = "space"
flexprompt.settings.heads = "pointed"
flexprompt.settings.spacing = "normal"
flexprompt.settings.left_prompt = "{battery}{histlabel}{cwd}{git}{duration}"
flexprompt.settings.style = "lean"
flexprompt.settings.right_frame = "none"
flexprompt.settings.symbols =
{
    prompt =
    {
        ">",
        winterminal = "❯",
    },
}
flexprompt.settings.flow = "concise"
flexprompt.settings.left_frame = "none"
flexprompt.settings.connection = "disconnected"
flexprompt.settings.charset = "unicode"
flexprompt.settings.powerline_font = true
