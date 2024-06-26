# Getting started with compilation
## Pre-requisites

- [TexLive (full)](https://www.tug.org/texlive/quickinstall.html)
- NB! Linux users: Powershell Core works on Linux, macOS and others. Yes, life happened while you were busy bashing.
- [Powershell Core](https://github.com/powershell/powershell#get-powershell) (works on linux, macOS and others)
    - Ensure you have set Powershell execution-policy to unrestricted: 

            > Set-ExecutionPolicy Unrestricted

        https://thinkpowershell.com/powershell-execution-policy-explained/
- Install fonts from Layout/fonts. Make sure to install them for system wide / for all users

## How to compile
1. Open powershell prompt and goto to git dir
2. Use **compile.ps1** for compilation found in the root
    
## Usage

    > .\Compile.ps1 [[-books] <string[]>] [-release]

## Parameter description
- **books**: Comma-separated list of book acronyms (short id). You can also specify collections. See full list below.

- **release**: Compiles each book 3 x (release) mode if set. 1 x (debug) if *not* set

## Examples
- Compile single book (ID) for debug:

        PS> .\compile.ps1 id

- Compile single book (VC) for release (3x compilation):

        PS> .\compile.ps1 vc -release

- Compile multiple books (VC+AC+SA) for release (3 x compilation):

        PS> .\compile.ps1 vc,ac,sa -release

- Compile Rulebook, Arcane Compendium, army books and Supplements:

        PS> .\compile.ps1 CoreRules,Supplements

- Compile EoS and Supplements:

        PS> .\compile.ps1 eos,Supplements

### **Books** allowed values:
        - All:
          - Core Rules:
            - Rulebook: Rulebook
            - AC: Arcane Compendium

            - BH: Beast Heards
            - DL: Daemon Legions
            - DE: Dread Elves
            - DH: Dwarven Holds
            - EoS: Empire of Sonnstahl
            - HE: Highborn Elves
            - ID: Infernal Dwarves
            - KoE: Kingdom of Equitane
            - OK: Ogre Kingdom
            - OnG: Orcs 'n Goblins
            - SA: Saurian Ancients
            - SE: Sylvan Elves
            - UD: Undying Dynasties
            - VC: Vampire Covenant
            - VS: The Vermin Swarm
            - WDG: Warriors of the Dark Gods
          - Supplements:
            - ASK = Åsklanders
            - CUL = Cultists
            - HG = HobGoblins
            - MAK = Makhar
            - GIA = Giants      
