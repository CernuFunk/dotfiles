# Configurazione Neovim

## Struttura

La configurazione di Neovim è organizzata in modo modulare con **lazy.nvim** come plugin manager:

```
nvim/
├── init.lua                 # Entry point principale
├── lua/
│   ├── config/
│   │   ├── options.lua      # Opzioni di Vim
│   │   ├── keymaps.lua      # Mappature tasti
│   │   └── autocmds.lua     # Autocomandi
│   └── plugins/
│       ├── init.lua         # Setup lazy.nvim
│       ├── ui.lua           # UI (tema, statusline, file explorer)
│       ├── treesitter.lua   # Syntax highlighting
│       ├── lsp.lua          # Language Server Protocol
│       ├── cmp.lua          # Autocompletamento
│       ├── telescope.lua    # Fuzzy finder
│       ├── git.lua          # Integrazione Git
│       ├── dap.lua          # Debug Adapter Protocol
│       ├── formatting.lua   # Formatter e linter
│       └── utils.lua        # Plugin utility
```

## Linguaggi Supportati

LSP configurato per:
- **Rust**: rust_analyzer
- **Python**: basedpyright
- **JavaScript/TypeScript**: ts_ls
- **Ruby**: solargraph
- **Bash**: bashls
- **Dart/Flutter**: dartls
- **Lua**: lua_ls (per configurazione Neovim)

## Plugin Principali

### UI e Aspetto
- **tokyonight.nvim**: Colorscheme
- **lualine.nvim**: Statusline
- **neo-tree.nvim**: File explorer
- **bufferline.nvim**: Buffer line
- **noice.nvim**: UI migliorata per messaggi e popups
- **indent-blankline.nvim**: Guide per indentazione

### Sviluppo
- **nvim-treesitter**: Syntax highlighting avanzato
- **nvim-lspconfig** + **mason.nvim**: LSP management
- **nvim-cmp**: Autocompletamento intelligente
- **LuaSnip**: Snippet engine
- **telescope.nvim**: Fuzzy finder per file, grep, simboli

### Git
- **gitsigns.nvim**: Mostra modifiche Git nella sign column
- **vim-fugitive**: Wrapper comandi Git
- **lazygit.nvim**: Integrazione LazyGit

### Debug
- **nvim-dap**: Debug Adapter Protocol
- **nvim-dap-ui**: UI per debugging
- **nvim-dap-python**: Estensione Python per DAP

### Formatting e Linting
- **conform.nvim**: Formatter (format on save)
- **nvim-lint**: Linting automatico

### Utility
- **nvim-autopairs**: Auto chiusura parentesi
- **Comment.nvim**: Commenti veloci
- **which-key.nvim**: Suggerimenti keybindings
- **nvim-surround**: Surround text objects
- **todo-comments.nvim**: Evidenzia TODO, FIXME, etc.
- **trouble.nvim**: Lista diagnostics migliorata
- **toggleterm.nvim**: Terminal integrato

## Keybindings Principali

### Leader Key
Leader = `<Space>`

### Generali
- `jk` → ESC (in insert mode)
- `<leader>w` → Salva file
- `<leader>q` → Chiudi
- `<Esc>` → Pulisci highlight ricerca

### Navigazione
- `<C-h/j/k/l>` → Naviga tra finestre
- `<S-h/l>` → Buffer precedente/successivo
- `<leader>bd` → Chiudi buffer

### File Explorer
- `<leader>e` → Toggle Neo-tree

### Telescope (Fuzzy Finder)
- `<leader>ff` → Find files
- `<leader>fg` → Live grep
- `<leader>fb` → Find buffers
- `<leader>fr` → Recent files
- `<leader>fh` → Help tags
- `<leader>fd` → Find diagnostics
- `<leader>fs` → Document symbols

### LSP
- `gd` → Go to definition
- `gD` → Go to declaration
- `gi` → Go to implementation
- `gr` → References
- `K` → Hover documentation
- `<leader>rn` → Rename symbol
- `<leader>ca` → Code action
- `[d` / `]d` → Diagnostic precedente/successivo

### Git
- `<leader>gg` → LazyGit
- `<leader>gs` → Git status (fugitive)
- `<leader>hs` → Stage hunk
- `<leader>hr` → Reset hunk
- `<leader>hp` → Preview hunk
- `<leader>hb` → Blame line
- `[c` / `]c` → Hunk precedente/successivo

### Debug
- `<leader>db` → Toggle breakpoint
- `<leader>dc` → Continue
- `<leader>di` → Step into
- `<leader>do` → Step over
- `<leader>dO` → Step out
- `<leader>dt` → Toggle DAP UI

### Format e Lint
- `<leader>mp` → Format file
- `<leader>ml` → Trigger linting

### Terminal
- `<C-\>` → Toggle terminal

## Primo Avvio

Al primo avvio di Neovim:

1. **lazy.nvim** verrà installato automaticamente
2. Tutti i plugin verranno scaricati (richiede connessione internet)
3. **Mason** installerà automaticamente gli LSP server

Comandi utili:
- `:Lazy` → Gestione plugin
- `:Mason` → Gestione LSP/DAP/formatter/linter
- `:checkhealth` → Verifica configurazione

## Requisiti

Dipendenze esterne necessarie:

```bash
# Per Telescope
sudo pacman -S ripgrep fd

# Per formatter/linter (installabili anche via Mason)
sudo pacman -S prettier black isort stylua rustfmt shfmt

# Per LazyGit
sudo pacman -S lazygit

# Per Markdown preview
sudo pacman -S nodejs npm
```

## Configurazione per Sistema

Questa configurazione è compatibile sia con:
- **Arch Linux** (KDE)
- **Artix Linux** (Sway)

Per collegare la configurazione:
```bash
ln -sf ~/dotfiles/nvim ~/.config/nvim
```

## Backup

Un backup della configurazione precedente è stato creato in `dotfiles/nvim-backup-*.tar.gz`

## Textobjects di Treesitter

Treesitter textobjects permette di selezionare e navigare nel codice in modo intelligente:

**Selezioni:**
- `af` / `if` - Funzione outer/inner
- `ac` / `ic` - Classe outer/inner
- `aa` / `ia` - Parametro outer/inner

**Navigazione:**
- `]f` / `[f` - Prossima/precedente funzione (start)
- `]c` / `[c` - Prossima/precedente classe (start)
- `]F` / `[F` - Prossima/precedente funzione (end)
- `]C` / `[C` - Prossima/precedente classe (end)

## Problemi Risolti

Durante il setup iniziale abbiamo risolto:
- ❌ Errore `E1155` in syntax.vim causato da `augroup` con `clear = true`
- ❌ Conflitto ordine di caricamento treesitter-textobjects
- ✅ Fix: rimosso uso di augroup con clear
- ✅ Fix: aggiunto pcall per caricamento sicuro dei plugin

## Note

- Format on save è abilitato di default
- La clipboard di sistema è integrata (`clipboard=unnamedplus`)
- File di undo persistente abilitato
- Treesitter fold è configurato ma disabilitato di default
- Trailing whitespace viene rimosso automaticamente al salvataggio
