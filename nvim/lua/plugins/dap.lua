-- ╔═══════════════════════════════════════════════════════════╗
-- ║              Debug Adapter Protocol (DAP)                ║
-- ╚═══════════════════════════════════════════════════════════╝

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
      })

      -- Virtual text
      require("nvim-dap-virtual-text").setup()

      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Keymaps
      local keymap = vim.keymap.set
      keymap("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      keymap("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Conditional breakpoint" })
      keymap("n", "<leader>dc", dap.continue, { desc = "Continue" })
      keymap("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
      keymap("n", "<leader>di", dap.step_into, { desc = "Step into" })
      keymap("n", "<leader>do", dap.step_over, { desc = "Step over" })
      keymap("n", "<leader>dO", dap.step_out, { desc = "Step out" })
      keymap("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
      keymap("n", "<leader>dl", dap.run_last, { desc = "Run last" })
      keymap("n", "<leader>dt", dapui.toggle, { desc = "Toggle DAP UI" })
      keymap("n", "<leader>dx", dap.terminate, { desc = "Terminate" })

      -- DAP configurations for different languages
      -- Python
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return "/usr/bin/python"
          end,
        },
      }

      -- Rust (using codelldb)
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },

  -- Language specific DAP extensions
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require("dap-python").setup("python")
    end,
  },
}
