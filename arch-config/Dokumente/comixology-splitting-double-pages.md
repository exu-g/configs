```
ls *.jpeg | sed 's,.*,& &,' | xargs -n 2 convert -crop 50%x100% +repage
```
-0 is the right page  
-1 is the left page  
