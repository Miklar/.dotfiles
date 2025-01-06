return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      "saghen/blink.cmp",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- see below for full list of optional dependencies 👇
    },
    config = function()
      require("obsidian").setup({
        workspaces = {
          {
            name = "zettelkasten",
            path = "/Users/miklar/Library/Mobile Documents/iCloud~md~obsidian/Documents/zettelkasten",
          },
        },

        notes_subdir = "00 Inbox",
        -- Where to put new notes. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        new_notes_location = "notes_subdir",

        -- Optional, for templates (see below).
        templates = {
          folder = "90 Extra/Templates",
          date_format = "%Y-%m-%d",
          time_format = "%H:%M",
          -- A map for custom variables, the key should be the variable and the value a function
          substitutions = {},
        },

        ---@diagnostic disable-next-line: missing-fields
        daily_notes = {
          folder = "10 Journal", --/%Y/%d-%B/",
          -- YYYY/MM-MMMM/YYYY-MM-DD-dddd
          date_format = "%Y-%m-%d-%A",
          alias_format = "%B %-d, %Y",
          default_tags = { "daily-notes" },
          template = "Template, Daily Note.md"
        },

        -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
        ---@diagnostic disable-next-line: missing-fields
        completion = {
          -- Set to false to disable completion.
          nvim_cmp = false, -- lets wait for blink support
          -- Trigger completion at 2 chars.
          min_chars = 2,
        },

        vim.keymap.set("n", "gf", require("obsidian").util.gf_passthrough,
          { noremap = false, expr = true, buffer = true }),
        vim.keymap.set("n", "<leader>ch", require("obsidian").util.toggle_checkbox, { buffer = true }),
        vim.keymap.set("n", "<cr>", require("obsidian").util.smart_action, { expr = true, buffer = true }),
        vim.keymap.set("n", "<leader>bn", "<cmd>ObsidianNew<CR>", { buffer = true }),
        vim.keymap.set("n", "<leader>bd", "<cmd>ObsidianToday<CR>", { buffer = true }),
        vim.keymap.set("n", "<leader>bt", "<cmd>ObsidianTags<CR>", { buffer = true }),

        wiki_link_func = "use_alias_only",
        -- Either 'wiki' or 'markdown'.
        preferred_link_style = "wiki",

        -- Optional, customize how note IDs are generated given an optional title.
        ---@param title string|?
        ---@return string
        note_id_func = function(title)
          -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
          -- In this case a note with the title 'My new note' will be given an ID that looks
          -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
          local suffix = ""
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          -- return tostring(os.time()) .. "-" .. suffix
          return suffix
        end,

        note_frontmatter_func = function(note)
          -- Add the title of the note as an alias.
          if note.title then
            note:add_alias(note.title)
          end

          local out = { id = note.id, aliases = note.aliases, tags = note.tags }

          -- `note.metadata` contains any manually added fields in the frontmatter.
          -- So here we just make sure those fields are kept in the frontmatter.
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end

          return out
        end,

        ---@diagnostic disable-next-line: missing-fields
        picker = {
          -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
          name = "telescope.nvim",
          -- Optional, configure key mappings for the picker. These are the defaults.
          -- Not all pickers support all mappings.
          ---@diagnostic disable-next-line: missing-fields
          note_mappings = {
            -- Create a new note from your query.
            new = "<C-x>",
            -- Insert a link to the selected note.
            insert_link = "<C-l>",
          },
          ---@diagnostic disable-next-line: missing-fields
          tag_mappings = {
            -- Add tag(s) to current note.
            tag_note = "<C-x>",
            -- Insert a tag at the current location.
            insert_tag = "<C-l>",
          },
        },

        -- Optional, sort search results by "path", "modified", "accessed", or "created".
        -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
        -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
        sort_by = "modified",
        sort_reversed = true,

      })
      vim.opt.conceallevel = 1
    end
  }
}
