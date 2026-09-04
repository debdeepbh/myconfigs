# Rclone with gdrive

```
rclone sync ~/gdrive/talk gdrive:talk -P --dry-run
```

- Upload  (additive, safe)

```
rclone copy ~/gdrive/paper-org gdrive:paper-org --dry-run -P
```

- Upload  (could be destructive, unsafe)
```
rclone sync ~/gdrive/paper-org gdrive:paper-org --dry-run -P
```

- Download (could be destructive, unsafe)

```
rclone sync gdrive:paper-org ./paper-org --dry-run -P
```

- rclone copy - Copy files from source to dest, skipping already copied.
- rclone sync - Make source and dest identical, modifying destination only.
- rclone bisync	- Bidirectional synchronization between two paths.

