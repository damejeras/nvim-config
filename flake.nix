{
  description = "neovim with the language servers, formatters and parsers this config expects";

  # No inputs: the module takes pkgs from the system that imports it. The config itself is
  # not in here on purpose; it is cloned to ~/.config/nvim and edited in place.
  outputs =
    { self }:
    {
      homeManagerModules.default =
        { pkgs, ... }:
        {
          programs.neovim = {
            enable = true;
            defaultEditor = true;
            # What mason installs on other systems. On NixOS mason's downloads do not run,
            # so they come from nixpkgs and mason has nothing to do.
            extraPackages = with pkgs; [
              gopls
              gofumpt
              gotools # goimports
              lua-language-server
              stylua
              prettier
              buf
              ruff
              pyright
              helm-ls
              templ
              terraform-ls
              yaml-language-server
              zls
              # treesitter compiles its parsers.
              gcc
              tree-sitter
            ];
          };
        };
    };
}
