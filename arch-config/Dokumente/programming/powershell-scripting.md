# Powershell scripting

Use PowerShell ISE to develop PowerShell scripts  

## Comparison operators

| operator | description          |
| -------- | -----------          |
| -eq      | equals               |
| -ne      | not equals           |
| -gt      | greather than        |
| -ge      | greater or equals to |
| -lt      | less than            |
| -le      | less or equals to    |

## Remoting

### Allow recieving remote commands
Run as Administrator  
IMPORTANT: Network must not be set to public  
```
Enable-PSRemoting
```

### Add to trusted list
Clients have to be added to the trusted list if there are no other authentication methods used.  
Multiple clients can be added when separated by commas.  
*Note: The command below overwrites every other value set in "trustedhosts".*
```
Set-Item WSMan:localhost\client\trustedhosts -value '(ip address/hostname)'
```

Example:  
```
Set-Item WSMan:localhost\client\trustedhosts -value '192.168.1.117,win10-2-lin,192.168.1.118,win10-3-lin'
```

### Run command on multiple remote pcs

```
Invoke-Command -ComputerName (pc1), (pc2) -ScriptBlock {(command)}
```

```
Invoke-Command -ComputerName (pc1), (pc2) -ScriptBlock {(command1)
(command2)}
```

Example for issuing multiple commands after each other:  
">>" is added automatically on newline  
```
Invoke-Command -ComputerName win10-2-lin, win10-3-lin -ScriptBlock {cd c:\Users\admin
>> New-Item "test.txt" -ItemType File}
```

### Run script on multiple remote pcs

```
Invoke-Command -ComputerName (pc1), (pc2) -FilePath 'path\to\script'
```





