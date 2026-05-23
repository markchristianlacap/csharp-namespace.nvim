# csharp-namespace.nvim

A Neovim plugin that provides intelligent C# namespace autocompletion based on your project structure and `.csproj` files.

## Features

- Automatic namespace suggestions based on file location and project structure
- Scans `.csproj` files to determine the correct namespace
- Works with `nvim-cmp`, `blink.cmp`, and Vim's built-in `completefunc`
- Fast and lightweight
- Only activates for C# files

## How It Works

When you type `namespace` in a C# file, the plugin:
1. Finds the nearest `.csproj` file in your project
2. Determines the project name from the `.csproj` file
3. Calculates the namespace based on the file's directory structure
4. Provides intelligent namespace completion suggestions

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim) with nvim-cmp

```lua
{
  "markchristianlacap/csharp-namespace.nvim",
  ft = "cs",
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    local cfg = require("csharp-namespace")
    cfg.setup({ nvim_cmp = true })

    local cmp = require("cmp")
    local config = cmp.get_config()
    table.insert(config.sources, {
      name = "csharp-namespace",
      group_index = 1,
      priority = 10000,
    })
    cmp.setup(config)
  end,
}
```

### Using with Vim's built-in completefunc

No completion plugin required. Uses `<C-x><C-u>` for omni-completion.

```lua
{
  "markchristianlacap/csharp-namespace.nvim",
  ft = "cs",
  config = function()
    require("csharp-namespace").setup({ completefunc = true })
  end,
}
```

### Using [lazy.nvim](https://github.com/folke/lazy.nvim) with blink.cmp

```lua
{
  "saghen/blink.cmp",
  dependencies = {
    "markchristianlacap/csharp-namespace.nvim",
  },
  opts = {
    sources = {
      default = { "csharp_namespace" },
      providers = {
        csharp_namespace = {
          module = "csharp-namespace.completion.blink",
          name = "C# Namespace",
        },
      },
    },
  },
}
```

## Usage

Simply start typing `namespace` in any C# file, and the plugin will automatically suggest the appropriate namespace based on your project structure.

**Example:**

```csharp
namespace | <- completions appear here
```

If your file is located at `MyProject/Controllers/HomeController.cs` and your project is named `MyProject`, the plugin will suggest `MyProject.Controllers`.

## Configuration

Pass options to `setup()` to enable integrations:

```lua
require("csharp-namespace").setup({
  nvim_cmp = true,      -- Register with nvim-cmp (default: false)
  completefunc = true,   -- Set up Vim's built-in completefunc (default: false)
})
```

## Structure

```
lua/csharp-namespace/
├── init.lua                  # Entry point / setup orchestrator
├── source.lua                # Core namespace logic
├── utils.lua                 # File scanning & string utilities
└── completion/
    ├── nvim-cmp.lua          # nvim-cmp adapter
    ├── blink.lua             # blink.cmp adapter
    └── completefunc.lua      # Vim built-in completefunc adapter
```

## Requirements

- Neovim >= 0.7.0
- A C# project with `.csproj` files
- Either `nvim-cmp`, `blink.cmp`, or no completion plugin (uses built-in `completefunc`)

## Troubleshooting

### Completions not appearing

1. Make sure you're working within a directory that contains a `.csproj` file
2. Verify that the filetype is set to `cs` (`:set ft?`)
3. Check that the source is properly registered with your completion plugin

### Incorrect namespace suggestions

The plugin calculates namespaces based on:
- The nearest `.csproj` file in the directory tree
- The relative path from the project file to your current file

Make sure your project structure follows standard C# conventions.

## Contributing

Contributions are welcome! Please feel free to:
- Submit bug reports or feature requests via [GitHub Issues](https://github.com/markchristianlacap/csharp-namespace.nvim/issues)
- Fork the repository and submit Pull Requests
- Improve documentation

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

Special thanks to the maintainers and contributors of:
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - The completion plugin for Neovim
- [blink.cmp](https://github.com/Saghen/blink.cmp) - A modern completion framework for Neovim

## Author

Created and maintained by [Mark Christian Lacap](https://github.com/markchristianlacap)

For questions or feedback, please open an issue on [GitHub](https://github.com/markchristianlacap/csharp-namespace.nvim/issues).
