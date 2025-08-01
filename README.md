<h3 align="center">
    <!-- TODO: Add logo or something -->
	EverForest for <a href="https://nixos.org">Nix</a>
</h3>

<p align="center">
	<a href="https://github.com/mparusinski/everforest-nix/stargazers"><img src="https://img.shields.io/github/stars/mparusinski/everforest-nix?style=flat-square"></a>
	<a href="https://github.com/mparusinski/everforest-nix/issues"><img src="https://img.shields.io/github/issues/mparusinski/everforest-nix?style=flat-square"></a>
	<a href="https://github.com/mparusinski/everforest-nix/contributors"><img src="https://img.shields.io/github/contributors/mparusinski/everforest-nix?style=flat-square"></a>
	<a href="https://github.com/mparusinski/everforest-nix/blob/main/LICENSE"><img src="https://img.shields.io/github/license/mparusinski/everforest-nix?style=flat-square"></a>
</p>

## Previews

<!-- TODO: Create previews -->
|          | 🌕 Dark                                          | ☀️ Light                                           |
|----------|--------------------------------------------------|----------------------------------------------------|
| Hard     | ![hard-dark](assets/previews/hard-dark.webp)     | ![hard-light](assets/previews/hard-light.webp)     |
| Medium   | ![medium-dark](assets/previews/medium-dark.webp) | ![medium-light](assets/previews/medium-light.webp) |
| Soft     | ![soft-dark](assets/previews/soft-dark.webp)     | ![soft-light](assets/previews/soft-light.webp)     |

## Usage

<!-- TODO: Create a github pages for this -->
<!-- You will probably want to see our [Getting started guide](http://nix.catppuccin.com/getting-started/index.html), but as a TLDR: -->

1. Import the [NixOS](https://nixos.org) and [home-manager](https://github.com/nix-community/home-manager) modules

<details>
<summary>With Flakes</summary>

```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    everforest.url = "github:mparusinski/everforest-nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, everforest, home-manager }: {
    # for nixos module home-manager installations
    nixosConfigurations.lumberjackComputer = pkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        everforest.nixosModules.everforest
        # if you use home-manager
        home-manager.nixosModules.home-manager

        {
          # if you use home-manager
          home-manager.users.lumberjack = {
            imports = [
              ./home.nix
              everforest.homeModules.everforest
            ];
          };
        }
      ];
    };

    # for standalone home-manager installations
    homeConfigurations.lumberjack = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./home.nix
        everforest.homeModules.everforest
      ];
    };
  };
}
```

</details>

<details>
<summary>With Nix Channels</summary>

```bash
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
sudo nix-channel --add https://github.com/mparusinski/everforest-nix/archive/main.tar.gz everforest
sudo nix-channel --update
```

For [NixOS module installations](https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module):

```nix
{
  imports = [
    <everforest/modules/nixos>
    # if you use home-manager
    <home-manager/nixos>
  ];

  # if you use home-manager
  home-manager.users.lumberjack = {
    imports = [
      <everforest/modules/home-manager>
    ];
  };
}

```

For [standalone installations](https://nix-community.github.io/home-manager/index.html#sec-install-standalone)

```nix
{
  imports = [
    <everforest/modules/home-manager>
  ];

  home.username = "lumberjack";
  programs.home-manager.enable = true;
}
```

</details>

2. In your configuration, choose your desired flavor with `everforest.flavor`

```nix
{
  everforest.flavor = "hard-dark";
}
```

3. Enable for supported programs

```nix
{
  everforest.starship.enable = true;
}
```

4. Enable for all available programs you're using!

```nix
{
  everforest.enable = true;
}
```

<!--
## 🙋 FAQ

- Q: **"How do I know what programs are supported?"**\
  A: You can find programs supported through home-manager [here](https://nix.catppuccin.com/search/rolling/?scope=home-manager+modules),
  and NixOS modules [here](https://nix.catppuccin.com/search/rolling/?scope=NixOS+modules)

- Q: **"How do I set `everforest.enable` for everything I use?"**\
  A: You can set `everforest.enable` globally through home-manager [here](https://nix.catppuccin.com/search/rolling/?option_scope=1&option=catppuccin.enable),
  and NixOS modules [here](https://nix.catppuccin.com/search/rolling/?option_scope=0&option=catppuccin.enable)

- Q: **"What versions of NixOS and home-manager are supported?"**\
  A: We primarily support the `unstable` branch, but try our best to support the current stable release.
  You can check if your stable release is currently supported at [status.nixos.org](https://status.nixos.org/)

- Q: **"How do I fix the error: ... during evaluation because the option 'allow-import-from-derivation' is disabled"**\
  A: Some ports need to read and/or manipulate remote resources, resulting in Nix performing [IFD](https://nix.dev/manual/nix/latest/language/import-from-derivation).
  We try to avoid this where possible, but sometimes we need to use it. Check out [our tracking issue](https://github.com/catppuccin/nix/issues/392) to see what ports are affected.

- Q: **"How do I fix the error: a '...' with features {} is required to build '...'"?**\
  A: See the above
-->

## 💝 Thanks to

- [sainnhe](https://github.com/sainnhe) Creator of Everforest
- [getchoo](https://github.com/getchoo) Creator of Catppuccin for Nix

