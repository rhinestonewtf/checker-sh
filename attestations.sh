while IFS='=' read -r network url; do
    # Skip empty lines and comments
    [[ -z $network || $network == \#* ]] && continue
    
    printf "\nProcessing network: $network\n"

    # Check that registry is deployed 
    code=$(cast code 0x000000000069E2a187AEFFb852bF3cCdC95151B2 --rpc-url "$url")
    if [ "$code" == "0x" ]; then
        printf '%s\n' "Error: Registry not deployed on $network" >&2
        exit 1
    fi

    while IFS='=' read -r module address; do
        # Skip empty lines and comments
        [[ -z $network || $network == \#* ]] && continue
    
        # Check module
        code=$(cast call 0x000000000069E2a187AEFFb852bF3cCdC95151B2 "findAttestation(address,address)" $address 0x000000333034E9f539ce08819E12c1b8Cb29084d --rpc-url "$url")
        attestationTime=$(echo "$code" | cut -c 3-66)
        if [ "$attestationTime" == "0000000000000000000000000000000000000000000000000000000000000000" ]; then
            printf '%s\n' "Error: Attestation for $module not found on $network" >&2
        else 
            printf '%s\n' "$module ✓" >&2
        fi

    done < modules.txt

done < networks.txt
