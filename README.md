# csharp-namespace.nvim

`csharp-namespace.nvim` is a Neovim plugin designed to enhance C# development by providing namespace completions. It integrates seamlessly with `nvim-cmp` to offer a better coding experience for C# developers.

## Installation

Using `lazy.nvim` as the plugin manager, add the following configuration to your Neovim setup:

```lua
return {
  {
    "markchristianlacap/csharp-namespace.nvim",
    ft = "cs",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("csharp-namespace").setup {}
      local cmp = require "cmp"
      local config = cmp.get_config()
      table.insert(config.sources, {
        name = "csharp-namespace",
        group_index = 1,
        priority = 10000,
      })
      cmp.setup(config)
    end,
  },
}
```

## Usage

Once installed, the plugin automatically provides namespace completions for C# files. No additional configuration is necessary beyond the initial setup.

## Configuration

You can customize the behavior of `csharp-namespace.nvim` by passing options to the `setup` function. Here is an example of the available configuration options and their defaults:
### Using `nvim-cmp`
```lua
require("csharp-namespace").setup {}

cmp.setup({
  sources = cmp.config.sources({
    { name = 'csharp-namespace' }
  })
})

```

### Using `blink.cmp`
```lua
{
    'rafamadriz/friendly-snippets',
    -- add to dependencies
    dependencies = {
      'markchristianlacap/csharp-namespace.nvim',
    },
    opts = {
        sources = {
            default = {
                --  add to sources
                'csharp_namespace'
            },
            -- configure providers
            providers = {
              csharp_namespace = {
                module = "blink-csharp-namespace",
                name = "C# Namespace",
                opts = {}
              },
            },
        }
    }
}
``` 
## Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an Issue on GitHub.

## License

This project is licensed under the MIT License.

## Acknowledgements

Special thanks to the contributors of [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) and [blink-cmp](https://github.com/Saghen/blink.cmp) for their amazing work in providing a powerful completion engine for Neovim.

## Contact

For any questions or feedback, you can reach out via [GitHub Issues](https://github.com/markchristianlacap/csharp-namespace.nvim/issues).
