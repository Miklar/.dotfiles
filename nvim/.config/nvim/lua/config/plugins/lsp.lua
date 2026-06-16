return {
  {
    -- fix "Undefined global vim"
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = { vim.env.VIMRUNTIME },
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    }),
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = { registries = { "github:crashdummyy/mason-registry", "github:mason-org/mason-registry" } },
      },
      "neovim/nvim-lspconfig",
      "seblyng/roslyn.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "gopls", "ts_ls" },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("miklar-lsp-attach", { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", require("fzf-lua").lsp_code_actions, "Code Actions", { "n", "x" })

          -- Find references for the word under your cursor.
          map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gi", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("gds", require("fzf-lua").lsp_document_symbols, "Open Document Symbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("gws", require("fzf-lua").lsp_live_workspace_symbols, "Open Workspace Symbols")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("gt", require("fzf-lua").lsp_typedefs, "[G]oto [T]ype Definition")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("miklar-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("miklar-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "miklar-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- Autoformat on save (augroup per buffer prevents stacking when multiple clients attach)
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("miklar-lsp-format-" .. event.buf, { clear = true }),
            buffer = event.buf,
            callback = function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              for _, c in ipairs(clients) do
                if c.server_capabilities and c.server_capabilities.documentFormattingProvider then
                  vim.lsp.buf.format({ async = false })
                  break
                end
              end
            end,
          })

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end

          -- Diagnostic Config
          -- See :help vim.diagnostic.Opts
          vim.diagnostic.config({
            severity_sort = true,
            float = {
              border = "rounded",
              source = "if_many",
              focusable = false,
            },
            jump = { float = true },
            update_in_insert = false,
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font and {
              text = {
                [vim.diagnostic.severity.ERROR] = "󰅚 ",
                [vim.diagnostic.severity.WARN] = "󰀪 ",
                [vim.diagnostic.severity.INFO] = "󰋽 ",
                [vim.diagnostic.severity.HINT] = "󰌶 ",
              },
            } or {},
            virtual_text = false,
            -- virtual_text = {
            --   source = "if_many",
            --   spacing = 2,
            --   format = function(diagnostic)
            --     local diagnostic_message = {
            --       [vim.diagnostic.severity.ERROR] = diagnostic.message,
            --       [vim.diagnostic.severity.WARN] = diagnostic.message,
            --       [vim.diagnostic.severity.INFO] = diagnostic.message,
            --       [vim.diagnostic.severity.HINT] = diagnostic.message,
            --     }
            --     return diagnostic_message[diagnostic.severity]
            --   end,
            -- },
          })
        end,
      })
    end,
  },
}
