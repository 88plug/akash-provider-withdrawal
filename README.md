# akash-provider-withdrawal

```
docker run -it --mount type=bind,source="$(pwd)"/key.pem,target=/app/key.pem,readonly --env ONLY_NEGATIVE_BALANCES=false --env PASS=replace_with_key_pem_pass --env PROVIDER=yourprovider.com cryptoandcoffee/akash-provider-withdrawal
```
