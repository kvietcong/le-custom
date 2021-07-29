-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "C:\\Users\\minec\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\share\\lua\\5.1\\?.lua;C:\\Users\\minec\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\share\\lua\\5.1\\?\\init.lua;C:\\Users\\minec\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\luarocks\\rocks-5.1\\?.lua;C:\\Users\\minec\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\luarocks\\rocks-5.1\\?\\init.lua"
local install_cpath_pattern = "C:\\Users\\minec\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\lua\\5.1\\?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\gitsigns.nvim"
  },
  ["gruvbox-material"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\gruvbox-material"
  },
  ["haskell-vim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\haskell-vim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\indent-blankline.nvim"
  },
  kommentary = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\kommentary"
  },
  ["lightspeed.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\lightspeed.nvim"
  },
  ["lsp-colors.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\lsp-colors.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\lsp_signature.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\lualine.nvim"
  },
  ["material.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\material.nvim"
  },
  ["nord.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nord.nvim"
  },
  ["nvim-bufferline.lua"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-bufferline.lua"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-compe"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-lspconfig"
  },
  ["nvim-luapad"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-luapad"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-treesitter-textobjects"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\popup.nvim"
  },
  rainbow = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\rainbow"
  },
  ["registers.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\registers.nvim"
  },
  ["symbols-outline.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\symbols-outline.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\todo-comments.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\tokyonight.nvim"
  },
  ["trouble.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\trouble.nvim"
  },
  ["twilight.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\twilight.nvim"
  },
  ["vim-floaterm"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-floaterm"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-repeat"
  },
  ["vim-startuptime"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-startuptime"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-surround"
  },
  ["which-key.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\which-key.nvim"
  },
  ["wiki.vim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\wiki.vim"
  },
  ["zen-mode.nvim"] = {
    loaded = true,
    path = "C:\\Users\\minec\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\zen-mode.nvim"
  }
}

time([[Defining packer_plugins]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
