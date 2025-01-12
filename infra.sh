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

    ## Ensure schema is registered
    code=$(cast call 0x000000000069E2a187AEFFb852bF3cCdC95151B2 "findSchema(bytes32)" 0x93d46fcca4ef7d66a413c7bde08bb1ff14bacbd04c4069bb24cd7c21729d7bf1 --rpc-url "$expanded_url")
    registrationTime=$(echo "$code" | cut -c 67-130)
    if [ "$registrationTime" == "0000000000000000000000000000000000000000000000000000000000000000" ]; then
        printf '%s\n' "Error: Schema not registered" >&2
        exit 1
    fi
    printf '%s\n' "Schema registered"

    ## Ensure resolver is registered
    resolverRecord=$(cast call 0x000000000069E2a187AEFFb852bF3cCdC95151B2 "findResolver(bytes32)" 0xdbca873b13c783c0c9c6ddfc4280e505580bf6cc3dac83f8a0f7b44acaafca4f --rpc-url "$expanded_url")
    if [ "$resolverRecord" == "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" ]; then
        printf '%s\n' "Error: Resolver not registered" >&2
        exit 1
    fi
    printf '%s\n' "Resolver registered"

done < <(curl -s https://raw.githubusercontent.com/rhinestonewtf/constants/refs/heads/main/networks.txt)

