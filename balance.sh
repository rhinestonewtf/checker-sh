while IFS='=' read -r network url; do
    # Skip empty lines and comments
    [[ -z $network || $network == \#* ]] && continue

    expanded_url=$(echo "$url" | envsubst)
    
    balance=$(cast balance 0xD1dcdD8e6Fe04c338aC3f76f7D7105bEcab74F77 --rpc-url "$expanded_url")
    formatted_balance=$(echo "$balance" | cast from-wei)
    printf "$network: $formatted_balance \n" 

done < networks.txt
