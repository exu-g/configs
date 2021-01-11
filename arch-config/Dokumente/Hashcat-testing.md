# Hashcat

## Benchmark performance
```bash
hashcat --benchmark
```

## Wordlists

## Cracking
```bash
hashcat -a 0 -m 0 <inputfile>.txt -o passwords.txt <path/to/wordlist>.txt --disable-potfile
```

### Useful options

-a [num]: attack mode  
-m [num]: hash type  
-D [num]: openCL device to use. Multiple are separated with commas.  

# Generate md5 hash

Also outputs the hash into a file.  
```bash
openssl passwd -1 > <file>.txt
```
