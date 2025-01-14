#!/bin/bash

# Store networks in array if provided, otherwise leave empty
networks=("$@")

while IFS='=' read -r network url; do
    # Skip empty lines and comments
    [[ -z $network || $network == \#* ]] && continue
    # Skip if networks specified and current one not included
   [[ ${#networks[@]} -gt 0 && ! " ${networks[@]} " =~ " ${network} " ]] && continue

    expanded_url=$(echo "$url" | envsubst)


    # Check required addresses
    ## Rhinestone Registry
    code=$(cast code 0x000000000069E2a187AEFFb852bF3cCdC95151B2 --rpc-url "$expanded_url")
    if [ "$code" == "0x" ]; then
        printf '%s\n' "Error: Rhinestone Registry not deployed" >&2
        exit 1
    fi
    printf '%s\n' "Rhinestone Registry deployed"

    ## Ensure schema is upgraded
    implementation_full=$(cast storage 0x86430e19d7d204807bbb8cda997bb57b7ee785dd 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc --rpc-url "$expanded_url")
    implementation=$(echo "$implementation_full" | cut -c 22-66)
    if [ "$implementation" == "a4c777199658a41688e9488c4ecbd7a2925cc23a" ]; then
        printf '%s\n' "Error: Schema not upgraded" >&2
        exit 1
    fi
    printf '%s\n' "Schema upgraded"

    ## Ensure resolver is upgraded
    implementation_full=$(cast storage 0xF0f468571e764664c93308504642aF941d9f77F1 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc --rpc-url "$expanded_url")
    implementation=$(echo "$implementation_full" | cut -c 22-66)
    if [ "$implementation" == "a4c777199658a41688e9488c4ecbd7a2925cc23a" ]; then
        printf '%s\n' "Error: Resolver not upgraded" >&2
        exit 1
    fi
    printf '%s\n' "Schema resolver"



done < <(curl -s https://raw.githubusercontent.com/rhinestonewtf/constants/refs/heads/main/networks.txt)

