# Workarounds

## Arch

### Mysql Workbench
Error message: `locale::facet::_S_create_c_locale name not valid`  
Workaround: Uncomment `en_US` in `/etc/locale.gen` and run `# locale-gen`  
Reference: https://bugs.mysql.com/bug.php?id=84908  

