-- ╔═══════════════════════════════════════════════════════════╗
-- ║                LSP Configuration                          ║
-- ╚═══════════════════════════════════════════════════════════╝

return {
  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      -- LSP keymaps (activated when LSP attaches)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local keymap = vim.keymap.set
          local bufopts = { noremap = true, silent = true, buffer = bufnr }

          keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", bufopts, { desc = "Go to declaration" }))
          keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", bufopts, { desc = "Go to definition" }))
          keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "Hover documentation" }))
          keymap("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", bufopts, { desc = "Go to implementation" }))
          keymap("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", bufopts, { desc = "Signature help" }))
          keymap("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "Rename symbol" }))
          keymap("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "Code action" }))
          keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", bufopts, { desc = "References" }))
          keymap("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", bufopts, { desc = "Line diagnostics" }))
          keymap("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", bufopts, { desc = "Previous diagnostic" }))
          keymap("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", bufopts, { desc = "Next diagnostic" }))
          keymap("n", "<leader>rs", ":LspRestart<CR>", vim.tbl_extend("force", bufopts, { desc = "Restart LSP" }))
        end,
      })

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })

      -- Diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Enhanced capabilities for autocompletion
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Configure individual language servers using vim.lsp.config
      -- Rust
      vim.lsp.config.rust_analyzer = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_dir = vim.fs.root(0, { "Cargo.toml" }),
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            assist = {
              importGranularity = "module",
              importPrefix = "by_self",
            },
            cargo = {
              loadOutDirsFromCheck = true,
              allFeatures = true,
            },
            procMacro = {
              enable = true,
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      }

      -- Python
      vim.lsp.config.basedpyright = {
        cmd = { "basedpyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_dir = vim.fs.root(0, { "pyproject.toml", "setup.py", "requirements.txt" }),
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      }

      -- TypeScript/JavaScript
      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", "jsconfig.json" }),
        capabilities = capabilities,
      }

      -- Ruby
      vim.lsp.config.solargraph = {
        cmd = { "solargraph", "stdio" },
        filetypes = { "ruby" },
        root_dir = vim.fs.root(0, { "Gemfile", ".git" }),
        capabilities = capabilities,
      }

      -- Bash
      vim.lsp.config.bashls = {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
        root_dir = vim.fs.root(0, { ".git" }),
        capabilities = capabilities,
      }

      -- Dart/Flutter
      vim.lsp.config.dartls = {
        cmd = { "dart", "language-server", "--protocol=lsp" },
        filetypes = { "dart" },
        root_dir = vim.fs.root(0, { "pubspec.yaml" }),
        capabilities = capabilities,
      }

      -- Lua (for Neovim config)
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_dir = vim.fs.root(0, { ".luarc.json", ".luacheckrc", ".git" }),
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      }

      -- Enable LSP servers automatically on their filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "rust", "python", "javascript", "javascriptreact", "typescript", "typescriptreact", "ruby", "sh", "bash", "dart", "lua" },
        callback = function(args)
          vim.lsp.enable(vim.bo[args.buf].filetype)
        end,
      })
    end,
  },

  -- Mason for LSP/DAP/Linter/Formatter management
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "rust_analyzer",
          "basedpyright",
          "ts_ls",
          "solargraph",
          "bashls",
          "dartls",
          "lua_ls",
        },
        automatic_installation = true,
      })
    end,
  },
}
