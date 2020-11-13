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

## Arrays
Initialise arrays like this:  
```
$(arrayname) = @("item1", "item2", "item3")
```

There are two methods for looping over arrays:  

**Method 1**  
```
foreach ($(itemname) in $(arrayname)) {
    (command)
    //To get the item from the array use $(itemname)
}
```

**Method 2**
```
for ($i = 0; $i -lt $(arrayname).count; $i++) {
    (command)
    //To get the item from the array use $(arrayname)[$i]
}
```

## Operations in the filesystem
Test whether a file or directory exists  
```
Test-Path "(path)"
```

### files
Create a new file  
```
New-Item -Path "(filepath)" -ItemType File
```

Remove a file  
```
Remove-Item "(filepath)"
```

Set file content  
```
Set-Content "(filepath)" ("(content)")
```

Example using multiple lines  
```
Set-Content "C:\temp\test.txt" ("This is a very complex sentence. " + "`r`n" + "This sentence should be on the second line.")
```

Apend content to a file  
```
Add-Content "(filepath)" ("(content)")
```

Show a file's content  
```
Get-Content "(filepath)"
```

### directories
Create new directory  
```
New-Item -Path "(directorypath)" -ItemType Directory
```

Remove directory including contained files  
```
Remove-Item "(directorypath)" -Recurse
```

Copy directory  
```
Copy-Item "(inputpath)" -Recurse "(destinationpath)"
```

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





