local M = {}

--- Rileva l'interprete Python corretto cercando venv, poetry, pyenv, e fallback
--- @param root string|nil root directory del progetto (opzionale, autodetect se nil)
function M.get_python_path(root)
  -- 1. venv attivo
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV .. "/bin/python"
  end

  root = root or vim.fs.root(0, { "pyproject.toml", "setup.py", "requirements.txt", ".git" })

  -- 2-3. .venv o venv nella root del progetto
  if root then
    for _, venv_dir in ipairs({ ".venv", "venv" }) do
      local path = root .. "/" .. venv_dir .. "/bin/python"
      if vim.uv.fs_stat(path) then
        return path
      end
    end
  end

  -- 4. Poetry (venv esterno in ~/.cache/pypoetry/virtualenvs/)
  if root and vim.uv.fs_stat(root .. "/pyproject.toml") and vim.fn.executable("poetry") == 1 then
    local poetry_python = vim.fn.trim(vim.fn.system({ "poetry", "-C", root, "env", "info", "-e" }))
    if vim.v.shell_error == 0 and poetry_python ~= "" and vim.uv.fs_stat(poetry_python) then
      return poetry_python
    end
  end

  -- 5. pyenv
  if vim.fn.executable("pyenv") == 1 then
    local pyenv_python = vim.fn.trim(vim.fn.system({ "pyenv", "which", "python" }))
    if vim.v.shell_error == 0 and pyenv_python ~= "" then
      return pyenv_python
    end
  end

  -- 6. Fallback
  return "python3"
end

--- Ritorna venvPath e venv per basedpyright
--- @param root string|nil root directory del progetto
--- @return string|nil venv_path directory che contiene il venv
--- @return string|nil venv_name nome della directory del venv
function M.get_venv_info(root)
  -- 1. $VIRTUAL_ENV attivo
  if vim.env.VIRTUAL_ENV then
    local parent = vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":h")
    local name = vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t")
    return parent, name
  end

  root = root or vim.fs.root(0, { "pyproject.toml", "setup.py", "requirements.txt", ".git" })

  -- 2-3. .venv o venv nella root del progetto
  if root then
    for _, name in ipairs({ ".venv", "venv" }) do
      if vim.uv.fs_stat(root .. "/" .. name) then
        return root, name
      end
    end
  end

  -- 4. Poetry venv esterno
  if root and vim.uv.fs_stat(root .. "/pyproject.toml") and vim.fn.executable("poetry") == 1 then
    local poetry_path = vim.fn.trim(vim.fn.system({ "poetry", "-C", root, "env", "info", "-p" }))
    if vim.v.shell_error == 0 and poetry_path ~= "" and vim.uv.fs_stat(poetry_path) then
      local parent = vim.fn.fnamemodify(poetry_path, ":h")
      local name = vim.fn.fnamemodify(poetry_path, ":t")
      return parent, name
    end
  end

  return nil, nil
end

return M
