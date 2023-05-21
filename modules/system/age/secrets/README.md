# Age Key generation
Generate a new key and save it to `id_age`.
```
age > id_age
```

# Encrypt a file
Ecrypt file with a public key `age14yfkmvcevwcakjql6pnc6875eh30g7v7p4znqrlu7zxeqy66agkq0k8lgu`. The file can be read only using a private key.
```
file=config; age --encrypt -r "age14yfkmvcevwcakjql6pnc6875eh30g7v7p4znqrlu7zxeqy66agkq0k8lgu" -o ${file}.age $file
```

# Edit encryped file
Edit encrypted file `config.age`. 
```
agenix -i ~/.secrets/id_age -e config.age
```

# SSH Key generation

## RSA-8192
Generate RSA-8192 code making 100 cycles. Use where ed25519 is not supported. 
AWS IAM doesn't yet have support for any algorithms other then RSA.
```
ssh-keygen -o -t rsa -a 100 -b 8192 -f ./github -C "konstantin.labun@gmail.com"
```

## ED25519
ED25519 considered a modern cryptography algorithm. It has shorter key and works significantly faster then RSA.
```
ssh-keygen -o -a 250 -t ed25519 -f ./github -C "konstantin.labun@gmail.com"
```
