function starship_transient_prompt_func(prompt)
    return io.popen("starship module character"
        .. " --keymap=" .. rl.getvariable('keymap')
    ):read("*a")
end

load(io.popen("starship init cmd"):read("*a"))()
