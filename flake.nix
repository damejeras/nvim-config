{
  description = "neovim with the language servers, formatters and parsers this config expects";

  # No inputs: the module takes pkgs from the system that imports it. The lua itself is
  # not in the store on purpose — lazy.nvim writes lazy-lock.json back into its own
  # directory, and the config is edited in place. The module clones it instead.
  outputs =
    { self }:
    {
      homeManagerModules.default =
        {
          pkgs,
          config,
          lib,
          ...
        }:
        {
          programs.neovim = {
            enable = true;
            defaultEditor = true;
            # The lua lives at ~/.config/nvim as a clone, so home-manager must not write
            # an init.lua of its own there; it would collide with the clone. The lines it
            # would have written reach neovim as a --cmd argument instead, before the
            # cloned init.lua loads.
            sideloadInitLua = true;
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
              # treesitter compiles its parsers, and telescope-fzf-native compiles a .so —
              # its lazy.nvim spec disables the plugin outright when make is missing.
              gcc
              gnumake
              tree-sitter
            ];
          };

          # The clone, made once — the guard makes every later activation a no-op, and an
          # activation never updates it. https, because a freshly installed machine has no
          # ssh key yet; pushes go over ssh, which works once a key is on it.
          home.activation.nvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if [ ! -e ${config.xdg.configHome}/nvim ]; then
              run ${pkgs.git}/bin/git clone --quiet \
                https://github.com/damejeras/nvim-config.git \
                ${config.xdg.configHome}/nvim
              run ${pkgs.git}/bin/git -C ${config.xdg.configHome}/nvim \
                remote set-url --push origin git@github.com:damejeras/nvim-config.git
            fi
          '';
        };
    };
}
