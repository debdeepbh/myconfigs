# Downloading zoom links

[zoomdl](https://github.com/Battleman/zoomdl)

```
zoomdl -u <http_link>
```

## Supplying a input file of Zoom urls

```bash
Lines=$(cat "$1")
for line in $Lines
do
    echo "$line"
    zoomdl -u "$line" &
done
```

