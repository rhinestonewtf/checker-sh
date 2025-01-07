# Store arguments in arrays
networks=()
modules=()
while [[ $# -gt 0 ]]; do
   case "$1" in
       -n|--networks)
           shift
           while [[ $# -gt 0 && ! $1 =~ ^- ]]; do
               networks+=("$1")
               shift
           done
           ;;
       -m|--modules)
           shift
           while [[ $# -gt 0 && ! $1 =~ ^- ]]; do
               modules+=("$1")
               shift
           done
           ;;
   esac
done

while IFS='=' read -r network url; do
    # Skip empty lines and comments
    [[ -z $network || $network == \#* ]] && continue
    # Skip if networks specified and current one not included
   [[ ${#networks[@]} -gt 0 && ! " ${networks[@]} " =~ " ${network} " ]] && continue

    expanded_url=$(echo "$url" | envsubst)
    
    printf "\nProcessing network: $network\n"

    # Check that registry is deployed 
    code=$(cast code 0x000000000069E2a187AEFFb852bF3cCdC95151B2 --rpc-url "$expanded_url")
    if [ "$code" == "0x" ]; then
        printf '%s\n' "Error: Registry not deployed on $network" >&2
        exit 1
    fi

    while IFS='=' read -r module address; do
        # Skip empty lines and comments
        [[ -z $module || $module == \#* ]] && continue
        [[ ${#modules[@]} -gt 0 && ! " ${modules[@]} " =~ " ${module} " ]] && continue
    
        # Check module
        attestation=$(cast call 0x000000000069E2a187AEFFb852bF3cCdC95151B2 "findAttestation(address,address)" $address 0x000000333034E9f539ce08819E12c1b8Cb29084d --rpc-url "$expanded_url")
        attestationTime=$(echo "$attestation" | cut -c 3-66)
        if [ "$attestationTime" == "0000000000000000000000000000000000000000000000000000000000000000" ]; then
            code=$(cast code $address --rpc-url "$expanded_url")
            if [ "$code" == "0x" ]; then
                printf '%s\n' "Error: Module $module not deployed on $network" >&2
            else 
                printf '%s\n' "Error: Attestation for $module not found on $network" >&2
            fi
        else 
            printf '%s\n' "$module ✓" >&2
        fi

    done < modules.txt

done < networks.txt
