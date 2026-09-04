# Imagemagic `not authorized` to convert pdf

Edit `/etc/ImageMagick-6/policy.xml` to change the line

```
  <policy domain="coder" rights="read|write" pattern="PDF" />
```

# Extract png from pdf files

Converting pdf to png using `imagemagick` using
```
convert input.pdf -density 300 -quality 100 output.png
```
produces blurry and low quality images.

use `pdfimages` to extract png from pdfs.

# Batch resize images before I forget how to:
 
 This one resizes all the jpgs to 1024x768:
```
 find . -iname '*.jpg' -exec convert {} -resize 1024x768 {} \;
```

To ignore aspect ratio, use a `!` after the dimension like this
```
 find . -iname '*.jpg' -exec convert {} -resize 1024x768! {} \;
```

The following command will resize an image to a width of 200:
```
convert example.png -resize 200 example.png
```

The following command will resize an image to a height of 100:
```
convert example.png -resize x100 example.png
```

