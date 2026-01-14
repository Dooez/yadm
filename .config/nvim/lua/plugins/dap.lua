return {
    {
        'mfussenegger/nvim-dap',
        enabled = vim.g.have_dap,
        dependencies = {
            {
                'rcarriga/nvim-dap-ui',
                dependencies = {
                    'nvim-neotest/nvim-nio'
                }
            },
            'williamboman/mason.nvim', -- Installs the debug adapters for you
            'jay-babu/mason-nvim-dap.nvim',
            'rcarriga/nvim-notify',
            "theHamsta/nvim-dap-virtual-text",
            "kdheepak/nvim-dap-julia",

        },
        config = function()
            local dap = require 'dap'
            local dapui = require 'dapui'

            require("nvim-dap-julia").setup({})

            -- Basic debugging keymaps, feel free to change to your liking!
            vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
            vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
            vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
            vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
            vim.keymap.set('n', '<S-l>', dapui.eval, { desc = 'Debug: E[v]aluate expression in floating window' })
            vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint,
                { desc = 'Debug: Toggle Breakpoint' })
            vim.keymap.set('n', '<leader>B', function()
                dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
            end, { desc = 'Debug: Set Breakpoint' })
            vim.keymap.set('n', '<F7>', dapui.toggle,
                { desc = 'Debug: See last session result.' })

            -- Dap UI setup
            -- For more information, see |:help nvim-dap-ui|
            dapui.setup({
                icons = {
                    collapsed = "",
                    current_frame = "→",
                    expanded = ""
                },
                layouts = { {
                    elements = {
                        { id = "breakpoints", size = 0.15 },
                        { id = "stacks",      size = 0.35 },
                        { id = "scopes",      size = 0.35 },
                        { id = "watches",     size = 0.15 },
                    },
                    position = "left",
                    size = 40
                }, {
                    elements = {
                        { id = "repl",    size = 0.3 },
                        { id = "console", size = 0.7 },
                    },
                    position = "bottom",
                    size = 15
                } },
            })

            dap.listeners.after.event_initialized['dapui_config'] = dapui.open
            dap.listeners.before.event_terminated['dapui_config'] = dapui.close
            dap.listeners.before.event_exited['dapui_config'] = dapui.close



            dap.adapters.lldb = {
                type = 'executable',
                command = '/usr/bin/lldb-dap',
                -- options = {
                --     initialize_timeout_sec = 10,
                -- },
            }
            dap.adapters.codelldb = {
                type = 'server',
                port = "13000",
                executable = {
                    command = 'codelldb',
                    args = { "--port", "13000" },
                }
            }
            dap.adapters.sudocodelldb = {
                type = 'server',
                port = "13000",
                executable = {
                    command = '/home/timofey/sudo.lldb',
                    args = { "--port", "13000" },
                }
            }
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
            }
            dap.adapters.sudogdb = {
                type = 'executable',
                command = '/home/timofey/sudo.gdb',
                options = {
                    env = {
                        ["DISPLAY"] = ":0",
                        ["XAUTHORITY"] = "/run/user/1000/gdm/Xauthority",
                    },
                }
            }
            local get_cmake_target = function()
                local cmake_found, cmake = pcall(require, 'cmake-tools')
                if not cmake_found then
                    require('notify')('CMake not found.', vim.log.levels.ERROR,
                        { title = 'Launching CMake target debug' })
                    return dap.ABORT
                end
                return cmake.get_build_directory() .. '/' .. cmake.get_launch_target()
            end
            local cpp_cfgs = {
                {
                    name = "lldb=>CMake Target",
                    type = "lldb",
                    request = "launch",
                    program = get_cmake_target,
                    cwd = '${workspaceFolder}',
                    -- stopOnEntry = false,
                    runInTerminal = true,
                    args = {},
                },
                {
                    name = "gdb=>CMake Target",
                    type = "gdb",
                    request = "launch",
                    program = get_cmake_target,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                },
                {
                    name = "root=>codelldb=>CMake Target",
                    type = "sudocodelldb",
                    request = "launch",
                    program = get_cmake_target,
                    cwd = '${workspaceFolder}',
                    env = { ['DISPLAY'] = '${env:DISPLAY}', ['XAUTHORITY'] = '${env:XAUTHORITY}' },
                    sourceLanguages = { "cpp" },
                    stopOnEntry = false,
                },
            }
            if vim.g.have_cortex_dbg then
                local get_cmake_target_elf = function()
                    local cmake_found, cmake = pcall(require, 'cmake-tools')
                    if not cmake_found then
                        require('notify')('CMake not found.', vim.log.levels.ERROR,
                            { title = 'Launching CMake target debug' })
                        return dap.ABORT
                    end
                    return cmake.get_build_directory() .. '/' .. cmake.get_launch_target() .. '.elf'
                end
                local dap_cortex_debug = require('dap-cortex-debug')
                cpp_cfgs[#cpp_cfgs + 1] = dap_cortex_debug.openocd_config({
                    name = 'OpenOCD CMake target',
                    cwd = '${workspaceFolder}',
                    executable = get_cmake_target_elf,
                    configFiles = {
                        "interface/stlink.cfg",
                        "target/stm32f4x.cfg"
                    },
                    gdbTarget = 'localhost:3333',
                    rttConfig = dap_cortex_debug.rtt_config(0),
                    showDevDebugOutput = false,
                })
            end

            dap.configurations.cpp = cpp_cfgs
            dap.listeners.before.event_exited["dapui_config"] = function(_, event) end     -- do not close dap after end
            dap.listeners.before.event_terminated["dapui_config"] = function(_, event) end -- do not close dap after end

            local sign = vim.fn.sign_define
            sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
            sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
            sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
        end
    },
    {
        'jedrzejboczar/nvim-dap-cortex-debug',
        enabled = vim.g.have_dap and vim.g.have_cortex_dbg,
        dependencies = {
            'mfussenegger/nvim-dap'
        },
        config = function()
            require('dap-cortex-debug').setup {
                debug = false, -- log debug messages
                -- path to cortex-debug extension, supports vim.fn.glob
                -- by default tries to guess: mason.nvim or VSCode extensions
                extension_path = nil,
                lib_extension = nil, -- shared libraries extension, tries auto-detecting, e.g. 'so' on unix
                node_path = 'node',  -- path to node.js executable
                dapui_rtt = true,    -- register nvim-dap-ui RTT element
                dap_vscode_filetypes = { 'c', 'cpp' },
            }
        end
    },
}
