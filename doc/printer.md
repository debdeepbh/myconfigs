# Printing:
 
 to know the printer names attached to your computer: lpstat -v
 to make one of the printers the default one: lpoptions -d <printer_name>
 (sometimes this step is necessary)
 for printing files, use the syntax: lpr -P <printer_name> <filename>
 	the output will be of the format: device for <printer_name>: <device>
 Printing to PDF:
 	lpstat -P Print_to_PDF filename	(Here, by default, the printer name is Print_to_PDF)
 (Note: Sometimes, it produces blank pages i.e. does not print anything. In that case, delete the printer from Menu> Printing and add a generic cpus:/ printer with the name Print_to_PDF (If you want to use that name at all))
 
