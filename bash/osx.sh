# OSX specific environment

# Add brew bin files
if [[ -d /usr/local/bin ]]; then
  export PATH=$PATH:/usr/local/bin
fi

# Aliases
mvim_installed=`which mvim`
if [[ ! -z mvim_installed ]]; then
  alias vim='mvim -v'
fi

# Add GHC 7.10.2 to the PATH, via https://ghcformacosx.github.io/
ghc_app="/Applications/ghc-7.10.2.app"
if [[ -d $ghc_app ]]; then
  export GHC_DOT_APP=$ghc_app
  export PATH="${HOME}/.local/bin:${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
  # Haskell
  export PATH=$PATH:/Users/zaynetro/Library/Haskell/bin
fi

